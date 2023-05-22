import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:typewritertext/typewritertext.dart';

class GeneratedContentView extends StatelessWidget {
  GeneratedContentView({
    super.key,
    required String thumbnailUrl,
    required String elapsedTimeText,
    required String? title,
    required String? summary,
    required String? introduction,
    required List<String>? bulletPoints,
    required String? conclusion,
    required String duration,
  })  : _thumbnailUrl = thumbnailUrl,
        _elapsedTimeText = elapsedTimeText,
        _title = title,
        _summary = summary,
        _introduction = introduction,
        _bulletPoints = bulletPoints,
        _conclusion = conclusion,
        _duration = duration;

  final String _thumbnailUrl;
  final String _elapsedTimeText;
  final String? _title;
  final String? _summary;
  final String? _introduction;
  final List<String>? _bulletPoints;
  final String? _conclusion;
  final String _duration;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics:
          kIsWeb ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
      child: Column(
        children: [
          _thumbnailUrl != null
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 7.h, horizontal: 13.h),
                  child: Container(
                      decoration: BoxDecoration(
                          boxShadow: const [
                            // BoxShadow(
                            //   offset: Offset(3, 3),
                            //   spreadRadius: -13,
                            //   blurRadius: 50,
                            //   color: Color.fromRGBO(146, 99, 233, 0.45),
                            // )
                          ],
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: const Color(0xff2e2e2e))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        // child:
                        child: kIsWeb
                            ? MyImage(
                                url: _thumbnailUrl,
                              )
                            : Image.network(_thumbnailUrl),
                      )),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Time Taken: ',
                      style: TextStyle(
                          fontFamily: "Gilroy",
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                          color: const Color(0xff565656)),
                    ),
                    Text(
                      _elapsedTimeText,
                      style: TextStyle(
                          fontFamily: "Gilroy",
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                          color: const Color(0xffe5e5e5)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time_rounded,
                        color: Color(0xff565656)),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      _duration,
                      style: TextStyle(
                          fontFamily: "Gilroy",
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                          color: const Color(0xffe5e5e5)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TypeWriterText(
              duration: Duration(milliseconds: 30),
              text: Text(
                'Title: $_title'.substring(7),
                style: GoogleFonts.ibmPlexSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 19.sp,
                    color: const Color(0xfffbfbfb)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Summary: $_summary'.substring(8),
              style: GoogleFonts.ibmPlexSans(color: const Color(0xc3ffffff)),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(10.h),
            child: Text('Introduction: $_introduction',
                style: GoogleFonts.ibmPlexSans(
                  color: const Color(0xc3ffffff),
                )),
          ),
          const SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10.h),
            color: const Color(0xdffffff),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _bulletPoints?.length,
                itemBuilder: (context, index) {
                  // Use ListTile widgets to display each bullet point as a separate item in the list
                  return ListTile(
                    leading: Text(
                      "${index + 1}.",
                      style: GoogleFonts.ibmPlexSans(
                          color: const Color(0xc3ffffff),
                          fontWeight: FontWeight.w600),
                    ),
                    title: Text(
                      _bulletPoints![index],
                      style: GoogleFonts.ibmPlexSans(
                          color: const Color(0xc3ffffff)),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Conclusion: $_conclusion',
          ),
        ],
      ),
    );
  }
}

class MyImage extends StatelessWidget {
  const MyImage({
    super.key,
    required this.url,
  });

  final String url;
  @override
  Widget build(BuildContext context) {
    String imageUrl = url;
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      imageUrl,
      (int _) => ImageElement()..src = imageUrl,
    );
    return Container(
      height: 600.h,
      width: 1080.h,
      child: HtmlElementView(
        viewType: imageUrl,
      ),
    );
  }
}
