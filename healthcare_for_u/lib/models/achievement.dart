import 'package:flutter/material.dart';

class Achievement {
  String? title;
  //double steps;
  String? assetPicture;

  Achievement();

  @override
  String toString() {
    // TODO: implement toString
    return title!;
  }

  void setTitle(String title) {
    this.title = title;
  }

  void setPicture(String assetPicture) {
    this.assetPicture = assetPicture;
  }
}
