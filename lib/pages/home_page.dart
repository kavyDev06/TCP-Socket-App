import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcpsocketapp/helpers/socket_service.dart';
import 'package:widget_zoom/widget_zoom.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isUpload = false;

  final ImagePicker _picker = ImagePicker();
  String imagePath = "";




  Future<void> pickImage(String source)async{
    ImageSource selectedSource;
    if (source == "Camera") {
      selectedSource = ImageSource.camera;
    } else if (source == "Gallery") {
      selectedSource = ImageSource.gallery;
    } else {
      // handle invalid value
      throw Exception("Invalid source: $source");
    }
    XFile? image = await _picker.pickImage(source:selectedSource);
    File image1 = File(image!.path);
  setState(() {
    isUpload = true;
    imagePath = image.path;
  });
    await SocketHelper.instance.connect("192.168.1.6",9999);
    await SocketHelper.instance.sendImage(image1);
    SnackBar(content: Text("Upload To Sever"));
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              primary: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16,left: 16,top: 24),
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Colors.grey.shade300
                    ),
                    child: isUpload == true ?  ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: WidgetZoom(
                             heroAnimationTag: "image",
                           zoomWidget: Image.file(File(imagePath),fit: BoxFit.cover,))):Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image),
                        SizedBox(height: 10,),
                        Text("Upload image",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        showModalBottomSheet(context: context, builder: (context) {
          return Container(
            width: double.infinity,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 24,
              children: [
                GestureDetector(
                  onTap:()async{
                    await pickImage("Camera");
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Icon(Icons.camera),
                      ),
                      Expanded(child: Text("Camera",style: TextStyle(fontSize: 18),)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: ()async{
                    await pickImage("Gallery");
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Icon(Icons.image),
                      ),
                      Expanded(child: Text("Gallery",style: TextStyle(fontSize: 18),)),
                    ],
                  ),
                )
              ],
            ),
          );
        },);
      },child: Icon(Icons.upload),),
    );
  }
}
