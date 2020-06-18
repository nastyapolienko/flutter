import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fetchlist/info.dart';
import 'package:fetchlist/main.dart';

Future<Book> createBook(String bookname) async {
  final http.Response response = await http.post(
    'http://192.168.0.5:8080/books',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'bookname': bookname,
    }),
  );

  if (response.statusCode == 200) {
    return Book.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create a book.');
  }
}


class CreateBook extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  Future<Book> _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Book Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Creating a Book'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureAlbum == null)
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Enter Title'),
              ),
              RaisedButton(
                child: Text('Add book'),
                onPressed: () {
                  _futureAlbum = createBook(_controller.text);
                  new MaterialPageRoute(
                      builder: (context) => MyHomePage());
                },
              ),
            ],
          )
              : FutureBuilder<Book>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.bookname);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

