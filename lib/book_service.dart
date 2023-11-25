import 'book.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class BookService {
  Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse('https://escribo.com/books.json'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((bookData) => Book.fromJson(bookData)).toList();
    } else {
      throw Exception('Falha ao carregar os livros');
    }
  }
}