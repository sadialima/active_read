import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextformField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?) validator;

  const TextformField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.obscure,
    this.suffixIcon,
    required this.keyboardType,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.purple.shade900,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: Icon(icon, color: Colors.purple.shade700),
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.purple.shade600,
            ),
            filled: true,
            fillColor: Colors.purple.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.purple.shade400, width: 2),
            ),
          ),
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      ],
    );
  }
}