import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditNoteDialog extends StatefulWidget {
  final Map<String, dynamic> note;

  const EditNoteDialog({super.key, required this.note});

  @override
  State<EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  late final TextEditingController _controller;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note['note'] ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => saving = true);

    try {
      await Supabase.instance.client
          .from('notes')
          .update({'note': text})
          .eq('id', widget.note['id']);

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Update failed", style: GoogleFonts.poppins()),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookTitle = widget.note['book_title'] ?? 'General';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.white, 
      title: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        decoration: BoxDecoration(
          color: Colors.purple.shade100,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Edit Note",
              style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple.shade900),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.book_rounded, size: 18, color: Colors.purple.shade700),
                const SizedBox(width: 8),
                Text(
                  bookTitle,
                  style: GoogleFonts.poppins(fontSize: 15, color: Colors.purple.shade800),
                ),
              ],
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: double.infinity,
        child: TextField(
          controller: _controller,
          maxLines: 10,
          style: GoogleFonts.poppins(fontSize: 17),
          decoration: InputDecoration(
            hintText: "Update your note, quote, or idea...",
            hintStyle: GoogleFonts.poppins(fontSize: 17, color: Colors.grey.shade600),
            filled: true,
            fillColor: Colors.purple.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: GoogleFonts.poppins(fontSize: 18, color: Colors.purple.shade700)),
        ),
        ElevatedButton(
          onPressed: saving ? null : _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple.shade600,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 8,
          ),
          child: saving
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
              : Text(
                  "Save Changes",
                  style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
        ),
        const SizedBox(width: 12),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
    );
  }
}