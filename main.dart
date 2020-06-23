import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fetchlist/info.dart';

Future<List<Book>> fetchBooks(http.Client client) async {
  final response =
  await client.get('http://192.168.0.5:8080/books');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseBooks, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Book> parseBooks(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Book>((json) => Book.fromJson(json)).toList();
}


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Isolate Demo';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Book>>(
        future: fetchBooks(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? BooksList(books: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class BooksList extends StatelessWidget {
  final List<Book> books;

  BooksList({Key key, this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return Text(books[index].bookname);
      },
    );
  }
}

class Book {
  final int id;
  final String bookname;
  final String year;

  Book({this.id, this.bookname, this.year});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      bookname: json['bookname'],
      year: json['year'],
    );
  }
}
