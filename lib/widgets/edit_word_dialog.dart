import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditWordDialog extends StatefulWidget {
  final Map<String, dynamic> word;

  const EditWordDialog({super.key, required this.word});

  @override
  State<EditWordDialog> createState() => _EditWordDialogState();
}

class _EditWordDialogState extends State<EditWordDialog> {
  late final TextEditingController _meaningC;
  late final TextEditingController _ex1C;
  late final TextEditingController _ex2C;

  bool saving = false;

  @override
  void initState() {
    super.initState();
    _meaningC = TextEditingController(text: widget.word['meaning'] ?? '');
    _ex1C = TextEditingController(text: widget.word['example_1'] ?? '');
    _ex2C = TextEditingController(text: widget.word['example_2'] ?? '');
  }

  @override
  void dispose() {
    _meaningC.dispose();
    _ex1C.dispose();
    _ex2C.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final meaning = _meaningC.text.trim();
    if (meaning.isEmpty) return;

    setState(() => saving = true);

    try {
      await Supabase.instance.client
          .from('vocabulary')
          .update({
            'meaning': meaning,
            'example_1': _ex1C.text.trim(),
            'example_2': _ex2C.text.trim(),
          })
          .eq('id', widget.word['id']);

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Update failed")),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text("Edit Word", style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.word['word'],
              style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple.shade900),
            ),
            const SizedBox(height: 20),
            Text("Meaning", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _meaningC,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.purple.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 20),
            Text("Example 1 (optional)", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _ex1C,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.purple.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            Text("Example 2 (optional)", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _ex2C,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.purple.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: saving ? null : _save,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade600),
          child: saving
              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}