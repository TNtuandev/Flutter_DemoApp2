import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';
class HomeScreen extends StatefulWidget {
  @override

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   List<File> names= [];
   List<File> names2= [];
   String fileInfo;
   final TextEditingController _filter = new TextEditingController();
   String _searchText = "";

   Future<void> openFile() async {
    try{
      FilePickerResult result = await FilePicker.platform.pickFiles();
      File file;
      if (result != null) {
        file = File(result.files.single.path);
        setState(() {
          names.add(file);
        });
      }
      if(_searchText.isEmpty){
        names2 = names;
      }else{
        names2 = names.where((e) => '${basenameWithoutExtension(e.path)}'.toLowerCase().contains(_searchText)).toList();
      }
    }catch(e){
      print('abc');
    }
  }
   _HomeScreenState() {
     _filter.addListener(() {
       if (_filter.text.isEmpty) {
         setState(() {
           _searchText = "";
           names = names;
         });
       } else {
         setState(() {
           _searchText = _filter.text;
         });
       }
     });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFBEFF2),
      appBar: AppBar(
        title: Text('Open File'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Card(
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 10) ,
                child: TextField(
                  controller: _filter,
                  onChanged: (value) {
                    setState(() {
                      print("length $value  ${names2.length}");
                      _searchText = value;
                      if(_searchText.isEmpty){
                        names2 = names;
                      }else{
                        names2 = names.where((e) => '${basenameWithoutExtension(e.path)}'.toLowerCase().contains(_searchText)).toList();
                      }
                    });
                  },
                  decoration: new InputDecoration(
                    // prefixIcon: new Icon(Icons.search),
                      hintText: 'Search...'
                  ),
                ),
              ),
            ),
            TextButton(
              child: Text('Tap to open file'),
              onPressed: (){
                openFile();
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(12.0),
              child:  GridView.builder(
                itemCount: names2.length,
                shrinkWrap: true,
                primary: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                    childAspectRatio: 0.7
                ),
                itemBuilder: (context, index){
                  if('${extension(names2[index].path)}' == '.pdf'){
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: (){
                              OpenFile.open(names2[index].path);
                          },
                          child: Column(
                            children: [
                              Image.asset('./assets/logo_pdf.png',height: MediaQuery.of(context).size.width/2.5,),
                              Text('${basenameWithoutExtension(names2[index].path)}', textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                        GestureDetector(
                            onTap: (){
                              setState(() {
                                names.remove(names[index]);
                              });
                            },
                            child: Icon(Icons.remove_circle, size: 30, color: Colors.red,)
                        ),
                      ],
                    );
                  }else if('${extension(names2[index].path)}' == '.png' || '${extension(names2[index].path)}' == '.jpeg' || '${extension(names2[index].path)}' == '.jpg' ){
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: (){
                            OpenFile.open(names2[index].path);
                          },
                          child: Column(
                            children: [
                              Image.file(names2[index],height: MediaQuery.of(context).size.width/2.5, fit:BoxFit.cover,
                                  width: MediaQuery.of(context).size.width/2.5),
                              Text('${basenameWithoutExtension(names2[index].path)}', textAlign: TextAlign.center),
                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: (){
                           setState(() {
                             // names2.remove(names2[index]);
                             names.remove(names2[index]);
                           });
                          },
                          child: Padding(
                              padding:EdgeInsets.symmetric(horizontal: 10) ,
                              child: Icon(Icons.remove_circle, size: 30, color: Colors.red,))
                        )
                      ],
                    );
                  }else if('${extension(names2[index].path)}' == '.docx'){
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: (){
                            OpenFile.open(names2[index].path);
                          },
                          child: Column(
                            children: [
                              Image.asset('./assets/Logo_word.png',height: MediaQuery.of(context).size.width/2.5),
                              Text('${basenameWithoutExtension(names2[index].path)}', textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                        GestureDetector(
                            onTap: (){
                              setState(() {
                                // names2.remove(names2[index]);
                                names.remove(names[index]);
                              });
                            },
                            child: Icon(Icons.remove_circle, size: 30, color: Colors.red,)
                        )
                      ],
                    );
                  }else {
                    return SizedBox();
                  }
                },
              ),
            ),

          ],
        ),
      ),
    );

  }

}


