import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Color(0xff0b0b0d),
      automaticallyImplyLeading: false,
      toolbarHeight: 80.h,
      title: Padding(
        padding: EdgeInsets.symmetric(),
        child: FadeIn(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50.h,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Image.asset(
                  "assets/images/profile.webp",
                ),
              ),
              Icon(
                Icons.apps,
                color: Colors.white,
              )

              // Image.asset(
              //   "assets/images/Logo_white.png",
              //   height: 45.h,
              // )
            ],
          ),
        ),
      ),
      forceElevated: false,
      floating: false,
      elevation: 3,
      collapsedHeight: 82.h,
      scrolledUnderElevation: 9,
      stretch: true,
      centerTitle: false,
    );
  }
}
