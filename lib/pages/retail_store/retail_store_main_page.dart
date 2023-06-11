import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:delivery_man/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/route.dart';
import '../../widgets/custom_button.dart';

class RetailStoreMainPage extends StatefulWidget {
  const RetailStoreMainPage({super.key});

  @override
  State<RetailStoreMainPage> createState() => _RetailStoreMainPageState();
}

class _RetailStoreMainPageState extends State<RetailStoreMainPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    const Page1(),
    const Page2(),
    const Page3(),
    const Page4(),
    const Page5(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: backGround,
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      backgroundColor: backGround,
      drawer: Drawer(
        elevation: 16,
        child: Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Color(0xFF212425),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        'https://picsum.photos/seed/52/600',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: 40,
                      decoration: const BoxDecoration(),
                    ),
                    const Text(
                      'Nikunj',
                      style: TextStyle(color: white, fontSize: 20)
                      /*FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              fontSize: 20,
                            )*/
                      ,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 15),
                      child: Container(
                        width: 314,
                        height: 46,
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const FaIcon(
                              // ignore: deprecated_member_use
                              FontAwesomeIcons.home,
                              color: Colors.white,
                              size: 24,
                            ),
                            Container(
                              width: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF212425),
                              ),
                            ),
                            CustomButton(
                                onTap: () async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  Get.toNamed(RouteHelper.homw, arguments: {
                                    'token': preferences.getString('token')
                                  });
                                  scaffoldKey.currentState!.closeDrawer();
                                },
                                text: "Home",
                                width: 140,
                                height: 50,
                                color: transparent,
                                color2: white,
                                textSize: 22)
                            /*FFButtonWidget(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                text: 'Home',
                                options: FFButtonOptions(
                                  height: 40,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 24, 0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: Color(0xFF212425),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white,
                                      ),
                                  elevation: 0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              )*/
                            ,
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 15),
                      child: Container(
                        width: 314,
                        height: 46,
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.no_food_sharp,
                              color: Colors.white,
                              size: 24,
                            ),
                            Container(
                              width: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF212425),
                              ),
                            ),
                            CustomButton(
                                onTap: () {
                                  Get.toNamed(RouteHelper.getFood());
                                  scaffoldKey.currentState!.closeDrawer();
                                },
                                text: "Food",
                                width: 140,
                                height: 50,
                                color: transparent,
                                color2: white,
                                textSize: 22)
                            /*FFButtonWidget(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                text: 'Food',
                                options: FFButtonOptions(
                                  height: 40,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 24, 0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: Color(0xFF212425),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white,
                                      ),
                                  elevation: 0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),*/
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 15),
                      child: Container(
                        width: 314,
                        height: 46,
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.local_convenience_store_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            Container(
                              width: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF212425),
                              ),
                            ),
                            CustomButton(
                                onTap: () {
                                  Get.toNamed(RouteHelper.getRetail());
                                  scaffoldKey.currentState!.closeDrawer();
                                },
                                text: "Retail Store",
                                width: 200,
                                height: 50,
                                color: transparent,
                                color2: white,
                                textSize: 22)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 15),
                      child: Container(
                        width: 314,
                        height: 46,
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                            Container(
                              width: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF212425),
                              ),
                            ),
                            CustomButton(
                                onTap: () async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  Get.toNamed(RouteHelper.profile, arguments: {
                                    'token': preferences.getString('token')
                                  });
                                  scaffoldKey.currentState!.closeDrawer();
                                },
                                text: "Profile",
                                width: 140,
                                height: 50,
                                color: transparent,
                                color2: white,
                                textSize: 22)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
              color: lightGrey!,
              showLabel: false,
              notchColor: white,

              /// restart app if you change removeMargins
              removeMargins: false,
              bottomBarWidth: 500,
              durationInMilliSeconds: 300,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: black,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 1',
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.star, color: black),
                  activeItem: Icon(
                    Icons.star,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 2',
                ),

                ///svg example
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.search,
                    color: black,
                  ),
                  activeItem: Icon(
                    Icons.search,
                    color: Colors.blueGrey,
                  ),
                  itemLabel: 'Page 3',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.settings,
                    color: black,
                  ),
                  activeItem: Icon(
                    Icons.settings,
                    color: Colors.pink,
                  ),
                  itemLabel: 'Page 4',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.person,
                    color: black,
                  ),
                  activeItem: Icon(
                    Icons.person,
                    color: Colors.yellow,
                  ),
                  itemLabel: 'Page 5',
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

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: backGround,
        child: const Center(
            child: Text(
          'Page 1',
          style: TextStyle(color: white),
        )));
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: backGround,
        child: const Center(
            child: Text('Page 2', style: TextStyle(color: white))));
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: backGround,
        child: const Center(
            child: Text('Page 3', style: TextStyle(color: white))));
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: backGround,
        child: const Center(
            child: Text('Page 4', style: TextStyle(color: white))));
  }
}

class Page5 extends StatelessWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: backGround,
        child: const Center(
            child: Text('Page 5', style: TextStyle(color: white))));
  }
}
