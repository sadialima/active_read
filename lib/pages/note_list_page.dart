import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:active_read/widgets/card_note.dart';
import 'package:active_read/widgets/edit_note_dialog.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  bool loading = true;
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    setState(() => loading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final data = await Supabase.instance.client
          .from('notes')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      notes = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Load failed")),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _deleteNote(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Delete note?", style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: const Text("This cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade500),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await Supabase.instance.client.from('notes').delete().eq('id', id);
      await fetchNotes();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note deleted")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Delete failed")),
      );
    }
  }

  Future<void> _editNote(Map<String, dynamic> note) async {
    final updated = await showDialog<bool>(
      context: context,
      builder: (context) => EditNoteDialog(note: note),
    );

    if (updated == true) {
      await fetchNotes();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note updated"),backgroundColor: Colors.purple,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 223, 197, 249),
        foregroundColor: Colors.purple.shade900,
        title: Text("My Notes", style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.bold)),
        centerTitle: true,
        
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 223, 208, 240), Color.fromARGB(255, 227, 205, 227)],
          ),
        ),
        child: loading
            ? const Center(child: CircularProgressIndicator(color: Colors.purple))
            : notes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.note_add_rounded, size: 100, color: Colors.purple.shade300),
                        SizedBox(height: 24),
                        Text("No notes yet", style: GoogleFonts.playfairDisplay(fontSize: 32, color: Colors.purple.shade800)),
                        SizedBox(height: 12),
                        Text("Tap + while reading to save notes! ✨", style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey.shade700), textAlign: TextAlign.center),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final book = note['book_title'] ?? 'General';
                      final text = note['note'] ?? '';

                      return NoteCard(
                        bookTitle: book,
                        noteText: text,
                        onEdit: () => _editNote(note),
                        onDelete: () => _deleteNote(note['id']),
                      );
                    },
                  ),
      ),
    );
  }
}