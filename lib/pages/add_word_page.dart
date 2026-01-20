import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VocabularyEditorPage extends StatefulWidget {
  final String bookTitle;
  final String word;   
  final String meaning; 

  const VocabularyEditorPage({
    super.key,
    required this.bookTitle,
    required this.word,
    required this.meaning,
  });

  @override
  State<VocabularyEditorPage> createState() => _VocabularyEditorPageState();
}

class _VocabularyEditorPageState extends State<VocabularyEditorPage> {
  final _ex1C = TextEditingController();
  final _ex2C = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _ex1C.dispose();
    _ex2C.dispose();
    super.dispose();
  }
  Future<void> _save() async {
    setState(() => _saving = true);

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in")),
      );
      setState(() => _saving = false);
      return;
    }

    try {
      await Supabase.instance.client.from('vocabulary').insert({
        'user_id': user.id,
        'book_title': widget.bookTitle,
        'word': widget.word,
        'meaning': widget.meaning,
        'example_1': _ex1C.text.trim(),
        'example_2': _ex2C.text.trim(),
      });

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Save failed")),
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
        title: Text("Add Word", style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.book_rounded, color: Colors.purple.shade700, size: 20),
                    const SizedBox(width: 8),
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
                    boxShadow: [BoxShadow(color: Colors.purple.shade100.withOpacity(0.5))],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.word,
                          style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.purple.shade900),
                        ),
                         SizedBox(height: 20),
                        Text(
                          widget.meaning,
                          style: GoogleFonts.poppins(fontSize: 18, height: 1.6, color: Colors.purple.shade800),
                        ),
                         SizedBox(height: 40),
                        Text("Example 1 (optional)", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                         SizedBox(height: 8),
                        TextField(
                          controller: _ex1C,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Write a sentence using the word...",
                            filled: true,
                            fillColor: Colors.purple.shade100,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text("Example 2 (optional)", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        TextField(
                          controller: _ex2C,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Another example...",
                            filled: true,
                            fillColor: Colors.purple.shade50,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ],
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
                    backgroundColor: Colors.purple.shade600,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 10,
                  ),
                  child: _saving
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Save to Vocabulary",
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