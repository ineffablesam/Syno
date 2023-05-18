import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AnimatedLoadingState extends StatefulWidget {
  const AnimatedLoadingState({super.key});

  @override
  _AnimatedLoadingStateState createState() => _AnimatedLoadingStateState();
}

class _AnimatedLoadingStateState extends State<AnimatedLoadingState>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final snackBar = SnackBar(
  //     padding: EdgeInsets.zero,
  //     margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 13.h),
  //     dismissDirection: DismissDirection.none,
  //     duration: Duration(days: 365),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
  //     content: SnackBarContent(),
  //     behavior: SnackBarBehavior.floating,
  //   );
  //   WidgetsBinding.instance!.addPostFrameCallback((_) {
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   });
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 13.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Shimmer(
                  child: Container(
                    height: 150.h,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          // BoxShadow(
                          //   offset: Offset(3, 3),
                          //   spreadRadius: -13,
                          //   blurRadius: 50,
                          //   color: Color.fromRGBO(146, 99, 233, 0.45),
                          // )
                        ],
                        color: Color(0x9d171717),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xff2e2e2e))),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 13.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Shimmer(
                  child: Container(
                    height: 30.h,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          // BoxShadow(
                          //   offset: Offset(3, 3),
                          //   spreadRadius: -13,
                          //   blurRadius: 50,
                          //   color: Color.fromRGBO(146, 99, 233, 0.45),
                          // )
                        ],
                        color: Color(0x9d171717),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xff2e2e2e))),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 13.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Shimmer(
                  child: Container(
                    height: 230.h,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          // BoxShadow(
                          //   offset: Offset(3, 3),
                          //   spreadRadius: -13,
                          //   blurRadius: 50,
                          //   color: Color.fromRGBO(146, 99, 233, 0.45),
                          // )
                        ],
                        color: Color(0x9d171717),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xff2e2e2e))),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 13.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Shimmer(
                  child: Container(
                    height: 230.h,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          // BoxShadow(
                          //   offset: Offset(3, 3),
                          //   spreadRadius: -13,
                          //   blurRadius: 50,
                          //   color: Color.fromRGBO(146, 99, 233, 0.45),
                          // )
                        ],
                        color: Color(0x9d171717),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xff2e2e2e))),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Center(
        //   child: Lottie.asset(
        //     'assets/lottie/loader.json',
        //     controller: _controller,
        //     height: 100.h,
        //     onLoaded: (composition) {
        //       _controller
        //         ..duration = composition.duration
        //         ..forward();
        //       _controller.addStatusListener((status) {
        //         if (status == AnimationStatus.completed) {
        //           _controller
        //             ..reset()
        //             ..forward();
        //         }
        //       });
        //     },
        //   ),
        // ),
      ],
    );
  }
}

class SnackBarContent extends StatelessWidget {
  const SnackBarContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 70.h,
          width: 90.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                bottomLeft: Radius.circular(8.r)),
            color: Colors.white60,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title Title Title Title",
              style: GoogleFonts.ibmPlexSans(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
            Text(
              "Description",
              style: GoogleFonts.ibmPlexSans(
                  color: Colors.grey.shade700, fontWeight: FontWeight.w400),
            )
          ],
        )
      ],
    );
  }
}
