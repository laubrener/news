import 'package:flutter/material.dart';
import 'package:news_app/src/models/category_model.dart';
import 'package:news_app/src/services/news_service.dart';
import 'package:news_app/src/theme/my_theme.dart';
import 'package:news_app/src/widgets/news_list.dart';
import 'package:provider/provider.dart';

class HeadlinesPage extends StatefulWidget {
  HeadlinesPage({Key? key}) : super(key: key);

  @override
  State<HeadlinesPage> createState() => _HeadlinesPageState();
}

class _HeadlinesPageState extends State<HeadlinesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<NewsService>(context).categories;
    final newsService = Provider.of<NewsService>(context, listen: false);

    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          CategoriesList(categories: categories, newsService: newsService),
          Expanded(
              child: newsService.getSelectedCategory.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : NewsList(news: newsService.getSelectedCategory)),
        ],
      )),
    );
  }
}

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
    required this.categories,
    required this.newsService,
  });

  final List<Category> categories;
  final NewsService newsService;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              newsService.selectedCategory = categories[index].name;
            },
            child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                child: categories[index].name != newsService.selectedCategory
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        width: 90,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromARGB(24, 255, 255, 255)),
                        child: Column(
                          children: [
                            Icon(
                              categories[index].icon,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Text(
                                categories[index].name[0].toUpperCase() +
                                    categories[index].name.substring(1),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        width: 90,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromARGB(24, 255, 255, 255)),
                        child: Column(
                          children: [
                            Icon(categories[index].icon,
                                color: myTheme.colorScheme.secondary),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Text(
                                categories[index].name[0].toUpperCase() +
                                    categories[index].name.substring(1),
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: myTheme.colorScheme.secondary),
                              ),
                            )
                          ],
                        ))),
          );
        },
      ),
    );
  }
}
