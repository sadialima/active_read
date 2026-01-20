import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WordCard extends StatelessWidget {
  final Map<String, dynamic> word;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const WordCard({
    super.key,
    required this.word,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      shadowColor: Colors.purple.shade100.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    word['word'],
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade900,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.purple.shade600, size: 28),
                  tooltip: "Edit",
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete_rounded, color: Colors.purple.shade500, size: 28),
                  tooltip: "Delete",
                  onPressed: () => onDelete(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              word['meaning'],
              style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.purple.shade800),
            ),
            if (word['example_1']?.toString().isNotEmpty == true) ...[
              const SizedBox(height: 16),
              Text(
                "Ex: ${word['example_1']}",
                style: GoogleFonts.poppins(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.purple.shade700),
              ),
            ],
            if (word['example_2']?.toString().isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(
                "Ex: ${word['example_2']}",
                style: GoogleFonts.poppins(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.purple.shade700),
              ),
            ],
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.book_rounded, size: 16, color: Colors.purple.shade700),
                    const SizedBox(width: 6),
                    Text(
                      word['book_title'],
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.purple.shade900),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}