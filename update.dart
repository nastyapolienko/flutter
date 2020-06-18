import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:fetchlist/info.dart';


Future<Book> updateBook(bookname, id) async {
  var a = id.toString();
  final http.Response response = await http.put(
    'http://192.168.0.108:8080/books/' + a,
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
    throw Exception('Failed to update book.');
  }
}



class _MyAppState extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
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
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(snapshot.data.bookname),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(hintText: 'Enter Name'),
                      ),
                      RaisedButton(
                        child: Text('Update Data'),
                        onPressed: () {
                            _futureBook = updateBook(_controller.text, _controller.text);
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
