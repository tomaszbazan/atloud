import 'dart:io' show Platform;

import 'package:atloud/components/app_bar.dart';
import 'package:atloud/components/footer.dart';
import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/services/airtable_exception.dart';
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
    final localizations = AppLocalizations.of(context)!;
    String deviceInfoString = localizations.deviceInfoNotAvailable;

      // Ensure context is still valid before accessing MediaQuery
      if (!mounted) return localizations.contextNotAvailable;
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final pixelRatio = MediaQuery.of(context).devicePixelRatio;
      String screenInfo = localizations.screenInfo(screenWidth.toStringAsFixed(0), screenHeight.toStringAsFixed(0), pixelRatio.toStringAsFixed(1));

    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceInfoString = '${localizations.deviceModel(androidInfo.model)} \n'
            '${localizations.androidVersion(androidInfo.version.release, androidInfo.version.sdkInt.toString())} \n'
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
      deviceInfoString = localizations.errorGettingDeviceInfo(e.toString(), screenInfo);
    }
    return deviceInfoString;
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final deviceInfo = await _getDeviceInfo();
      await AirtableService.sendFeedback(
        email: _emailController.text,
        appWorksCorrectly: _appWorksController.text,
        futureFunctionalities: _featuresController.text,
        deviceInfo: deviceInfo,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSubmittedSuccessfully = true;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      final localizations = AppLocalizations.of(context)!;
      final errorMessage = e is AirtableException
          ? localizations.airtableApiError(e.statusCode.toString(), e.reasonPhrase ?? '')
          : localizations.airtableSendError(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, bool isEmail = false}) {
    final localizations = AppLocalizations.of(context)!;
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return localizations.fieldRequired;
        }
        if (isEmail) {
          if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
            return localizations.invalidEmail;
          }
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBarWidget(text: localizations.feedbackTitle),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isSubmittedSuccessfully
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
                    const SizedBox(height: 20),
                    Text(
                      localizations.thankYouMessage,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          _buildTextField(_emailController, localizations.emailField, isEmail: true),
                          const SizedBox(height: 16),
                          _buildTextField(_appWorksController, localizations.appWorksField, maxLines: 3),
                          const SizedBox(height: 16),
                          _buildTextField(_featuresController, localizations.featuresField, maxLines: 4),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitFeedback,
                              style: CustomTheme.primaryButtonStyle(context),
                              child: Text(localizations.sendButton, style: CustomTheme.primaryButtonTextTheme(context)),
                            ),
                          ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: const FooterWidget(currentPage: AvailablePage.feedback),
    );
  }
}
