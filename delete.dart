import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:fetchlist/info.dart';


Future<Book> deleteBook(String id) async {
  final http.Response response = await http.delete(
    'http://192.168.0.5:8080/books/$id',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return Book.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to delete album.');
  }
}

class DeleteBook extends StatelessWidget {
  Future<Book> _futureBook;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delete Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Delete Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Book>(
            future: _futureBook,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${snapshot.data?.bookname ?? 'Deleted'}'),
                      RaisedButton(
                        child: Text('Delete Data'),
                        onPressed: () {
                          _futureBook =
                              deleteBook(snapshot.data.id.toString());
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
