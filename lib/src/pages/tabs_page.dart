import 'package:flutter/material.dart';
import 'package:news_app/src/pages/my_favourites_page.dart';
import 'package:news_app/src/pages/headlines_page.dart';
import 'package:provider/provider.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _NavigationModel(),
      child: const Scaffold(
        body: Pages(),
        bottomNavigationBar: Navigation(),
      ),
    );
  }
}

class Navigation extends StatelessWidget {
  const Navigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final navigationModel = Provider.of<_NavigationModel>(context);

    return BottomNavigationBar(
        currentIndex: navigationModel.currentPage,
        onTap: (value) => navigationModel.currentPage = value,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.public), label: "Encabezados"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Para ti"),
        ]);
  }
}

class _NavigationModel with ChangeNotifier {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  int get currentPage => _currentPage;

  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();

    _pageController.animateToPage(value,
        duration: const Duration(milliseconds: 250), curve: Curves.bounceInOut);
  }

  PageController get pageController => _pageController;
}

class Pages extends StatelessWidget {
  const Pages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final navigationModel = Provider.of<_NavigationModel>(context);
    return PageView(
        onPageChanged: (value) => navigationModel.currentPage = value,
        physics: const BouncingScrollPhysics(),
        controller: navigationModel.pageController,
        children: [HeadlinesPage(), const MyFavouritesPage()]);
  }
}
