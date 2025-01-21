import 'package:atloud/settings/settings.dart';
import 'package:atloud/theme/colors.dart';
import 'package:flutter/material.dart';

import '../theme/fonts.dart';

class FooterWidget extends StatelessWidget {
  final _buttonSize = 70.0;
  final String text;
  final Function() actionOnText;
  final Function()? cleanAction;

  const FooterWidget({super.key, required this.text, required this.actionOnText, this.cleanAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
      child: Row(
        children: [
          SizedBox(width: _buttonSize),
          Expanded(
            child: TextButton(
                onPressed: actionOnText,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: CustomColors.textColor,
                    fontFamily: CustomFonts.openSans.value,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4.0,
                  ),
                )),
          ),
          IconButton(
            icon: Icon(Icons.settings, size: _buttonSize, color: CustomColors.textColor),
            onPressed: () {
              cleanAction?.call();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
          ),
        ],
      ),
    );
  }
}
