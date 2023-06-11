import 'package:delivery_man/constants/color.dart';
import 'package:delivery_man/constants/height_spacer.dart';
import 'package:delivery_man/constants/textstyle.dart';
import 'package:delivery_man/constants/width_spacer.dart';

import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeightSpacer(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Favourite Orders",
                style: appstyle(white, 24, FontWeight.normal),
              ),
            ),
            const HeightSpacer(height: 20),
            SizedBox(
              height: 1000,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: white,
                          border: Border.all(color: black, width: 1)),
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 30),
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Image.network(
                                    "https://cdn.wallpapersafari.com/34/46/W6l4nL.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const WidthSpacer(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Balaram Mallick Sweets",
                                      style:
                                          appstyle(black, 16, FontWeight.bold),
                                    ),
                                    Text(
                                      "Kaikhali ,Kolkata",
                                      style: appstyle(
                                          black, 12, FontWeight.normal),
                                    )
                                  ],
                                ),
                                const WidthSpacer(width: 30),
                                Text(
                                  "\$53.11",
                                  style: appstyle(black, 20, FontWeight.bold),
                                ),
                              ],
                            ),
                            const HeightSpacer(height: 10),
                            const Divider(
                              thickness: 2,
                            ),
                            const HeightSpacer(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "ITEMS",
                                  style:
                                      appstyle(lightGrey!, 14, FontWeight.w700),
                                ),
                                const HeightSpacer(height: 5),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          '1 X Mud Pie[500 grms]',
                                          style: appstyle(
                                              black, 12, FontWeight.w200),
                                        ),
                                      );
                                    }),
                                const HeightSpacer(height: 5),
                                Text(
                                  "ORDERED ON",
                                  style:
                                      appstyle(lightGrey!, 14, FontWeight.w700),
                                ),
                                const HeightSpacer(height: 5),
                                Text(
                                  '5 Jan 2023 at 6:18 pm',
                                  style: appstyle(black, 12, FontWeight.w200),
                                )
                              ],
                            ),
                            const HeightSpacer(height: 10),
                            const Divider(
                              thickness: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Delivered",
                                  style: appstyle(black, 12, FontWeight.w200),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: black)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Repeat Order",
                                        style: appstyle(
                                            backGround, 16, FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
