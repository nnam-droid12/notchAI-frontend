import 'dart:io';
import 'package:flutter/material.dart';

class ScanSkinState extends ChangeNotifier {
  File? selectedImage;

  void setSelectedImage(File? image) {
    selectedImage = image;
    notifyListeners();
  }
}
