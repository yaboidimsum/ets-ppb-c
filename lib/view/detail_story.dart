import 'package:flutter/material.dart';
import 'package:ets_ppb_c_app/models/model_book.dart';

class DetailStory extends StatelessWidget {
  final Book book;

  const DetailStory({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(
                book.image,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              // Text(book.description, style: TextStyle(fontSize: 18)),
              Flexible(
                child: Text(book.description, style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 10),
              Text(
                'Written by: ${book.author}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
