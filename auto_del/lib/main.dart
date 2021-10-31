import 'package:auto_del/image_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'gallery_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>ImageList(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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
  String dynamicTitle()
  { int count = Provider.of<ImageList>(context).selectedAssetCount;
    if(count>1)
    {
      return '$count images selected';
    }
    else
    {
      return '$count image selected';
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ImageList>(context, listen: false).checkPermission();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(Provider.of<ImageList>(context, listen: false).selectState)
        {
          Provider.of<ImageList>(context, listen: false).clearSelectionList();
          HapticFeedback.lightImpact();
          return false;
        }
        return true;
      }, 
      child: Scaffold(
        appBar: AppBar(
          title: Provider.of<ImageList>(context).selectState ? Text(dynamicTitle()) : Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                Provider.of<ImageList>(context, listen: false).deleteImageAsset();
              },
            )
          ],
        ),
        body: const GalleryView(),
      ),
    );
  }
}
