import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/custom_tap.dart';

class BuildBaseSheet extends StatelessWidget {
  const BuildBaseSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 405.h,
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color(0xff2f2f2f33),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r))),
      child: RawScrollbar(
        radius: Radius.circular(10.r),
        thickness: 2.w,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: 5.h,
                width: 80.w,
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(10.r)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Super Charged with 🔥",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            CustomTap(
                              child: Image.asset(
                                "assets/images/supabase.png",
                                width: 100.w,
                              ),
                            ),
                            CustomTap(
                              child: Image.asset(
                                "assets/images/flutter-logo.png",
                                width: 100.w,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Quick Guide",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "1. Go to your desirable Youtube video",
                      style: GoogleFonts.poppins(
                          color: Colors.white70, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    const ImageGuide(image: "assets/images/step-1.png"),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "2. Click on Share button and Select Syno \n Let the Magic Happen ✨",
                      style: GoogleFonts.poppins(
                          color: Colors.white70, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    const ImageGuide(image: "assets/images/step-2.png"),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageGuide extends StatelessWidget {
  final String image;
  const ImageGuide({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(4.h),
        decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xff2e2e2e))),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.asset(image)));
  }
}
