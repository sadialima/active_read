import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SaveWordDialog extends StatelessWidget {
  final String word;
  final String meaning;
  final String bookTitle;

  const SaveWordDialog({
    super.key,
    required this.word,
    required this.meaning,
    required this.bookTitle,
  });

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to save words")),
      );
      return Container();
    }

    final wordC = TextEditingController(text: word);
    final meaningC = TextEditingController(text: meaning);
    final ex1C = TextEditingController();
    final ex2C = TextEditingController();

    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text("Save Word", style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Book: $bookTitle", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: wordC,
                  decoration: InputDecoration(
                    labelText: "Word",
                    filled: true,
                    fillColor: Colors.purple.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  validator: (v) => v?.trim().isEmpty ?? true ? "Required" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: meaningC,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Meaning *",
                    filled: true,
                    fillColor: Colors.purple.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  validator: (v) => v?.trim().isEmpty ?? true ? "Required" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ex1C,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Example 1 (optional)",
                    filled: true,
                    fillColor: Colors.purple.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ex2C,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Example 2 (optional)",
                    filled: true,
                    fillColor: Colors.purple.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;

            try {
              await Supabase.instance.client.from("vocabulary").insert({
                "user_id": user.id,
                "book_title": bookTitle,
                "word": wordC.text.trim(),
                "meaning": meaningC.text.trim(),
                "example_1": ex1C.text.trim(),
                "example_2": ex2C.text.trim(),
              });

              if (!context.mounted) return;
              Navigator.pop(context, true);
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Save failed")),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple.shade600,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text("Save Word", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}