import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage>{
  Future<List<Gato> gatosFuture = getGatos();
  @override
 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Aplicacion de Gatos"),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.search)),
          IconButton(onPressed: null, icon: Icon(Icons.more_vert))
        ],
    ),
    body: Center(
      child: FutureBuilder(
        future: gatosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        } else if (snapshot.hasData){
        final gatos = snapshot.data!;
        return buildGatos(gatos);
        } else {
          return const Text("No data avaible");
        }
      })));
      
      }

static Future <List<Gato> getGatos() async {
  var url = Uri.parse("https://api.thecatapi.com/v1/images/search?limit=10");
  final response =
      await http.get(url, headers: {"Content-Type": "application/json"});
  final List body = json.decode(response.body);
  return body.map((e) => Gato.fromJson(e)).toList();
  }
}


Widget buildGatos(List<Gato> gatos) {
  return ListView.separated(
    itemCount: gatos.length,
    itemBuilder: (BuildContext context, int index) {
      final gato = gatos[index];
      final url = "${gato.url}";

      return ListTile(
        title: Text("${gato.id}"),
        leading: CircleAvatar(backgroundImage: NetworkImage(url)),
        subtitle: const Text("Este es un gato"),
        trailing: const Icon(Icon.arrow_forwar_ios),
      ); //ListTile      
    },

    separatorBuilder: (BuildContext contex, int index){
      return const Divider(
        thickness: 2,
             );
    },
  );
}