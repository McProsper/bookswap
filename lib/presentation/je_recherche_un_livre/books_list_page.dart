import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../app/routes.dart';
import 'package:second_app/core/animations/fade_animation.dart';

class BooksListPage extends StatefulWidget {
  const BooksListPage({super.key});

  @override
  State<BooksListPage> createState() => _BooksListPageState();
}

class _BooksListPageState extends State<BooksListPage> {
  final _searchController = TextEditingController();
  String _selectedLevel = 'Tous';
  String _selectedCondition = 'Tous';
  List<dynamic> _books = [];
  bool _isLoading = false;

  Future<void> _searchBooks() async {
    setState(() => _isLoading = true);
    try {
      final books = await ApiService().searchBooks(
        query: _searchController.text,
        level: _selectedLevel,
        condition: _selectedCondition,
      );
      setState(() => _books = books);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _searchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        leadingWidth: 60,
        leading: IconButton(
            padding: const EdgeInsets.only(left: 25, right: 25),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.choice);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey.shade600,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                iconSize: 30,
                onPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      String tempLevel = _selectedLevel;
                      String tempCondition = _selectedCondition;
                      return StatefulBuilder(
                        builder: (context, setModalState) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Filtrer les livres', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: tempLevel,
                                  decoration: InputDecoration(labelText: 'Système éducatif'),
                                  items: ['Tous', 'Primaire', 'Collège', 'Lycée']
                                      .map((level) => DropdownMenuItem(
                                            value: level,
                                            child: Text(level),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setModalState(() => tempLevel = value ?? 'Tous');
                                  },
                                ),
                                SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: tempCondition,
                                  decoration: InputDecoration(labelText: 'État'),
                                  items: ['Tous', 'Neuf', 'Occasion']
                                      .map((condition) => DropdownMenuItem(
                                            value: condition,
                                            child: Text(condition),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setModalState(() => tempCondition = value ?? 'Tous');
                                  },
                                ),
                                SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedLevel = tempLevel;
                                      _selectedCondition = tempCondition;
                                    });
                                    Navigator.pop(context);
                                    _searchBooks();
                                  },
                                  child: Text('Appliquer'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.filter_alt_outlined,
                  color: Colors.grey.shade400,
                )),
          )
        ],
        title: SizedBox(
          height: 45,
          child: TextField(
            controller: _searchController,
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
              hintText: "Rechercher un livre",//"Chercher ex. L'Excellence en SVTEHB",
              hintStyle: const TextStyle(fontSize: 14),
            ),
            onChanged: (value) => _searchBooks(),
          ),
        ),
      ),
      body: 
        _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: _books.length,
          itemBuilder: (context, index) {
            return FadeAnimation(
                (1.0 + index) / 4, bookComponent(book: _books[index]));
          }),
    );
  }

  bookComponent({required dynamic book}) {
    String imageUrl = book['imageUrl'] ?? '';
    if (imageUrl.isNotEmpty) {
      final parts = imageUrl.split('/upload/');
      if (parts.length == 2) {
        imageUrl = '${parts[0]}/upload/w_80,h_80,c_fill/${parts[1]}';
      }
    }
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
                        child: imageUrl != ""
                          ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                          : Icon(Icons.book),//Image.network(book.imageUrl, fit: BoxFit.cover),
                      )),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(book['title'],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text('author: ' +book['author'],
                              style: TextStyle(color: Colors.grey[500])),
                          const SizedBox(
                            height: 5,
                          ),
                          if (book['level'] != null && book['level'] != '')
                            Text('classe: ' + book['level'], style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                        ]),
                  )
                ]),
              ),
              SizedBox.shrink(),
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
                      book['systeme'],
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
                        color: Colors.grey.shade200),
                    child: Text(
                      book['condition'],
                      style: const TextStyle(color: Colors.black),
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
