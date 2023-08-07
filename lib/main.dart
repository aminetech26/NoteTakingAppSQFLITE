import 'package:flutter/material.dart';
import 'package:learning_sqflite/edit_note.dart';
import 'package:learning_sqflite/new_note.dart';
import 'package:learning_sqflite/database_config.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => MyApp(),
      '/New_Note': (context) => NewNote(),
    },
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DatabaseConfig db = DatabaseConfig();

  List notes = [];
  bool isLoading = true;
  Future fetchData() async {
    List<Map> response = await db.readData("SELECT * FROM notes");
    notes.addAll(response);
    isLoading = false;
    if(this.mounted){
      setState(() {

      });
    }
  }
@override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Note Taking App'),
      ),
      body: isLoading ? const Center(child: Text('Loading ...'),) : Stack(
        children: [
          ListView(children: [
                        ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: notes.length,
                        itemBuilder: (context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.white,
                              child: ListTile(
                                title: Text("${notes[index]['note']}"),
                                subtitle: Text("${notes[index]['body']}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [IconButton(onPressed: () async{
                                    int response =  await db.deleteData("DELETE FROM notes WHERE id = ${notes[index]['id']}");
                                    if (response > 0){
                                      notes.removeWhere((element) => element['id'] == notes[index]['id']);
                                      setState(() {

                                      });
                                    }}, icon: Icon(Icons.delete)),IconButton(onPressed: () async{
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditNote(
                                        note: notes[index]['note'],
                                        body: notes[index]['body'],
                                        id: notes[index]['id'],
                                      )));
                                    }, icon: Icon(Icons.edit)),

                                  ],
                                ),
                              ),
                            ),
                          );
                        })
          ]),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/New_Note');
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
