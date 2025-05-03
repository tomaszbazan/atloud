import 'package:atloud/theme/theme.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Function()? incrementShowVersionCounter;

  const AppBarWidget({super.key, required this.text, this.incrementShowVersionCounter});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(10.0, 20.0, 10.0, 0.0),
      child: Column(
        children: [
          AppBar(title: TextButton(
            onPressed: incrementShowVersionCounter != null ? () => incrementShowVersionCounter!() : null,
            child: Text(text, style: CustomTheme.lightTheme.appBarTheme.titleTextStyle)
          ), automaticallyImplyLeading: false),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}
