import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fetchlist/info.dart';
import 'package:fetchlist/create.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Books'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<Book>> _getBooks() async {
    var data = await http.get("http://192.168.0.5:8080/books");
    var jsonData = json.decode(data.body);
    List<Book> books = [];

    for(var u in jsonData){
      Book book = Book();
      books.add(book);
    }

    print(books.length);
    return books;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => CreateBook())
          );
        },
      ),
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(

        child: FutureBuilder(
          future: _getBooks(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            print("snapshot data");
            print(snapshot.data);

            if(snapshot.data == null){
              return Container(
                  child: Center(
                      child: Text("Loading...")
                  )
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index].name!=null?snapshot.data[index].bookname:'There is null'),
                    onTap: (){
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                          builder: (context) => DetailPage(
                          snapshot.data[index].bookname, index
                          ))
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

