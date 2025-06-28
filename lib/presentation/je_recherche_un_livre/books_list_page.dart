import 'dart:convert';
import 'package:bookswap/data/models/books.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bookswap/core/animations/fade_animation.dart';

class BooksListPage extends StatefulWidget {
  const BooksListPage({super.key});

  @override
  State<BooksListPage> createState() => _BooksListPageState();
}

class _BooksListPageState extends State<BooksListPage> {
  List<dynamic> bookList = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('/books.json');
    final data = await json.decode(response);

    setState(() {
      bookList = data['books'].map((data) => Book.fromJson(data)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 20,
        leading: IconButton(
            padding: const EdgeInsets.only(left: 20),
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey.shade600,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                iconSize: 30,
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_none,
                  color: Colors.grey.shade400,
                )),
          )
        ],
        title: SizedBox(
          height: 45,
          child: TextField(
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              filled: true,
              fillColor: Colors.grey.shade200,
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none),
              hintText: "Chercher ex. L'Excellence en SVTEHB",
              hintStyle: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: bookList.length,
          itemBuilder: (context, index) {
            return FadeAnimation(
                (1.0 + index) / 4, bookComponent(book: bookList[index]));
          }),
    );
  }

  bookComponent({required Book book}) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(children: [
                  SizedBox(
                      width: 60,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(book.image),
                      )),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(book.title,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(book.editor,
                              style: TextStyle(color: Colors.grey[500])),
                        ]),
                  )
                ]),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    book.isChoosen = !book.isChoosen;
                  });
                },
                child: AnimatedContainer(
                    height: 35,
                    padding: const EdgeInsets.all(5),
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: book.isChoosen
                              ? Colors.red.shade100
                              : Colors.grey.shade300,
                        )),
                    child: Center(
                        child: book.isChoosen
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite_outline,
                                color: Colors.grey.shade600,
                              ))),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200),
                    child: Text(
                      book.subject,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(int.parse("0xff${book.statutColor}"))
                            .withAlpha(20)),
                    child: Text(
                      book.state,
                      style: TextStyle(
                        color: Color(int.parse("0xff${book.statutColor}")),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(int.parse("0xff${book.statutColor}"))
                            .withAlpha(20)),
                    child: Text(
                      book.statut,
                      style: TextStyle(
                          color: Color(int.parse("0xff${book.statutColor}"))),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
