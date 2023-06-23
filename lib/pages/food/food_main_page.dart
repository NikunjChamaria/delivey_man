import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:delivery_man/pages/food/cart_history.dart';
import 'package:delivery_man/pages/food/favorite.dart';
import 'package:delivery_man/pages/food/food_home_page.dart';
import 'package:delivery_man/pages/food/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class FoodMainPage extends StatefulWidget {
  const FoodMainPage({super.key});

  @override
  State<FoodMainPage> createState() => _FoodMainPageState();
}

class _FoodMainPageState extends State<FoodMainPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _pageController = PageController(initialPage: 0);
  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    const FoodHomePage(),
    const FavouritePage(),
    const SearchPage(),
    const CartHistory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          onPressed: () {
            ZoomDrawer.of(context)!.open();
          },
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: Theme.of(context).colorScheme.tertiary,
              showLabel: false,
              notchColor: Theme.of(context).colorScheme.secondary,

              /// restart app if you change removeMargins
              removeMargins: false,
              bottomBarWidth: 500,
              durationInMilliSeconds: 300,
              bottomBarItems: [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  activeItem: const Icon(
                    Icons.home_filled,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 1',
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.star,
                      color: Theme.of(context).colorScheme.secondary),
                  activeItem: const Icon(
                    Icons.star,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 2',
                ),

                ///svg example
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  activeItem: const Icon(
                    Icons.search,
                    color: Colors.blueGrey,
                  ),
                  itemLabel: 'Page 3',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.shopping_cart_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  activeItem: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.pink,
                  ),
                  itemLabel: 'Page 4',
                ),
              ],
              onTap: (index) {
                /// perform action on tab change and to update pages you can update pages without pages

                _pageController.jumpToPage(index);
              },
            )
          : null,
    );
  }
}
