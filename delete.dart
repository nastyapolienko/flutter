import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:fetchlist/main.dart';

Future<Book> fetchBook(int index) async {
  var a = index.toString();
  final response = await http.get('http://192.168.0.5:8080/books/' + a);

  if (response.statusCode == 200) {
    return Book.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load book');
  }
}

Future<Book> deleteBook(int index) async {
  var a = index.toString();
  final http.Response response = await http.delete(
    'http://192.168.0.5:8080/books/' + a,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return Book.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to delete book.');
  }
}


class DeleteBook extends StatelessWidget {

  final Book book;
  DeleteBook(this.book);


  Future<Book> _futureBook;

  @override
  void initState() {
    _futureBook = fetchBook(book.bid);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delete Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Delete Data'),
        ),
        body: Center(
          child: FutureBuilder<Book>(
            future: _futureBook,
            builder: (context, snapshot) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${book?.bookname ?? 'Deleted'}'),
                      RaisedButton(
                        child: Text('Delete Book'),
                        onPressed: () {
                            _futureBook =
                                deleteBook(book.bid);
                            Navigator.canPop(context);
                        },
                      ),
                    ],
                  );


              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
