import 'dart:collection';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'image_asset.dart';
import 'package:photo_manager/photo_manager.dart';

const kminSizeNotify = 200;

class ImageList extends ChangeNotifier {
  bool _selectState = false;
  bool _permit = false;
  List<AssetEntity>? _mediaHouse;

  final List<ImageAsset> _imageAsset = [];
  final List<ImageAsset> _selectedAsset = [];
  
  bool get selectState {
    return _selectState;
  }
  void setSelectState() {
    _selectState = true;
  }
  void resetSelectState() {
    _selectState = false;
  }

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
  bool isInSelectedList(ImageAsset image)
  {
    return _selectedAsset.contains(image);
  }
  void addSelectedAsset(ImageAsset image)
  {
    print('added image to selected');
    _selectedAsset.add(image);
    notifyListeners();
  }
  void removeSelectedAsset(ImageAsset image)
  {
    print('removed image from selected');
    _selectedAsset.remove(image);
    if(selectedAssetCount==0) {
      _selectState =false;
      HapticFeedback.lightImpact();
    }
    notifyListeners();
  }
  void clearSelectionList()
  {
    _selectedAsset.clear();
    _selectState = false;
    notifyListeners();
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
      clearSelectionList();
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
        if(imageAssetCount % kminSizeNotify == 0)
        {
          notifyListeners();
        }
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