import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/auth/secrets.dart';
import 'package:news_app/src/models/category_model.dart';
import 'package:news_app/src/models/news_model.dart';
import "package:http/http.dart" as http;

const country = "us";
const _url =
    "https://newsapi.org/v2/top-headlines?apiKey=$apiKey&country=$country";

class NewsService with ChangeNotifier {
  List<Article> headlines = [];
  List<Article> myArticles = [];
  String _selectedCategory = "business";
  int _page = 1;

  List<Category> categories = [
    Category(FontAwesomeIcons.building, "business"),
    Category(FontAwesomeIcons.tv, "entertainment"),
    Category(FontAwesomeIcons.addressCard, "general"),
    Category(FontAwesomeIcons.headSideVirus, "health"),
    Category(FontAwesomeIcons.vials, "science"),
    Category(FontAwesomeIcons.volleyball, "sports"),
    Category(FontAwesomeIcons.memory, "technology")
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    getTopHeadlines(_page);
    _page++;

    for (var item in categories) {
      categoryArticles[item.name] = [];
    }
    getHeadlinesByCategory(selectedCategory);
  }

  String get selectedCategory => _selectedCategory;
  set selectedCategory(String value) {
    _selectedCategory = value;

    getHeadlinesByCategory(value);
    notifyListeners();
  }

  List<Article> get getSelectedCategory => categoryArticles[selectedCategory]!;

  getTopHeadlines(int page) async {
    Uri url = Uri.parse("$_url&page=$page");
    final resp = await http.get(url);

    final newsResponse = NewsResponse.fromJson(resp.body);

    headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getHeadlinesByCategory(String value) async {
    if (categoryArticles[value]!.isNotEmpty) {
      return categoryArticles[value];
    }
    Uri url = Uri.parse("$_url&category=$value");
    final resp = await http.get(url);

    final newsResponse = NewsResponse.fromJson(resp.body);

    categoryArticles[value]?.addAll(newsResponse.articles);

    notifyListeners();
  }

  saveArticle(Article article) {
    if (!myArticles.contains(article)) {
      myArticles.add(article);
    }
    notifyListeners();
  }

  // createProduct(Article article) async {
  //   final url = Uri.https(DBUrl, 'articles.json');
  //   final resp = await http.post(url, body: article.toJson());
  //   final decodedData = json.decode(resp.body);

  //   myArticles.add(article);
  //   notifyListeners();
  // }

  deleteArticle(Article article) {
    myArticles.remove(article);
    notifyListeners();
  }
}
