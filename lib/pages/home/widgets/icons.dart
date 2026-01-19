  import 'package:flutter/material.dart';

Widget circularActionBtnhome(IconData icon, Color iconColor, Color bgColor , ) {
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }

  Widget circularActionBtn(IconData icon, Color iconColor, Color bgColor , ) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }