import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteCard extends StatelessWidget {
  final String bookTitle;
  final String noteText;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.bookTitle,
    required this.noteText,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 253, 248, 248),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.shade100.withOpacity(0.4),
            blurRadius: 12,
            
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bookTitle,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.purple.shade900,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            noteText,
            style: GoogleFonts.roboto(
              fontSize: 16,
              height: 1.6,
              color: Colors.purple.shade800,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                tooltip: "Edit",
                onPressed: onEdit,
                icon: Icon(Icons.edit, color: Colors.purple.shade700, size: 28),
              ),
              IconButton(
                tooltip: "Delete",
                onPressed: onDelete,
                icon: Icon(Icons.delete_rounded, color: Colors.purple.shade500, size: 28),
              ),
            ],
          ),
        ],
      ),
    );
  }
}