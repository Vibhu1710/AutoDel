import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  
  void fetchItemSelectedState()
  {
    if((Provider.of<ImageList>(context).isInSelectedList(widget.image!))){
      widget.selected = true;
    }
    else {
      widget.selected = false;
    }
  }
  void updateSelectedList(BuildContext context)
  {
    if(Provider.of<ImageList>(context,listen: false).selectState){
      setState(() {
        widget.selected = !widget.selected;
      });
      (widget.selected) ? Provider.of<ImageList>(context, listen: false).addSelectedAsset(widget.image!): Provider.of<ImageList>(context, listen: false).removeSelectedAsset(widget.image!);
    }
  }
  @override
  Widget build(BuildContext context) {
    fetchItemSelectedState();
    return GestureDetector(
      onTap:(){
        updateSelectedList(context);
      },
      onLongPress: (){
        if(Provider.of<ImageList>(context,listen: false).selectState == false) {
          HapticFeedback.vibrate();
          Provider.of<ImageList>(context, listen: false).setSelectState();
          updateSelectedList(context);
        }
      },
      child: Padding(
        padding: widget.selected ? const EdgeInsets.all(5.0) : const EdgeInsets.all(0),
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
              Container(
                color: Colors.black.withOpacity(0.4),
              ),
              if(widget.selected)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, right: 5),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}