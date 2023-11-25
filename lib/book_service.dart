import 'book.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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

  Future<void> downloadBook(String downloadUrl) async {
    final response = await http.get(Uri.parse(downloadUrl));

    if (response.statusCode == 200) {
      final appDocDir = await getApplicationDocumentsDirectory();
      final file = File('${appDocDir.path}/book.epub');
      await file.writeAsBytes(response.bodyBytes);
    } else {
      throw Exception('Falha ao baixar o livro');
    }
  }
}