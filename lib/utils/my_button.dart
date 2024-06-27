import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String icon;
  final String buttonText;
  const MyButton({super.key, required this.icon, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add your onTap functionality here
      },
      child: Column(
        children: [
          Container(
            height: 80,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 255, 255, 255),
                  blurRadius: 40,
                  spreadRadius: 10,
                )
              ],
            ),
            child: Center(
              child: Image.asset(icon),
            ),
          ),
          const SizedBox(height: 12),
          // text
          Text(
            buttonText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
