import 'package:active_read/pages/homepage.dart';
import 'package:active_read/pages/note_list_page.dart';
import 'package:active_read/pages/word_list_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.pink.shade100, Colors.purple.shade100, Colors.blue.shade100],
              ),
              borderRadius: const BorderRadius.only(topRight: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.purple.shade900),
                ),
                const SizedBox(height: 16),
                Text(
                  "ActiveRead",
                  style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.purple.shade900),
                ),
                const SizedBox(height: 6),
                Text(
                  user?.email ?? "guest@activeread.app",
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.purple.shade800),
                ),
              ],
            ),
          ),

          ListTile(
            leading: Icon(Icons.library_books_rounded, color: Colors.purple.shade700),
            title: Text("Library", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            trailing: Icon(Icons.chevron_right, color: Colors.purple.shade300),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.bookmark_added_rounded, color: Colors.purple.shade700),
            title: Text("Vocabulary", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            trailing: Icon(Icons.chevron_right, color: Colors.purple.shade300),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const VocabularyListPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit_note_rounded, color: Colors.purple.shade700),
            title: Text("Notes", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            trailing: Icon(Icons.chevron_right, color: Colors.purple.shade300),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotesPage()));
            },
          ),

           Divider(),
          ListTile(
            leading: Icon(Icons.logout_rounded, color: Colors.red.shade600),
            title: Text("Logout", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red.shade700)),
            onTap: () {
              Navigator.pop(context); 
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  title: Text("Logout?", style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold,color:Colors.purple.shade900,)),
                  content: const Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade500),
                      onPressed: () async {
                        Navigator.pop(context);
                        await Supabase.instance.client.auth.signOut();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Logged out successfully", style: GoogleFonts.poppins()),
                            backgroundColor: Colors.purple.shade600,
                          ),
                        );
                      },
                      child: const Text("Logout", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}