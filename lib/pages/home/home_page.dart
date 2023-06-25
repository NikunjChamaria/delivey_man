// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:delivery_man/pages/food/food_main_page.dart';
import 'package:delivery_man/pages/home/home.dart';
import 'package:delivery_man/pages/profile/profile.dart';
import 'package:delivery_man/pages/retail_store/retail_store_main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class HomePageZoom extends StatefulWidget {
  var token;
  HomePageZoom({super.key, required this.token});

  @override
  State<HomePageZoom> createState() => _HomePageZoomState();
}

final ZoomDrawerController z = ZoomDrawerController();

class _HomePageZoomState extends State<HomePageZoom> {
  Widget? page;
  @override
  void initState() {
    page = const HomeWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      style: DrawerStyle.style2,
      controller: z,
      borderRadius: 50,
      drawerShadowsBackgroundColor: Theme.of(context).colorScheme.surface,
      showShadow: true,
      openCurve: Curves.fastOutSlowIn,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      duration: const Duration(milliseconds: 300),
      menuBackgroundColor: Theme.of(context).colorScheme.surface,
      mainScreen: page!,
      mainScreenTapClose: true,
      menuScreenTapClose: true,
      menuScreen: MenuScreen(
        onPageChanged: (a) {
          setState(() {
            page = a;
          });
          ZoomDrawer.of(context)?.close();
        },
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key, required this.onPageChanged});
  final Function(Widget) onPageChanged;
  List<ListItems> drawerItems = [
    ListItems(const Icon(Icons.home), const Text("Home"), const HomeWidget()),
    ListItems(const Icon(Icons.local_pizza), const Text("Food"),
        const FoodMainPage()),
    ListItems(const Icon(Icons.shop), const Text("Retail Store"),
        const RetailStoreMainPage()),
    ListItems(
        const Icon(Icons.person), const Text("Profile"), const ProfilePage())
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: drawerItems
            .map((e) => ListTile(
                  textColor: Theme.of(context).colorScheme.secondary,
                  iconColor: Theme.of(context).colorScheme.secondary,
                  onTap: () {
                    onPageChanged(e.page);
                  },
                  title: e.title,
                  leading: e.icon,
                ))
            .toList(),
      ),
    );
  }
}

class ListItems {
  final Icon icon;
  final Text title;
  final Widget page;

  ListItems(this.icon, this.title, this.page);
}
