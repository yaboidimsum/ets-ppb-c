import 'package:flutter/material.dart';
import '../models/model_book.dart';

class CardBook extends StatelessWidget {
  final Book book;
  final int bookKey;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CardBook({
    super.key,
    required this.book,
    required this.bookKey,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child:
                  // ignore: unnecessary_null_comparison
                  book.image != null
                      ? Image.file(
                        book.image,
                        width: 70,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: 70,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.book_outlined,
                          size: 35,
                          color: Colors.grey,
                        ),
                      ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'by ${book.author}',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    'Genre: ${book.genre}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    'Released: ${book.releaseDate.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 6.0),
                  // Text(
                  //   book.description,
                  //   style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                  //   maxLines: 10,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.edit_note,
                size: 24,
                color: Colors.blueGrey,
              ),
              onPressed: onEdit,
              tooltip: 'Edit Book',
              splashRadius: 20,
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 24, color: Colors.blueGrey),
              onPressed: onDelete,
              tooltip: 'Edit Book',
              splashRadius: 20,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
