import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';

import '../home/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                opaque: true,
                duration: const Duration(milliseconds: 800),
                child: HomePage(),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1b1b1b),
      body: Center(
        child: FadeInUp(
          child: Container(
            alignment: Alignment.center,
            height: 100.h,
            width: 100.h,
            decoration: BoxDecoration(boxShadow: [
              const BoxShadow(
                offset: Offset(0, 0),
                spreadRadius: 20,
                blurRadius: 59,
                color: Color.fromRGBO(182, 163, 238, 0.21),
              )
            ], color: Colors.white, borderRadius: BorderRadius.circular(19.r)),
            padding: EdgeInsets.all(10.h),
            child: SvgPicture.asset(
              "assets/images/logo_main.svg",
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
