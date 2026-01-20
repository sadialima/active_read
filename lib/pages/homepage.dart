import 'package:active_read/widgets/add_book_dialog.dart';
import 'package:active_read/widgets/card_book.dart';
import 'package:active_read/widgets/drawer.dart';
import 'package:active_read/widgets/edit_book_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;

  static const String adminEmail = "sadiasultana4266@gmail.com";
  bool get isAdmin => supabase.auth.currentUser?.email == adminEmail;

  late Future<List<Map<String, dynamic>>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = fetchBooks();
  }

  void _refresh() {
    setState(() {
      _booksFuture = fetchBooks();
    });
  }

  void _snack(String msg, {Color? bg}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: bg,
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchBooks() async {
    final data = await supabase
        .from('books')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> insertBook(Map<String, dynamic> bookData) async {
    try {
      await supabase.from('books').insert({
        'title': bookData['title'],
        'author': bookData['author'],
        'genre': bookData['genre'],
        'cover_url': bookData['cover_url'],
        'pdf_url': bookData['pdf_url'],
      });
      _snack("Book added successfully", bg: Colors.purple.shade600);
      _refresh();
    } catch (e) {
      _snack("Add failed: $e", bg: Colors.red.shade600);
    }
  }

  Future<void> updateBook(Map<String, dynamic> bookData) async {
    try {
      await supabase.from('books').update({
        'title': bookData['title'],
        'author': bookData['author'],
        'genre': bookData['genre'],
        'cover_url': bookData['cover_url'],
        'pdf_url': bookData['pdf_url'],
      }).eq('id', bookData['id']);
      _snack("Book updated successfully", bg: Colors.purple.shade600);
      _refresh();
    } catch (e) {
      _snack("Update failed: $e", bg: Colors.red.shade600);
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      await supabase.from('books').delete().eq('id', id);
      _snack("Book deleted", bg: Colors.purple.shade600);
      _refresh();
    } catch (e) {
      _snack("Delete failed: $e", bg: Colors.red.shade600);
    }
  }

  void _showAddBookDialog() async {
    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (context) => const AddBookDialog(),
    );

    if (result != null) {
      await insertBook(result);
    }
  }

  void _showEditBookDialog(Map<String, dynamic> book) async {
    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (context) => EditBookDialog(book: book),
    );

    if (result != null) {
      await updateBook(result);
    }
  }

  void _confirmDeleteBook(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.purple.shade100,
        title: Text(
          "Delete Book?",
          style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red.shade800),
          textAlign: TextAlign.center,
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "This book and all its notes will be permanently deleted.\n\nThis action cannot be undone.",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.purple.shade900),
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel", style: GoogleFonts.poppins(fontSize: 18, color: Colors.purple.shade700)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text("Delete Forever", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await deleteBook(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 227, 223, 221),
        foregroundColor: Colors.purple.shade900,
        title: Text("Active Read", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w800)),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink.shade100, Colors.purple.shade100, Colors.blue.shade100],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Pick a book • save words • take notes ✨",
                  style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.purple.shade700),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _booksFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}", style: GoogleFonts.poppins(color: Colors.red)));
                    }

                    final books = snapshot.data ?? [];

                    if (books.isEmpty) {
                      return Center(
                        child: Text(
                          "No books yet",
                          style: GoogleFonts.playfairDisplay(fontSize: 28, color: Colors.purple.shade700),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        final id = book['id'].toString();
                        return BookCard(
                          book: book,
                          isAdmin: isAdmin,
                          onEdit: () => _showEditBookDialog(book),
                          onDelete: () => _confirmDeleteBook(id),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: Colors.purple.shade500,
              onPressed: _showAddBookDialog,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}