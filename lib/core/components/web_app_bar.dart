import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/custom_tap.dart';

class WebCustomAppBar extends StatefulWidget {
  const WebCustomAppBar({
    super.key,
  });

  @override
  State<WebCustomAppBar> createState() => _WebCustomAppBarState();
}

class _WebCustomAppBarState extends State<WebCustomAppBar> {
  bool isHovered = false;
  bool isEHovered = false;
  void showAboutDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      pageBuilder: (_, __, ___) {
        return Material(
          type: MaterialType.transparency,
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(30.h),
              width: 900.h,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: const Color(0xff101010),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xff2e2e2e))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Developer",
                    style: GoogleFonts.ibmPlexSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 23.sp),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CircleAvatar(
                    radius: 170.r,
                    backgroundColor: const Color(0xff2e2e2e).withOpacity(0.3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200.r),
                      child: Image.asset(
                        "assets/images/sam.jpg",
                        height: 270.h,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Samuel Philip",
                    style: GoogleFonts.ibmPlexMono(
                        color: Colors.white,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "🔮 The Multiverse Coder 🌍 | Laravel 🚀, Node.js 🌟, Flutter 🦋 | Linux 🐧, Databases 📚 | JS 🚀 || I'm the person who wastes my time just to save yours! 🫣😬",
                    style: GoogleFonts.ibmPlexMono(
                        color: Colors.white, fontSize: 14.sp),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTap(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 14.w),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xff2e2e2e)),
                                color: const Color(0xff2e2e2e).withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Text(
                              "Dismiss",
                              style: GoogleFonts.ibmPlexMono(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.sp),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color(0xff0b0b0d),
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
      expandedHeight: 120.h,
      // title:
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 13.w),
          child: FadeIn(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30.h,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTap(
                      onTap: () {
                        _launchURLGithub();
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) {
                          setState(() {
                            isEHovered =
                                true; // Set the hover state to true when the mouse enters the button
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            isEHovered =
                                false; // Set the hover state to false when the mouse exits the button
                          });
                        },
                        child: Padding(
                            padding: EdgeInsets.only(right: 10.h),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 150.h,
                              height: 40.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: isEHovered
                                    ? Border.all(color: const Color(0xff2e2e2e))
                                    : Border.all(width: 0),
                                color: isEHovered
                                    ? const Color(0xff2e2e2e).withOpacity(0.4)
                                    : const Color(0xff2e2e2e).withOpacity(
                                        0), // Animate the background color
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                "Github",
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19.sp),
                              ),
                            )),
                      ),
                    ),
                    CustomTap(
                      onTap: () {
                        showAboutDialog(context);
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) {
                          setState(() {
                            isHovered = true;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            isHovered = false;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 150.h,
                            height: 40.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: isHovered
                                  ? Border.all(color: const Color(0xff2e2e2e))
                                  : Border.all(width: 0),
                              color: isHovered
                                  ? const Color(0xff2e2e2e).withOpacity(0.4)
                                  : const Color(0xff2e2e2e).withOpacity(
                                      0), // Animate the background color
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              "About",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 19.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_launchURLGithub() async {
  final Uri url = Uri.parse('https://github.com/ineffablesam/Syno');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
