// import 'package:flutter/material.dart';

class Book {
  final String image;
  final String title;
  final String author;
  final String editor;
  final String classe;
  final String subject;
  final String category;
  final String state;
  final String statut;
  final String statutColor;
  
  bool isChoosen;

  Book(this.image, this.title, this.author, this.editor, this.classe, this.subject, this.category, this.state, this.statut, this.statutColor, this.isChoosen);

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      json['image'], 
      json['title'], 
      json['author'], 
      json['editor'], 
      json['classe'],
      json['subject'],
      json['category'],
      json['state'],
      json['statut'],
      json['statutColor'],
      json['isChoosen']
    );
  }
}