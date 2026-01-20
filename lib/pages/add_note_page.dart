import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteEditorPage extends StatefulWidget {
  final String bookTitle;

  const NoteEditorPage({super.key, required this.bookTitle});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note cannot be empty")),
      );
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in")),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      await Supabase.instance.client.from('notes').insert({
        'user_id': user.id,
        'book_title': widget.bookTitle,
        'note': text,
      });

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Save failed: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.purple.shade900,
        title: Text("Add Note", style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.book_rounded, color: Colors.purple.shade700),
                    SizedBox(width: 8),
                    Text(
                      widget.bookTitle,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.purple.shade900),
                    ),
                  ],
                ),
              ),
             SizedBox(height: 30),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.purple.shade100.withOpacity(0.5), blurRadius: 20)],
                  ),
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    maxLines: null,
                    style: GoogleFonts.roboto(fontSize: 18, height: 1.6),
                    decoration: InputDecoration(
                      hintText: "Write your note, quote, or idea here...",
                      hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey.shade500),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade400,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 10,
                    shadowColor: Colors.purple.shade300,
                  ),
                  child: _saving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Save Note",
                          style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}