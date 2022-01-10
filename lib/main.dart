import 'dart:io';

import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  String text = "";
  final picker = ImagePicker();

  Future<void> _imgFromCamera() async {
    LostData response = await picker.getLostData();
    final image = await picker.getImage(
      source: ImageSource.camera,
    );

    setState(() {
      _image = File(image!.path);
    });
    var bytes = await _image!.readAsBytes();
    var tags = await readExifFromBytes(bytes);
    var sb = StringBuffer();
    tags.forEach((k, v) {
      sb.write("$k: $v \n");
    });

    setState(() {
      text = sb.toString();
    });
  }

  // Future<void> _getExifFromFile() async {
  //   if (_image == null) {
  //     setState(() {
  //       text = "";
  //     });
  //   }
  //
  //   var bytes = await _image!.readAsBytes();
  //   var tags = await readExifFromBytes(bytes);
  //   var sb = StringBuffer();
  //
  //   tags.forEach((k, v) {
  //     sb.write("$k: $v \n");
  //   });
  //
  //   setState(() {
  //     text = sb.toString();
  //   });
  // }

  // void _showPicker(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return SafeArea(
  //           child: Container(
  //             child: new Wrap(
  //               children: <Widget>[
  //                 new ListTile(
  //                   leading: new Icon(Icons.photo_camera),
  //                   title: new Text('Camera'),
  //                   onTap: () {
  //                     _imgFromCamera();
  //                     _getExifFromFile();
  //                     Navigator.of(context).pop();
  //                     setState(() {});
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Text(text),
        )
        // Column(
        //   children: <Widget>[
        //     SizedBox(
        //       height: 32,
        //     ),
        //     Center(
        //       child: GestureDetector(
        //         onTap: () {
        //           _showPicker(context);
        //         },
        //         child: CircleAvatar(
        //           radius: 55,
        //           backgroundColor: Color(0xffFDCF09),
        //           child: _image != null
        //               ? ClipRRect(
        //                   borderRadius: BorderRadius.circular(50),
        //                   child: Image.file(
        //                     _image!,
        //                     width: 100,
        //                     height: 100,
        //                     fit: BoxFit.fitHeight,
        //                   ),
        //                 )
        //               : Container(
        //                   decoration: BoxDecoration(
        //                       color: Colors.grey[200],
        //                       borderRadius: BorderRadius.circular(50)),
        //                   width: 100,
        //                   height: 100,
        //                   child: Icon(
        //                     Icons.camera_alt,
        //                     color: Colors.grey[800],
        //                   ),
        //                 ),
        //         ),
        //       ),
        //     ),
        //     Text(text),
        //   ],
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera),
        onPressed: () async {
          await _imgFromCamera();
          // await _getExifFromFile();
          setState(() {});
        },
      ),
    );
  }
}
