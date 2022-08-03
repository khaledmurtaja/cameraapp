import 'dart:io';
import 'package:flutter/material.dart';

class CameraGallery extends StatelessWidget {
  List<FileSystemEntity> images = [];
  CameraGallery(this.images);

  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    print(images);
    return Scaffold(
        appBar: AppBar(),
        body: PageView.builder(
          controller: _controller,
          itemCount: images.length,
          itemBuilder: (context, index) => galleryItem(index),
        ));
  }

  Widget galleryItem(int index) {
    int lastIndex = images.length - 1;
    return Image(
      image: Image.file(File(images[lastIndex - index].path)).image,
    );
  }
}
