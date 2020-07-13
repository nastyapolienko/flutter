import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fetchlist/update.dart';
import 'package:fetchlist/main.dart';
import 'package:fetchlist/delete.dart';

Future<Book> fetchBook(index) async {
  var a = index.toString();
  final response = await http.get('http://192.168.0.5:8080/books/' + a);
  if (response.statusCode == 200) {
    return Book.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load a book');
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
    throw Exception('Failed to delete album.');
  }
}


class DetailPage extends StatelessWidget {

  final Book book;
  DetailPage(this.book);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(book.bookname),
        ),

        floatingActionButton: Stack(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left:31),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: () {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => DeleteBook(book))
                    );
                  Navigator.canPop(context);
                  },
                  child: const Icon(Icons.delete),
                ),
              ),),
              Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: (){
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => UpdateBook(book))
                    );
                    Navigator.canPop(context);
                  },
                  child: Icon(Icons.edit),
                ),
              )
            ]
        ),


        body: Center(

          child: FutureBuilder<Book>(

            future: fetchBook(book.bid),
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



