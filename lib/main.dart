import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restapi_example/ServerModel.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen()
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override

  List<ServerModel> postList=[];

  Future<List<ServerModel>> getAPI() async{
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
     postList.clear();
      for(Map i in data)
        postList.add(ServerModel.fromJson(i));
    }
    return postList;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('RestAPI'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
            future: getAPI(),
            builder: (context, snapshot){
              if(!snapshot.hasData) {
                return CircularProgressIndicator();
              } else{
                return ListView.builder(
                itemCount: postList.length,
                itemBuilder: (context,index){
                  return Card(
                    shadowColor: Colors.grey,
                    elevation: 5,
                   child:Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 6.0,vertical: 4.0),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('Id=${postList[index].id.toString()}',style: Theme.of(context).textTheme.titleMedium,),
                         Text('Title=${postList[index].title.toString()}',style: Theme.of(context).textTheme.titleMedium,),
                       ],
                     ),
                   )
                  );
                });
              }
            }),
          )
        ],
      )
    );
  }
}


