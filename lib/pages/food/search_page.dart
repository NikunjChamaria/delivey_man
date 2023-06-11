import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/height_spacer.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:delivery_man/constants/width_spacer.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final _unfocusNode = FocusNode();
    TextEditingController search = TextEditingController();
    @override
    void dispose() {
      search.dispose();
      _unfocusNode.dispose();
      super.dispose();
    }

    Widget list1() {
      return Column(
        children: <Widget>[
          ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        child: Image.network(
                            "https://cdn.wallpapersafari.com/34/46/W6l4nL.jpg"),
                      ),
                      WidthSpacer(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Chole Bhature",
                            style: appstyle(white, 20, FontWeight.w500),
                          ),
                          Text(
                            "Dish",
                            style: appstyle(white, 16, FontWeight.normal),
                          )
                        ],
                      )
                    ],
                  ),
                );
              })),
        ],
      );
    }

    return Scaffold(
      backgroundColor: backGround,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                children: [
                  SearchBar(
                    focusNode: _unfocusNode,
                    onTap: () {},
                    controller: search,
                    leading: const Icon(Icons.search),
                    hintText: "Search",
                  ),
                  const HeightSpacer(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "PAST SEARCHES",
                        style: appstyle(white, 16, FontWeight.w500),
                      ),
                      Text(
                        "Clear",
                        style: appstyle(white, 14, FontWeight.normal),
                      )
                    ],
                  ),
                  HeightSpacer(height: 10),
                  Container(child: list1()),
                  HeightSpacer(height: 50),
                  Container(
                    height: 100,
                    width: 100,
                    color: white,
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "POPULAR DISHES",
                    style: appstyle(white, 16, FontWeight.w500),
                  ),
                  HeightSpacer(height: 10),
                  ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                child: Image.network(
                                    "https://cdn.wallpapersafari.com/34/46/W6l4nL.jpg"),
                              ),
                              WidthSpacer(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Chole Bhature",
                                    style: appstyle(white, 20, FontWeight.w500),
                                  ),
                                  Text(
                                    "Dish",
                                    style:
                                        appstyle(white, 16, FontWeight.normal),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      })),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
