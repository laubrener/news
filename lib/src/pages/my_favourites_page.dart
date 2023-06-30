import 'package:flutter/material.dart';
import 'package:news_app/src/services/news_service.dart';
import 'package:news_app/src/theme/my_theme.dart';
import 'package:news_app/src/widgets/news_list.dart';
import 'package:provider/provider.dart';

class MyFavouritesPage extends StatefulWidget {
  const MyFavouritesPage({Key? key}) : super(key: key);

  @override
  State<MyFavouritesPage> createState() => _MyFavouritesPageState();
}

class _MyFavouritesPageState extends State<MyFavouritesPage>
    with AutomaticKeepAliveClientMixin {
  // para mantener el estado de la lista
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final newsService = Provider.of<NewsService>(context);
    final myArticles = Provider.of<NewsService>(context).myArticles;

    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Container(
              alignment: Alignment.center,
              height: 50,
              child: Text(
                "My headlines",
                style: TextStyle(
                    color: myTheme.colorScheme.secondary, fontSize: 20),
              )),
          Expanded(
              child: myArticles.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : NewsList(news: myArticles))
        ],
      )),
    );
  }
}
