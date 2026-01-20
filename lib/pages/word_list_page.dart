import 'package:active_read/widgets/card_word.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:active_read/widgets/edit_word_dialog.dart';

class VocabularyListPage extends StatefulWidget {
  const VocabularyListPage({super.key});

  @override
  State<VocabularyListPage> createState() => _VocabularyListPageState();
}

class _VocabularyListPageState extends State<VocabularyListPage> {
  List<Map<String, dynamic>> _words = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchWords();
  }

  Future<void> _fetchWords() async {
    setState(() => _loading = true);

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      setState(() {
        _words = [];
        _loading = false;
      });
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('vocabulary')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      setState(() {
        _words = List<Map<String, dynamic>>.from(response as List);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load words")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _deleteWord(String id, String word) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Delete '$word'?", style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        content: const Text("This cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await Supabase.instance.client.from('vocabulary').delete().eq('id', id);
      _fetchWords();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("'$word' deleted"), backgroundColor: Colors.purple.shade400),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Delete failed")),
      );
    }
  }

  Future<void> _editWord(Map<String, dynamic> word) async {
    final updated = await showDialog<bool>(
      context: context,
      builder: (_) => EditWordDialog(word: word),
    );

    if (updated == true) {
      _fetchWords();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FA),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        foregroundColor: Colors.purple.shade900,
        title: Text("My Vocabulary", style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F0FF), Color(0xFFFFF5FF)],
          ),
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: Colors.purple))
            : _words.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book_rounded, size: 120, color: Colors.purple.shade300),
                        const SizedBox(height: 32),
                        Text("No words yet", style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.purple.shade800)),
                        const SizedBox(height: 16),
                        Text("Start reading and save new words! ✨", style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey.shade700), textAlign: TextAlign.center),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _words.length,
                    itemBuilder: (context, index) {
                      final word = _words[index];

                      return WordCard(
                        word: word,
                        onEdit: () => _editWord(word),
                        onDelete: () => _deleteWord(word['id'], word['word']),
                      );
                    },
                  ),
      ),
    );
  }
}