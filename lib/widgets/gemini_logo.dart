import 'package:flutter/material.dart';

/// Custom widget untuk logo Gemini AI
/// Menggunakan gradient warna yang mirip dengan logo asli Gemini
class GeminiLogo extends StatelessWidget {
  final double size;
  final Color? backgroundColor;

  const GeminiLogo({super.key, this.size = 24.0, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEA4335), // Red
            Color(0xFFFBBC04), // Yellow
            Color(0xFF34A853), // Green
            Color(0xFF4285F4), // Blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomPaint(painter: GeminiIconPainter(), size: Size(size, size)),
    );
  }
}

/// Custom painter untuk menggambar icon Gemini
class GeminiIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    // Gambar bentuk diamond/star seperti logo Gemini
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width * 0.3;

    // Buat bentuk diamond dengan 4 titik
    path.moveTo(centerX, centerY - radius); // Top
    path.lineTo(centerX + radius * 0.7, centerY); // Right
    path.lineTo(centerX, centerY + radius); // Bottom
    path.lineTo(centerX - radius * 0.7, centerY); // Left
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
