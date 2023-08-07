import 'package:flutter/material.dart';
import 'package:learning_sqflite/database_config.dart';
import 'package:learning_sqflite/main.dart';
class EditNote extends StatefulWidget {
  final note;
  final body;
  final id;
  EditNote({Key? key, this.note, this.body, this.id}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  DatabaseConfig databaseConfig = new DatabaseConfig();

  TextEditingController title = TextEditingController();

  TextEditingController body = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    title.text = widget.note;
    body.text = widget.body;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),backgroundColor: Colors.grey[200],body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all( 16.0),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(height: 10,),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: title,
                      decoration: const InputDecoration(
                        hintText: 'Note Title',
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: TextField(
                        maxLines: null,
                        controller: body,
                        decoration: const InputDecoration(
                          hintText: 'Enter note here',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                          border: InputBorder.none,
                        ),
                      )
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Container(
                width: 150,
                child: TextButton(onPressed: ()async{
                  var response = await databaseConfig.insertData(
                      '''UPDATE notes SET 
                      note = "${title.text}",
                      body = "${body.text}"
                      WHERE id = ${widget.id}
                      '''
                  );
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyApp()), (route) => false);
                },style: TextButton.styleFrom(
                  backgroundColor: Colors.black12,

                ),child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.note_add),
                    SizedBox(width: 5,),
                    Text('Edit note'),
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    ),
    );
  }
}
