import 'package:bookswap/presentation/choice_page.dart';
import 'package:bookswap/presentation/j_ai_un_livre/add_books.dart';
import 'package:bookswap/presentation/je_recherche_un_livre/books_list_page.dart';
import 'package:flutter/material.dart';
import '../presentation/login_page.dart';
import '../presentation/register_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String register = '/register';
  static const String choice = '/choice';
  static const String bookList = '/books-list';
  static const String addBookForm = '/add-book-form';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const LoginPage(),
        register: (context) => const RegisterPage(),
        choice: (context) => const ChoicePage(),
        bookList: (context) => const BooksListPage(),
        addBookForm: (context) => const AddBooksPage(),
      };
}
