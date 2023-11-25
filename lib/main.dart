import 'package:flutter/material.dart';
import 'book.dart';
import 'book_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Ebooks',
      home: BookListScreen(),
    );
  }
}

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final BookService _bookService = BookService();
  late Future<List<Book>> _books;

  // Mova a lista de livros para o nível da classe.
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    _books = _bookService.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Ebooks'),
      ),
      body: FutureBuilder<List<Book>>(
        future: _books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}'),
            );
          } else {
            // Atualize a lista de livros com os dados recebidos.
            books = snapshot.data!;

            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(books[index].title),
                  subtitle: Text(books[index].author),
                  leading: Image.network(books[index].coverUrl),
                  onTap: () {
                    // Chama o método download ao tocar na capa do livro.
                    books[index].download();
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
