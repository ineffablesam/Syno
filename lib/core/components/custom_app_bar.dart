import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Color(0xff0b0b0d),
      automaticallyImplyLeading: false,
      forceElevated: true,
      floating: true,
      pinned: true,
      elevation: 0,
      collapsedHeight: 10.h,
      toolbarHeight: 9.h,
      scrolledUnderElevation: 3,
      stretch: true,
      centerTitle: false,
      expandedHeight: 140.h,
      // title:
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 13.w),
          child: FadeIn(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Container(
                    //   height: 50.h,
                    //   clipBehavior: Clip.hardEdge,
                    //   decoration: BoxDecoration(shape: BoxShape.circle),
                    //   child: Image.asset(
                    //     "assets/images/profile.webp",
                    //   ),
                    // ),
                    SvgPicture.asset(
                      'assets/images/logo_main.svg',
                      height: 30.h,
                      width: 30.h,
                    ),
                    Icon(
                      Icons.apps,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Syno",
                  style: TextStyle(
                      fontFamily: "Gilroy",
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 24.sp),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Shortening Videos, Expanding Knowledge",
                  style: TextStyle(
                      fontFamily: "Gilroy",
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                      fontSize: 16.sp),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
