import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'image_list.dart';
import 'gallery_item.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (Provider.of<ImageList>(context).imageAssetCount!=0) ? Scrollbar(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: GridView.builder(
            cacheExtent: 500.0,
            itemCount: Provider.of<ImageList>(context).imageAssetCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              //childAspectRatio: 0.7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemBuilder: (context, index) {
              return GalleryItem(image: Provider.of<ImageList>(context).imageAsset[index]);
            }
          ),
        )
      ) : null,
    );
  }
}
