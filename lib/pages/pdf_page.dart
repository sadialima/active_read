import 'package:active_read/pages/dictionary.dart';
import 'package:active_read/pages/add_note_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';

class ReaderPage extends StatefulWidget {
  final String bookTitle;
  final String pdfUrl;

  const ReaderPage({
    super.key,
    required this.bookTitle,
    required this.pdfUrl,
  });

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  String get viewerUrl => "https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(widget.pdfUrl)}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FA),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        foregroundColor: Colors.purple.shade900,
        title: Text(
          widget.bookTitle,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: "Add Note",
            icon: const Icon(Icons.note_add_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditorPage(bookTitle: widget.bookTitle),
                ),
              );
            },
          ),
          IconButton(
            tooltip: "Dictionary",
            icon: const Icon(Icons.menu_book_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DictionaryPage(bookTitle: widget.bookTitle),
                ),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: InAppWebView(
          key: ValueKey(widget.pdfUrl),
          initialUrlRequest: URLRequest(url: WebUri(viewerUrl)),
        ),
      ),
    );
  }
}
