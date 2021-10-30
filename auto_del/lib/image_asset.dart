import 'dart:typed_data';
import 'package:flutter/cupertino.dart';

class ImageAsset {
  String? id;
  Uint8List? thumbData;
  ImageAsset({@required this.id,@required this.thumbData});
}