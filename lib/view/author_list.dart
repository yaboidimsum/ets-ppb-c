import 'package:flutter/material.dart';
import '../models/model_author.dart';

class AuthorList extends StatelessWidget {
  final List<MapEntry<dynamic, Author>> authors;
  final Function(int authorKey, Author author) onEditAuthor;
  final Function(int authorKey) onDeleteAuthor;

  const AuthorList({
    super.key,
    required this.authors,
    required this.onEditAuthor,
    required this.onDeleteAuthor,
  });

  @override
  Widget build(BuildContext context) {
    if (authors.isEmpty) {
      return const Expanded(
        child: Center(child: Text('No authors available.')),
      );
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Authors Available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: authors.length,
              itemBuilder: (context, index) {
                final authorEntry = authors[index];
                final author = authorEntry.value;
                final authorKey = authorEntry.key;

                return Dismissible(
                  key: Key(authorKey.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    onDeleteAuthor(authorKey);
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: FileImage(author.image),
                      radius: 25,
                    ),
                    title: Text(author.name),
                    subtitle: Text('Age: ${author.age} | ${author.birthdate}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        onEditAuthor(authorKey, author);
                      },
                      tooltip: 'Edit Author',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
