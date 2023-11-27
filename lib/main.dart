import 'package:flutter/material.dart';
import 'book.dart';
import 'book_service.dart';
//
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
  List<Book> books = [];
  List<Book> favoriteBooks = [];

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
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              _navigateToFavoriteScreen();
            },
          ),
        ],
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
            books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(books[index].title),
                  subtitle: Text(books[index].author),
                  leading: GestureDetector(
                    onTap: () {
                      // Agora o download é acionado ao tocar na capa
                      books[index].download().then((_) {
                        // Após o download, exibe uma mensagem
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Download concluído para ${books[index].title}'),
                          ),
                        );
                      }).catchError((error) {
                        // Em caso de erro, exibe uma mensagem de erro
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao baixar o livro: $error'),
                          ),
                        );
                      });
                    },
                    child: Image.network(books[index].coverUrl),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      books[index].isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: books[index].isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      setState(() {
                        books[index].isFavorite = !books[index].isFavorite;

                        if (books[index].isFavorite) {
                          favoriteBooks.add(books[index]);
                        } else {
                          favoriteBooks.remove(books[index]);
                        }
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _navigateToFavoriteScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoriteBooksScreen(favoriteBooks),
      ),
    );
  }
}

class FavoriteBooksScreen extends StatelessWidget {
  final List<Book> favoriteBooks;

  FavoriteBooksScreen(this.favoriteBooks);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livros Favoritos'),
      ),
      body: ListView.builder(
        itemCount: favoriteBooks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favoriteBooks[index].title),
            subtitle: Text(favoriteBooks[index].author),
            leading: Image.network(favoriteBooks[index].coverUrl),
            onTap: () {
              favoriteBooks[index].download().then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Download concluído para ${favoriteBooks[index].title}'),
                  ),
                );
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao baixar o livro: $error'),
                  ),
                );
              });
            },
          );
        },
      ),
    );
  }
}
