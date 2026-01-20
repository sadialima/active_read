import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:active_read/widgets/add_word_dialog.dart';

class DictionaryPage extends StatefulWidget {
  final String bookTitle;
  const DictionaryPage({super.key, required this.bookTitle});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final TextEditingController _wordController = TextEditingController();

  bool loading = false;
  String? meaning;
  String? error;

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final word = _wordController.text.trim();
    if (word.isEmpty) return;

    setState(() {
      loading = true;
      meaning = null;
      error = null;
    });

    try {
      final url = Uri.parse("https://api.dictionaryapi.dev/api/v2/entries/en/${Uri.encodeComponent(word)}",
      );
      final res = await http.get(url);

      if (res.statusCode != 200 || res.body.contains("title")) {
        setState(() => error = "No definition found");
      } else {
        final data = jsonDecode(res.body);
        final def = data[0]["meanings"][0]["definitions"][0]["definition"];
        setState(() => meaning = def.toString());
      }
    } catch (e) {
      setState(() => error = "Check your internet connection");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _saveWord() async {
    if (meaning == null) return;

    final word = _wordController.text.trim();
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => SaveWordDialog(
        word: word,
        meaning: meaning!,
        bookTitle: widget.bookTitle,
      ),
    );

    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("'$word' saved! 🎉", style: GoogleFonts.poppins()),
          backgroundColor: Colors.purple.shade600,
        ),
      );

      _wordController.clear();
      setState(() {
        meaning = null;
        error = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 226, 175, 235),
        title: Text(
          "Dictionary",
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: Colors.purple.shade900,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 226, 175, 235),
                    borderRadius: BorderRadius.circular(20),
                    
                  ),
                  child: TextField(
                    controller: _wordController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (context) => _search(),
                    decoration: InputDecoration(
                      hintText: "Search a word...",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.purple.shade600,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.purple,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.purple,
                          ),
                        )
                      : error != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 80,
                                color: Colors.purple.shade400,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                error!,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        )
                      : meaning != null
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _wordController.text.trim(),
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade900,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                meaning!,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.purple.shade800,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "From: ${widget.bookTitle}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.purple.shade600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.menu_book_rounded,
                                size: 80,
                                color: Colors.purple.shade300,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Type a word to see its meaning ✨",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.purple.shade700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: (meaning == null || loading) ? null : _saveWord,
                    icon: const Icon(Icons.bookmark_add_outlined, size: 26,color: Color.fromARGB(255, 113, 42, 158),),
                    label: Text(
                      "Save to Vocabulary",
                      style: GoogleFonts.poppins(
                        color: Colors.purple.shade800,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade300,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
