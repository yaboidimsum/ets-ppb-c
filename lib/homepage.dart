import 'package:flutter/material.dart';
import 'package:ets_ppb_c_app/view/author_list.dart';
import 'package:ets_ppb_c_app/view/book_list.dart';
import 'dart:io';
import '../helper/helper.dart';
import '../models/model_author.dart';
import '../models/model_book.dart';
import 'package:image_picker/image_picker.dart';
import '../view/header.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final AuthorHiveService _authorService = AuthorHiveService();
  final BookHiveService _bookService = BookHiveService();
  List<MapEntry<dynamic, Author>> _authors = []; // Keep the list here
  List<MapEntry<dynamic, Book>> _books = []; // Keep the list here

  // Author Controller
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  File? _authorImageFile;
  final ImagePicker _authorPicker = ImagePicker();
  final _birthdateController = TextEditingController();
  DateTime? _selectedBirthdate;

  //Book Controller
  // final _authorController = TextEditingController(); // Removed author text controller
  String? _selectedAuthorName; // Added state for selected author name
  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _bookImageFile;
  final ImagePicker _bookPicker = ImagePicker();
  final _releaseDateController = TextEditingController();
  DateTime? _selectedReleasedate;

  @override
  void initState() {
    super.initState();
    _loadAuthor(); // Load initial authors
    _loadBook();
  }

  void _loadAuthor() {
    setState(() {
      _authors =
          _authorService.getAllAuthor(); // Update the list in Homepage state
    });
  }

  void _loadBook() {
    setState(() {
      _books = _bookService.getAllBook();
    });
  }

  Future<void> _pickAuthorImage(ImageSource source) async {
    final picked = await _authorPicker.pickImage(source: source);

    if (picked != null) {
      setState(() {
        _authorImageFile = File(picked.path);
        debugPrint("Image file updated: ${_authorImageFile?.path}");
      });
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickAuthorImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickAuthorImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _pickBookImage() async {
    final picked = await _bookPicker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _bookImageFile = File(picked.path);
      });
    }
  }

  Future<void> _pickAuthorDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedBirthdate = picked;
        _birthdateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _pickBookDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedReleasedate = picked;
        _releaseDateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  void dispose() {
    //Author
    _nameController.dispose();
    _ageController.dispose();
    _birthdateController.dispose();

    //Book
    // _authorController.dispose(); // Removed disposal
    _titleController.dispose();
    _genreController.dispose();
    _descriptionController.dispose();
    _releaseDateController.dispose();

    super.dispose();
  }

  void _showAddAuthorDialog() {
    // Clear previous image selection for the add dialog specifically
    _authorImageFile = null;
    _nameController.clear();
    _ageController.clear();
    _birthdateController.clear();
    _selectedBirthdate = null; // Also clear selected date

    showDialog(
      context: context,
      // Use StatefulBuilder to allow dialog content to rebuild
      builder:
          (context) => StatefulBuilder(
            builder: (context, dialogSetState) {
              return AlertDialog(
                title: const Text('Add Author'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Prevent excessive column height
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // Make async to await image picking
                          // Show options, pick image, and update state
                          _showImageSourceOptions();
                          // Trigger rebuild of dialog content via StatefulBuilder
                          dialogSetState(() {});
                        },
                        // Use the _authorImageFile from the main state
                        child:
                            _authorImageFile != null
                                ? Image.file(
                                  _authorImageFile!,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  height: 150,
                                  width: 150,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                  ),
                                ),
                      ),
                      const SizedBox(height: 16), // Add space after image
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Age',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _birthdateController,
                        readOnly: true, // Make readOnly, date picked via onTap
                        onTap: () async {
                          // Make async to await date picker
                          await _pickAuthorDate();
                          // Update the text field after picking
                          dialogSetState(() {});
                        },
                        decoration: const InputDecoration(
                          labelText: 'Birth Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today), // Add icon
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Validation remains the same
                      if (_authorImageFile != null &&
                          _nameController.text.isNotEmpty &&
                          int.tryParse(_ageController.text) != null &&
                          _selectedBirthdate != null) {
                        final author = Author(
                          name: _nameController.text,
                          age: int.parse(_ageController.text),
                          birthdate: _selectedBirthdate!,
                          image: _authorImageFile!,
                        );
                        _authorService.addAuthor(author);
                        Navigator.of(context).pop(); // Close dialog
                        _loadAuthor(); // Reload list in homepage
                      } else {
                        // Optional: Show a snackbar or message for validation failure
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please fill all fields and select an image.',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Add Author'),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _showEditAuthorDialog(int authorKey, Author author) {
    // Initialize controllers and state with existing author data
    _nameController.text = author.name;
    _ageController.text = author.age.toString();
    _selectedBirthdate = author.birthdate;
    _birthdateController.text =
        _selectedBirthdate!.toLocal().toString().split(' ')[0];
    _authorImageFile = author.image; // Start with the existing image

    showDialog(
      context: context,
      // Use StatefulBuilder here as well
      builder:
          (context) => StatefulBuilder(
            builder: (context, dialogSetState) {
              return AlertDialog(
                title: const Text('Edit Author'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          _showImageSourceOptions();
                          dialogSetState(() {}); // Rebuild dialog content
                        },
                        child:
                            _authorImageFile != null
                                ? Image.file(
                                  _authorImageFile!,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  // Fallback if somehow image is null
                                  height: 150,
                                  width: 150,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 50,
                                  ),
                                ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Age',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _birthdateController,
                        readOnly: true,
                        onTap: () async {
                          await _pickAuthorDate();
                          dialogSetState(() {}); // Rebuild dialog content
                        },
                        decoration: const InputDecoration(
                          labelText: 'Birth Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Validation remains the same
                      if (_authorImageFile != null &&
                          _nameController.text.isNotEmpty &&
                          int.tryParse(_ageController.text) != null &&
                          _selectedBirthdate != null) {
                        final updatedAuthor = Author(
                          name: _nameController.text,
                          age: int.parse(_ageController.text),
                          birthdate: _selectedBirthdate!,
                          image:
                              _authorImageFile!, // Use the potentially updated image
                        );
                        _authorService.updateAuthor(authorKey, updatedAuthor);
                        Navigator.of(context).pop(); // Close dialog
                        _loadAuthor(); // Reload list in homepage
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all fields.'),
                          ),
                        );
                      }
                    },
                    child: const Text('Save Author'),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _showAddBookDialog() {
    // Clear previous selections for the add dialog
    _bookImageFile = null;
    // _authorController.clear(); // Removed clearing for text controller
    _selectedAuthorName = null; // Clear selected author name
    _titleController.clear();
    _genreController.clear();
    _descriptionController.clear();
    _releaseDateController.clear();
    _selectedReleasedate = null; // Also clear selected date

    // Ensure there are authors to select from
    if (_authors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add an author first before adding a book.'),
        ),
      );
      return; // Don't show dialog if no authors exist
    }

    showDialog(
      context: context,
      // Use StatefulBuilder to allow dialog content to rebuild
      builder:
          (context) => StatefulBuilder(
            builder: (context, dialogSetState) {
              return AlertDialog(
                title: const Text('Add Book'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Prevent excessive column height
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // Pick book image (using _pickBookImage or _showImageSourceOptions if you want camera too)
                          await _pickBookImage(); // Assuming gallery only for books for now
                          // Trigger rebuild of dialog content via StatefulBuilder
                          dialogSetState(() {});
                        },
                        // Use the _bookImageFile from the main state
                        child:
                            _bookImageFile != null
                                ? Image.file(
                                  _bookImageFile!,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  height: 150,
                                  width: 150,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons
                                        .add_a_photo, // Changed icon for clarity
                                    size: 50,
                                  ),
                                ),
                      ),
                      const SizedBox(height: 16), // Add space after image
                      // --- Author Dropdown ---
                      DropdownButtonFormField<String>(
                        value: _selectedAuthorName,
                        hint: const Text('Select Author'),
                        decoration: const InputDecoration(
                          labelText: 'Author',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            _authors.map((entry) {
                              // Assuming Author model has a 'name' property
                              final authorName = entry.value.name;
                              return DropdownMenuItem<String>(
                                value: authorName,
                                child: Text(authorName),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          dialogSetState(() {
                            _selectedAuthorName = newValue;
                          });
                        },
                        validator:
                            (value) =>
                                value == null
                                    ? 'Please select an author'
                                    : null,
                      ),

                      // --- End Author Dropdown ---
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _genreController,
                        decoration: const InputDecoration(
                          labelText: 'Genre',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3, // Allow more space for description
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _releaseDateController,
                        readOnly: true, // Make readOnly, date picked via onTap
                        onTap: () async {
                          // Make async to await date picker
                          await _pickBookDate(); // Use the book date picker
                          // Update the text field after picking
                          dialogSetState(() {});
                        },
                        decoration: const InputDecoration(
                          labelText: 'Release Date', // Corrected label
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today), // Add icon
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Updated Validation
                      if (_bookImageFile != null &&
                          _selectedAuthorName !=
                              null && // Check selected author
                          _titleController.text.isNotEmpty &&
                          _genreController.text.isNotEmpty &&
                          _descriptionController.text.isNotEmpty &&
                          _selectedReleasedate != null) {
                        final book = Book(
                          author:
                              _selectedAuthorName!, // Use selected author name
                          title: _titleController.text,
                          genre: _genreController.text,
                          releaseDate: _selectedReleasedate!,
                          description: _descriptionController.text,
                          image: _bookImageFile!,
                        );

                        _bookService.addBook(book);
                        Navigator.of(context).pop(); // Close dialog
                        _loadBook(); // Reload book list
                      } else {
                        // Optional: Show a snackbar or message for validation failure
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please fill all fields, select an author, and select an image.',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Add Book'), // Corrected button text
                  ),
                ],
              );
            },
          ),
    );
  }

  void _showEditBookDialog(int bookKey, Book book) {
    // Initialize controllers and state with existing book data
    _titleController.text = book.title;
    _genreController.text = book.genre;
    _descriptionController.text = book.description;
    _selectedReleasedate = book.releaseDate;
    _releaseDateController.text =
        _selectedReleasedate!.toLocal().toString().split(' ')[0];
    _bookImageFile = book.image; // Start with the existing image
    _selectedAuthorName = book.author; // Pre-select the current author

    // Ensure the pre-selected author exists in the current author list
    // If not, you might want to handle this case (e.g., default to null or show a message)
    if (!_authors.any((entry) => entry.value.name == _selectedAuthorName)) {
      _selectedAuthorName = null; // Or handle as needed
      // Consider showing a warning if the original author is no longer available
    }

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, dialogSetState) {
              return AlertDialog(
                title: const Text('Edit Book'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await _pickBookImage(); // Use book image picker
                          dialogSetState(() {}); // Rebuild dialog
                        },
                        child:
                            _bookImageFile != null
                                ? Image.file(
                                  _bookImageFile!,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  // Fallback if image is somehow null
                                  height: 150,
                                  width: 150,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 50,
                                  ),
                                ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedAuthorName,
                        hint: const Text('Select Author'),
                        decoration: const InputDecoration(
                          labelText: 'Author',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            _authors.map((entry) {
                              final authorName = entry.value.name;
                              return DropdownMenuItem<String>(
                                value: authorName,
                                child: Text(authorName),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          dialogSetState(() {
                            _selectedAuthorName = newValue;
                          });
                        },
                        validator:
                            (value) =>
                                value == null
                                    ? 'Please select an author'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _genreController,
                        decoration: const InputDecoration(
                          labelText: 'Genre',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _releaseDateController,
                        readOnly: true,
                        onTap: () async {
                          await _pickBookDate(); // Use book date picker
                          dialogSetState(() {}); // Rebuild dialog
                        },
                        decoration: const InputDecoration(
                          labelText: 'Release Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Validation
                      if (_bookImageFile != null &&
                          _selectedAuthorName != null &&
                          _titleController.text.isNotEmpty &&
                          _genreController.text.isNotEmpty &&
                          _descriptionController.text.isNotEmpty &&
                          _selectedReleasedate != null) {
                        final updatedBook = Book(
                          author: _selectedAuthorName!,
                          title: _titleController.text,
                          genre: _genreController.text,
                          releaseDate: _selectedReleasedate!,
                          description: _descriptionController.text,
                          image:
                              _bookImageFile!, // Use potentially updated image
                        );
                        _bookService.updateBook(
                          bookKey,
                          updatedBook,
                        ); // Use updateBook
                        Navigator.of(context).pop(); // Close dialog
                        _loadBook(); // Reload book list
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all fields.'),
                          ),
                        );
                      }
                    },
                    child: const Text('Save Book'), // Corrected button text
                  ),
                ],
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(
              addAuthor: () => _showAddAuthorDialog(),
              addBook: () => _showAddBookDialog(),
            ),
            // Pass the author list and callbacks down to AuthorList
            BookList(
              books: _books,
              authors:
                  _authors, // Pass authors if needed by BookList for display
              onEditBook:
                  (key, book) =>
                      _showEditBookDialog(key, book), // Pass the edit function
              onDeleteBook: (key) {
                // Assuming BookList passes the key
                _bookService.deleteBook(key);
                _loadBook(); // Reload list after deletion
              },
            ),
            AuthorList(
              authors: _authors, // Pass the list from Homepage state
              onEditAuthor: (key, author) => _showEditAuthorDialog(key, author),
              onDeleteAuthor: (key) {
                _authorService.deleteAuthor(key);
                _loadAuthor(); // Reload list after deletion
                _loadBook(); // Also reload books in case author was removed
              },
            ),
          ],
        ),
      ),
    );
  }
}
