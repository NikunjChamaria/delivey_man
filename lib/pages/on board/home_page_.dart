import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/route.dart';
import 'package:delivery_man/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  PageController pageViewController = PageController();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  PageController get pageViewCurrentIndex => pageViewController =
      (pageViewController.hasClients && pageViewController.page != null
          ? pageViewController.page!.round()
          : 0) as PageController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pageViewController.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: backGround,
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: 862,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
                  child: PageView(
                    controller: pageViewController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Container(
                              width: double.infinity,
                              height: 814,
                              decoration: const BoxDecoration(
                                color: Color(0xFF212425),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0, 1.13),
                            child: Container(
                              width: double.infinity,
                              height: 374,
                              decoration: const BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                  topLeft: Radius.circular(120),
                                  topRight: Radius.circular(120),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(-0.14, -0.03),
                            child: Lottie.network(
                              'https://assets6.lottiefiles.com/packages/lf20_3tryizhw.json',
                              width: 306,
                              height: 367,
                              fit: BoxFit.cover,
                              frameRate: FrameRate(60),
                              animate: true,
                            ),
                          ),
                          const Align(
                              alignment: AlignmentDirectional(-0.65, 0.54),
                              child: Text(
                                'Welcome!!!',
                                style: TextStyle(
                                  color: black,
                                  fontFamily: 'Roboto',
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          const Align(
                              alignment: AlignmentDirectional(-0.07, 0.74),
                              child: Text(
                                'Mr.DeliveryMan',
                                style: TextStyle(
                                  color: black,
                                  fontFamily: 'Roboto',
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                      Stack(
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Container(
                              width: double.infinity,
                              height: 814,
                              decoration: const BoxDecoration(
                                color: Color(0xFF212425),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0, 1.13),
                            child: Container(
                              width: double.infinity,
                              height: 374,
                              decoration: const BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                  topLeft: Radius.circular(120),
                                  topRight: Radius.circular(120),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(-0.14, -0.03),
                            child: Lottie.network(
                              'https://assets6.lottiefiles.com/packages/lf20_tll0j4bb.json',
                              width: 306,
                              height: 367,
                              fit: BoxFit.cover,
                              frameRate: FrameRate(60),
                              animate: true,
                            ),
                          ),
                          const Align(
                              alignment: AlignmentDirectional(-0.03, 0.69),
                              child: Text(
                                '1000+ Restaurants',
                                style: TextStyle(
                                  color: black,
                                  fontFamily: 'Roboto',
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          const Align(
                              alignment: AlignmentDirectional(-0.2, 0.53),
                              child: Text(
                                'Choose between',
                                style: TextStyle(
                                  color: black,
                                  fontFamily: 'Roboto',
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                        ],
                      ),
                      Stack(
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Container(
                              width: double.infinity,
                              height: 814,
                              decoration: const BoxDecoration(
                                color: Color(0xFF212425),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0, 1.13),
                            child: Container(
                              width: double.infinity,
                              height: 374,
                              decoration: const BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                  topLeft: Radius.circular(120),
                                  topRight: Radius.circular(120),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(-0.14, -0.03),
                            child: Lottie.network(
                              'https://assets9.lottiefiles.com/packages/lf20_57TxAX.json',
                              width: 306,
                              height: 367,
                              fit: BoxFit.cover,
                              frameRate: FrameRate(60),
                              animate: true,
                            ),
                          ),
                          const Align(
                              alignment: AlignmentDirectional(-0.03, 0.69),
                              child: Text(
                                '100000+ Products',
                                style: TextStyle(
                                  color: black,
                                  fontFamily: 'Roboto',
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          const Align(
                              alignment: AlignmentDirectional(-0.2, 0.53),
                              child: Text(
                                'SURF THROUGH',
                                style: TextStyle(
                                  color: black,
                                  fontFamily: 'Poppins',
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                      Stack(
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Container(
                              width: double.infinity,
                              height: 814,
                              decoration: const BoxDecoration(
                                color: Color(0xFF212425),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0, 1.13),
                            child: Container(
                              width: double.infinity,
                              height: 374,
                              decoration: const BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                  topLeft: Radius.circular(120),
                                  topRight: Radius.circular(120),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(-0.14, -0.03),
                            child: Lottie.network(
                              'https://assets5.lottiefiles.com/packages/lf20_xlmz9xwm.json',
                              width: 306,
                              height: 367,
                              fit: BoxFit.cover,
                              frameRate: FrameRate(60),
                              animate: true,
                            ),
                          ),
                          const Align(
                              alignment: AlignmentDirectional(-0.02, 0.56),
                              child: Text(
                                'Let\'s get started',
                                style: TextStyle(
                                  color: black,
                                  fontFamily: 'Roboto',
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          const Align(
                              alignment: AlignmentDirectional(0.14, -0.81),
                              child: Text(
                                'ALL-IN ONE APP',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          Align(
                            alignment: AlignmentDirectional(-0.79, 0.82),
                            child: CustomButton(
                                onTap: () {
                                  Get.toNamed(RouteHelper.auth);
                                },
                                text: "Sign Up",
                                width: 140,
                                height: 51,
                                color: backGround,
                                color2: white,
                                textSize: 20),
                          ),
                          const Align(
                            alignment: AlignmentDirectional(0.7, 0.81),
                            child: CustomButton(
                                text: "Log In",
                                width: 140,
                                height: 51,
                                color: backGround,
                                color2: white,
                                textSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
                    child: smooth_page_indicator.SmoothPageIndicator(
                      controller: pageViewController,
                      count: 4,
                      axisDirection: Axis.horizontal,
                      onDotClicked: (i) async {
                        await pageViewController.animateToPage(
                          i,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      effect: smooth_page_indicator.ExpandingDotsEffect(
                        expansionFactor: 3,
                        spacing: 8,
                        radius: 16,
                        dotWidth: 16,
                        dotHeight: 8,
                        dotColor: lightGrey!,
                        activeDotColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        paintStyle: PaintingStyle.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
