import 'package:flutter/material.dart';

class TopRightButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const TopRightButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  double getScaleFactor(double width) {
    if (width <= 600) {
      return (width / 450).clamp(0.8, 1.2); // Mobile
    } else if (width <= 1024) {
      return (width / 800).clamp(0.6, 1.0); // Tablet
    } else {
      return (width / 1400).clamp(0.5, 0.8); // Desktop
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate scaleFactor based on screen width
    double scaleFactor = getScaleFactor(screenWidth);

    // Responsive sizes
    double buttonHeight = 32 * scaleFactor;
    double buttonWidth = 100 * scaleFactor;
    double iconSize = 16 * scaleFactor;
    double fontSize = 12 * scaleFactor;

    return Positioned(
      top: 16 * scaleFactor, // Jarak dari atas
      right: 16 * scaleFactor, // Jarak dari kanan
      child: SizedBox(
        height: buttonHeight,
        width: buttonWidth,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white, // Background color
            side: BorderSide(color: color, width: 2), // Border color
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: color, // Icon color
              ),
              SizedBox(width: 10 * scaleFactor), // Spacing between icon and text
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  color: color, // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
