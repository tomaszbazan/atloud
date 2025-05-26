import 'dart:io' show Platform;

import 'package:atloud/components/app_bar.dart';
import 'package:atloud/components/footer.dart';
import 'package:atloud/services/airtable_service.dart';
import 'package:atloud/shared/available_page.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _appWorksController = TextEditingController();
  final _featuresController = TextEditingController();

  bool _isLoading = false;
  bool _isSubmittedSuccessfully = false;

  @override
  void dispose() {
    _emailController.dispose();
    _appWorksController.dispose();
    _featuresController.dispose();
    super.dispose();
  }

  Future<String> _getDeviceInfo() async {
    String deviceInfoString = "Device Info Not Available";

      // Ensure context is still valid before accessing MediaQuery
      if (!mounted) return "Context not available for MediaQuery";
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final pixelRatio = MediaQuery.of(context).devicePixelRatio;
      String screenInfo = "Ekran: ${screenWidth.toStringAsFixed(0)}x${screenHeight.toStringAsFixed(0)} @${pixelRatio.toStringAsFixed(1)}x";

    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceInfoString = 'Model: ${androidInfo.model} \n'
            'Wersja androida: ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt}) \n'
            '$screenInfo';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceInfoString = 'iOS Version: ${iosInfo.systemVersion}, Model: ${iosInfo.model}, '
            'Name: ${iosInfo.name}, System Name: ${iosInfo.systemName}, '
            'Machine: ${iosInfo.utsname.machine}, $screenInfo';
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfoPlugin.linuxInfo;
        deviceInfoString = 'Linux: ${linuxInfo.prettyName}, $screenInfo';
      } else if (Platform.isMacOS) {
        final macOsInfo = await deviceInfoPlugin.macOsInfo;
        deviceInfoString = 'MacOS: ${macOsInfo.model} ${macOsInfo.osRelease}, $screenInfo';
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfoPlugin.windowsInfo;
        deviceInfoString = 'Windows: ${windowsInfo.productName}, Build: ${windowsInfo.buildNumber}, $screenInfo';
      }
    } catch (e) {
      deviceInfoString = "Error getting device info: $e, $screenInfo";
    }
    return deviceInfoString;
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final deviceInfo = await _getDeviceInfo();
      final error = await AirtableService.sendFeedback(
        email: _emailController.text,
        appWorksCorrectly: _appWorksController.text,
        futureFunctionalities: _featuresController.text,
        deviceInfo: deviceInfo,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)),
            );
          } else {
            _isSubmittedSuccessfully = true;
          }
        });
      }
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'To pole jest wymagane';
        }
        if (isEmail) {
          if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
            return 'Wprowadź poprawny adres e-mail';
          }
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: 'OPINIA'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isSubmittedSuccessfully
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
                    SizedBox(height: 20),
                    Text(
                      'Dziękujemy za Twoją opinię!',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              )
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(_emailController, 'Adres e-mail', isEmail: true),
                    const SizedBox(height: 16),
                    _buildTextField(_appWorksController, 'Czy aplikacja ogólnie działa poprawnie?', maxLines: 3),
                    const SizedBox(height: 16),
                    _buildTextField(_featuresController, 'Czy są jakieś funkcjonalności, które chciałbyś mieć w aplikacji na przyszłość?', maxLines: 5),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _submitFeedback,
                            style: CustomTheme.primaryButtonStyle,
                            child: Text('WYŚLIJ', style: CustomTheme.primaryButtonTextTheme),
                          ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: const FooterWidget(currentPage: AvailablePage.feedback),
    );
  }
}
