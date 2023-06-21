import 'package:flutter/material.dart';
import 'package:news_app/src/models/news_model.dart';
import 'package:news_app/src/services/news_service.dart';
import 'package:news_app/src/theme/my_theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsList extends StatefulWidget {
  final List<Article> news;

  const NewsList({super.key, required this.news});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 500) >=
          (scrollController.position.maxScrollExtent)) {
        //si la posicion actual es mayor a la posicion maxima agrega 5
        // add5();
        print("llegue al final");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.news.length,
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              _News(article: widget.news[index], index: index),
            ],
          );
        });
  }
}

class _News extends StatefulWidget {
  Article article;
  int index;

  _News({required this.article, required this.index});

  @override
  State<_News> createState() => _NewsState();
}

class _NewsState extends State<_News> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        TopBarCard(
          article: widget.article,
          index: widget.index,
        ),
        const SizedBox(height: 10),
        TitleCard(
          article: widget.article,
          index: widget.index,
        ),
        ImageCard(
          article: widget.article,
          index: widget.index,
        ),
        BodyCard(
          article: widget.article,
          index: widget.index,
        ),
        const SizedBox(height: 10),
        ButtonsCard(
          article: widget.article,
          index: widget.index,
        ),
        Divider(
          color: Colors.grey[700],
        ),
      ],
    );
  }
}

class TitleCard extends StatelessWidget {
  Article article;
  int index;
  TitleCard({super.key, required this.article, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        article.title ?? "No title",
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  Article article;
  int index;
  ImageCard({super.key, required this.article, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
        child: Container(
            child: article.urlToImage != null
                ? FadeInImage(
                    placeholder: const AssetImage("assets/images/giphy.gif"),
                    image: NetworkImage(article.urlToImage))
                : const Image(image: AssetImage("assets/images/no-image.png"))),
      ),
    );
  }
}

class TopBarCard extends StatelessWidget {
  Article article;
  int index;

  TopBarCard({super.key, required this.article, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text(
            "${index + 1}",
            style: TextStyle(color: myTheme.colorScheme.secondary),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "${article.author}",
          ),
        ],
      ),
    );
  }
}

class BodyCard extends StatelessWidget {
  Article article;
  int index;

  BodyCard({super.key, required this.article, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        article.description ?? "",
      ),
    );
  }
}

class ButtonsCard extends StatefulWidget {
  Article article;
  int index;

  ButtonsCard({super.key, required this.article, required this.index});

  @override
  State<ButtonsCard> createState() => _ButtonsCardState();
}

bool isChecked = false;

class _ButtonsCardState extends State<ButtonsCard> {
  @override
  Widget build(BuildContext context) {
    final newsService = Provider.of<NewsService>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(children: [
        RawMaterialButton(
          onPressed: () {
            print(isChecked);
            isChecked = !isChecked;
            if (isChecked == true) {
              newsService.saveArticle(widget.article);
            } else {
              newsService.deleteArticle(widget.article);
            }
            setState(() {});
          },
          fillColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: isChecked == false
              ? const Icon(Icons.bookmark_outline_rounded)
              : const Icon(Icons.bookmark_outlined),
        ),
        const SizedBox(width: 10),
        RawMaterialButton(
          onPressed: () {
            launchToArticle(widget.article.url);
            print(widget.article.url);
          },
          fillColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: const Icon(Icons.more_horiz_outlined),
        ),
      ]),
    );
  }
}

Future<void> launchToArticle(url) async {
  Uri articleUrl = Uri.parse(url);
  await launchUrl(articleUrl);

  if (!await launchUrl(articleUrl)) {
    throw 'Could not launch $url';
  }
}
