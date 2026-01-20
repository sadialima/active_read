import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditBookDialog extends StatefulWidget {
  final Map<String, dynamic> book;

  const EditBookDialog({super.key, required this.book});

  @override
  State<EditBookDialog> createState() => _EditBookDialogState();
}

class _EditBookDialogState extends State<EditBookDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleC;
  late final TextEditingController _authorC;
  late final TextEditingController _genreC;

  String _coverName = "Current cover (tap to change)";
  String _pdfName = "Current PDF (tap to change)";
  bool _uploading = false;
  String? _newCoverUrl;
  String? _newPdfUrl;

  final supabase = Supabase.instance.client;

  String _sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[^\w\.\-]'), '_');
  }

  @override
  void initState() {
    super.initState();
    _titleC = TextEditingController(text: widget.book['title'] ?? '');
    _authorC = TextEditingController(text: widget.book['author'] ?? '');
    _genreC = TextEditingController(text: widget.book['genre'] ?? '');

    _newCoverUrl = widget.book['cover_url'];
    _newPdfUrl = widget.book['pdf_url'];
  }

  @override
  void dispose() {
    _titleC.dispose();
    _authorC.dispose();
    _genreC.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadCover() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.single.bytes == null) return;

    setState(() {
      _coverName = result.files.single.name;
      _uploading = true;
    });

    try {
      final bytes = result.files.single.bytes!;
      final fileName = 'covers/${DateTime.now().millisecondsSinceEpoch}_${_sanitizeFileName(result.files.single.name)}';

      await supabase.storage.from('books').uploadBinary(fileName, bytes);

      _newCoverUrl = supabase.storage.from('books').getPublicUrl(fileName);

      setState(() => _uploading = false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload failed")));
      setState(() => _uploading = false);
    }
  }

  Future<void> _pickAndUploadPdf() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result == null || result.files.single.bytes == null) return;

    setState(() {
      _pdfName = result.files.single.name;
      _uploading = true;
    });

    try {
      final bytes = result.files.single.bytes!;
      final fileName = 'pdfs/${DateTime.now().millisecondsSinceEpoch}_${_sanitizeFileName(result.files.single.name)}';

      await supabase.storage.from('books').uploadBinary(fileName, bytes);

      _newPdfUrl = supabase.storage.from('books').getPublicUrl(fileName);

      setState(() => _uploading = false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload failed")));
      setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      title: Text(
        "Edit Book",
        style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple.shade900),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: 450,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleC,
                  decoration: InputDecoration(
                    labelText: "Book Title",
                    filled: true,
                    fillColor: Colors.purple.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  validator: (v) => v?.trim().isEmpty ?? true ? "Required" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _authorC,
                  decoration: InputDecoration(
                    labelText: "Author",
                    filled: true,
                    fillColor: Colors.purple.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _genreC,
                  decoration: InputDecoration(
                    labelText: "Genre",
                    filled: true,
                    fillColor: Colors.purple.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),

                GestureDetector(
                  onTap: _uploading ? null : _pickAndUploadCover,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.purple.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.image, color: Colors.purple.shade700),
                        const SizedBox(width: 12),
                        Expanded(child: Text(_coverName, style: GoogleFonts.poppins(color: Colors.purple.shade900))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                GestureDetector(
                  onTap: _uploading ? null : _pickAndUploadPdf,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.pink.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf, color: Colors.pink.shade700),
                        const SizedBox(width: 12),
                        Expanded(child: Text(_pdfName, style: GoogleFonts.poppins(color: Colors.pink.shade900))),
                      ],
                    ),
                  ),
                ),
                if (_uploading) ...[
                  const SizedBox(height: 16),
                  const LinearProgressIndicator(),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: _uploading ? null : () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'id': widget.book['id'],
                'title': _titleC.text.trim(),
                'author': _authorC.text.trim(),
                'genre': _genreC.text.trim(),
                'cover_url': _newCoverUrl!,
                'pdf_url': _newPdfUrl!,
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple.shade600,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }
}