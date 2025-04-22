import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final Function() addAuthor;
  final Function() addBook;

  const Header({super.key, required this.addAuthor, required this.addBook});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('StoryBase'),
      actions: [
        TextButton(onPressed: addAuthor, child: const Text('Add Author')),
        TextButton(onPressed: addBook, child: const Text('Add Book')),
      ],
    );
  }
}
