import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:fetchlist/main.dart';


Future<Book> updateBook(bid, bookname, year) async {
  var a = bid.toString();
  print(a);
  final http.Response response = await http.put(
    'http://192.168.0.5:8080/books/' + a,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'bookname': bookname,
      'year' : year,
    }),
  );

  if (response.statusCode == 200) {
    return Book.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to update book.');
  }
}



class UpdateBook extends StatelessWidget {

  final Book book;
  UpdateBook(this.book);

   TextEditingController _controller1 = TextEditingController();
   TextEditingController _controller2 = TextEditingController();

  Future<Book> _futureBook;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Update Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<Book>(
            future: _futureBook,
            builder: (BuildContext context, snapshot) {

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(book.bookname),
                      TextFormField(
                        controller: _controller1 = TextEditingController(text: book.bookname),
                      ),
                      TextFormField(
                        controller: _controller2 = TextEditingController(text: book.year),
                      ),
                      RaisedButton(
                        child: Text('Update Book'),
                        onPressed: () {
                            _futureBook = updateBook(book.bid, _controller1.text, _controller2.text);
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
