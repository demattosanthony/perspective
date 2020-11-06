import 'dart:io';

import 'package:local_image_provider/local_album.dart';
import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';

import '../models/file.dart';
import 'package:flutter/material.dart';
import 'package:storage_path/storage_path.dart';
import 'dart:convert';
import 'package:local_image_provider/local_image_provider.dart' as lip;
import 'package:local_image_provider/local_image.dart';

class ImagePickerModel extends BaseModel {
  List<LocalImage> _files;
  LocalAlbum _selectedModel;
  List<LocalAlbum> _albums;
  LocalImage _image;

  LocalImage get image => _image;
  LocalAlbum get selectedModel => _selectedModel;
  List<LocalImage> get files => _files;
  List<LocalAlbum> get albums => _albums;

  ImagePickerModel() {
    getImagesPath2();
  }

  setImage(LocalImage file) {
    setState(ViewState.Busy);
    _image = file;
    setState(ViewState.Idle);
  }
/*
  getImagesPath() async {
    setState(ViewState.Busy);
    var imagePath = await StoragePath.imagesPath;
    var response = jsonDecode(imagePath);
    var imageList = response as List;

    List<FileModel> files =
        imageList.map<FileModel>((e) => FileModel.fromJson(e)).toList();
    if (files != null && files.length > 0) {
      print(files);
      _selectedModel = files[0];
      _image = files[0].files[0];
    }
    setState(ViewState.Idle);
  } */

  getImagesPath2() async {
    setState(ViewState.Busy);

    lip.LocalImageProvider imageProvider = lip.LocalImageProvider();
    bool hasPermission = await imageProvider.initialize();
    if (hasPermission) {
      List<LocalAlbum> albums =
          await imageProvider.findAlbums(LocalAlbumType.all);
      List<LocalImage> images =
          await imageProvider.findLatest(100);
      //images.forEach((image) => print(image.id));
      _albums = albums;
      _image = images[0];
      _files = images;
      _selectedModel = albums[0];
    } else {
      print("The user has denied access to images on their device.");
    }

    setState(ViewState.Idle);
  }

  List<DropdownMenuItem> geItems() {
    return _albums
            .map((e) => DropdownMenuItem(
                  child: Text(
                    e.title,
                    style: TextStyle(color: Colors.black),
                  ),
                  value: e,
                ))
            .toList() ??
        [];
  }
}
