import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const AppBarWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(10.0, 20.0, 0.0, 10.0),
      child: Column(
        children: [
          AppBar(title: Text(text), automaticallyImplyLeading: false),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90.0);
}
