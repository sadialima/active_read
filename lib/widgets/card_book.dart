import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:active_read/pages/pdf_page.dart';

class BookCard extends StatelessWidget {
  final Map<String, dynamic> book;
  final bool isAdmin;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BookCard({
    super.key,
    required this.book,
    required this.isAdmin,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final title = book['title'] ?? 'Untitled';
    final author = book['author'] ?? '';
    final genre = book['genre'] ?? '';
    final coverUrl = book['cover_url'] ?? '';
    final pdfUrl = book['pdf_url'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 140,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 227, 223, 221),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: Image.network(
              coverUrl,
              width: 85,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.purple.shade900),
                        ),
                      ),
                      if (isAdmin)
                        PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'edit') onEdit();
                            if (value == 'delete') onDelete();
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Text("Edit")),
                            PopupMenuItem(value: 'delete', child: Text("Delete")),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(author, style: GoogleFonts.roboto(fontSize: 14, color: Colors.purple.shade700)),
                  const SizedBox(height: 4),
                  Text(genre, style: GoogleFonts.roboto(fontSize: 14, color: Colors.purple.shade700)),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: pdfUrl.isEmpty ? null : () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReaderPage(bookTitle: title, pdfUrl: pdfUrl)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade400,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(80, 35),
                      ),
                      child: Text("Read", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 