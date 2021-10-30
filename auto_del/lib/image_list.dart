import 'dart:collection';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'image_asset.dart';
import 'package:photo_manager/photo_manager.dart';


class ImageList extends ChangeNotifier {
  bool _permit = false;
  List<AssetEntity>? _mediaHouse;

  final List<ImageAsset> _imageAsset = [];
  final List<ImageAsset> _selectedAsset = [];
  
  UnmodifiableListView<ImageAsset> get imageAsset {
    return UnmodifiableListView(_imageAsset);
  }

  int get imageAssetCount
  {
    return _imageAsset.length;
  }
  int get selectedAssetCount
  {
    return _selectedAsset.length;
  }

  void addSelectedAsset(ImageAsset image)
  {
    _selectedAsset.add(image);
  }
  void removeSelectedAsset(ImageAsset image)
  {
    _selectedAsset.remove(image);
  }

  void deleteImageAsset() async
  { 
    if((imageAssetCount!=0) && (selectedAssetCount!=0))
    {
      final List<String> result = await PhotoManager.editor.deleteWithIds([for (var ele in _selectedAsset) ele.id!]);
      //await callAssetPathList();
      for(var ele in _selectedAsset)
      {
        _imageAsset.remove(ele);
      }
      _selectedAsset.clear();
      notifyListeners();
    }
  }

  Future<void> callAssetPathList() async
  {
    if (_permit) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true, type: RequestType.image);
      print(albums);
      List<AssetEntity> media = await albums[0].getAssetListPaged(0, 1000);
      _mediaHouse = media;
      print(_mediaHouse);
      for(var asset in media)
      { 
        Uint8List? temp = await asset.thumbDataWithSize(175, 170);
        _imageAsset.add(ImageAsset(id: asset.id, thumbData: temp));
      }
      notifyListeners();
    }
  }

  void checkPermission() async
  {
    var result = await PhotoManager.requestPermission();
    if (result) {
      // granted
      _permit = result;
      await callAssetPathList();
    }
    else {
      // if not granted
    }
  }
}