import 'package:flutter/material.dart';
import 'image_list.dart';
import 'image_asset.dart';
import 'package:provider/provider.dart';

class GalleryItem extends StatefulWidget {
  bool selected = false;
  ImageAsset? image;
  GalleryItem({ Key? key, @required this.image}) : super(key: key);
  @override
  _GalleryItemState createState() => _GalleryItemState();
}

class _GalleryItemState extends State<GalleryItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        setState(() {
          widget.selected=!widget.selected;
        });
        (widget.selected) ? Provider.of<ImageList>(context, listen: false).addSelectedAsset(widget.image!): Provider.of<ImageList>(context, listen: false).removeSelectedAsset(widget.image!);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                color: Colors.grey[700],
                child: const Center(
                  child: Icon(
                    Icons.photo,
                    color: Colors.grey,
                    ),
                ),
              ),
            ),
            Positioned.fill(
              child: Image.memory(
                widget.image!.thumbData!, 
                fit: BoxFit.cover,
              ),
            ),
            if(widget.selected) 
            const Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: 5, bottom: 5),
                child: Icon(
                  Icons.check,
                  color: Colors.orangeAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}