import 'package:flutter/material.dart';
import 'package:fetchlist/main.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Book> fetchBook(index) async {
  index++;
  var a = index.toString();
  final response = await http.get('http://192.168.0.5:8080/books/' + a);
  if (response.statusCode == 200) {
    return Book.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load a book');
  }
}

class DetailPage extends StatelessWidget {

  final Book book;
  final int id;
  DetailPage(this.book, this.id);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(book.bookname),
        ),
        body: Center(

          child: FutureBuilder<Book>(

            future: fetchBook(id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.bookname + "\n" + snapshot.data.year);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }


              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
    );
  }
}



