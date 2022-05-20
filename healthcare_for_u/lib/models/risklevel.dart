import 'package:flutter/material.dart';

class RiskLevel {
  String? title;
  String? description;

  RiskLevel();

  @override
  String toString() {
    return title!;
  }

  void setTitle(String title) {
    this.title = title;
  }

  void setDescription(String description) {
    this.description = description;
  }
}
