import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'image_asset.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ImageAsset> imageAsset = [];
  bool permit = false;
  int index=0;
  List<AssetEntity>? mediaHouse;
  File? myFile;
  void deleteImageAsset() async
  { 
    if(imageAsset.isNotEmpty)
    {
      final List<String> result = await PhotoManager.editor.deleteWithIds([imageAsset[index].id!]);
      await callAssetPathList();
      print(mediaHouse);
    }
  }
  Future<void> callAssetPathList() async
  {
    if (permit) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true, type: RequestType.image);
      print(albums);
      List<AssetEntity> media = await albums[0].getAssetListPaged(0, 20);
      mediaHouse = media;
      print(mediaHouse);
      File? store = await mediaHouse?[0].file;
      List<ImageAsset> mediaAsset = [];
      for(var asset in media)
      { 
        File? temp = await asset.file;
        mediaAsset.add(ImageAsset(id: asset.id, file: temp));
      }
      setState((){
        //myFile = store;
        imageAsset = mediaAsset;
      });
    }
  }
  void getPermission() async
  {
    var result = await PhotoManager.requestPermission();
    if (result) {
      // granted
      permit = result;
      await callAssetPathList();
    }
    else {
      // if not granted
    }
  }
  @override
  void initState() {
    super.initState();
    getPermission();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              child: imageAsset.isNotEmpty ? Image.file(
                imageAsset[index].file as File,
              )
              : null,
            ),
            IconButton(
              onPressed: () {
                deleteImageAsset();
                  // setState(() {
                  //   oneImage = null;
                  // });
              },
              icon: const Icon(Icons.delete),
              color: Colors.grey,
            ) 
          ],
        ),
      )
    );
  }
}
