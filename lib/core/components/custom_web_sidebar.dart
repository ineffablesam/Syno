import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class WebSideBar extends StatefulWidget {
  const WebSideBar({
    super.key,
  });

  @override
  State<WebSideBar> createState() => _WebSideBarState();
}

class _WebSideBarState extends State<WebSideBar> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 90.h,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(width: 2.0, color: Color(0xff2e2e2e)),
        ),
        color: Color(0xff1b1b1b),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              MouseRegion(
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 60.h,
                  height: 50.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: isHovered
                        ? Border.all(color: const Color(0xff2e2e2e))
                        : Border.all(width: 0, color: const Color(0x2e2e2e)),
                    color: isHovered
                        ? const Color(0xff2e2e2e).withOpacity(0.4)
                        : const Color(0xff2e2e2e)
                            .withOpacity(0), // Animate the background color
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: SvgPicture.asset(
                    'assets/images/logo_main.svg',
                    height: 30.h,
                    width: 30.h,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                  width: 20.h,
                  child: Image.asset("assets/images/supabase-logo-icon.png")),
              SizedBox(
                height: 10.h,
              ),
              FlutterLogo(
                style: FlutterLogoStyle.markOnly,
              ),
              SizedBox(
                height: 10.h,
              )
            ],
          ),
        ],
      ),
    );
  }
}
