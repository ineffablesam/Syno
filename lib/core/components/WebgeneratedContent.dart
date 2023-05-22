import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syno/helpers/custom_tap.dart';
import 'package:typewritertext/typewritertext.dart';
import 'package:url_launcher/url_launcher.dart';

class WebGeneratedContentView extends StatelessWidget {
  WebGeneratedContentView({
    super.key,
    required String thumbnailUrl,
    required String elapsedTimeText,
    required String? title,
    required String? summary,
    required String? introduction,
    required List<String>? bulletPoints,
    required String? conclusion,
    required String duration,
    required String videourl,
  })  : _thumbnailUrl = thumbnailUrl,
        _elapsedTimeText = elapsedTimeText,
        _title = title,
        _summary = summary,
        _introduction = introduction,
        _bulletPoints = bulletPoints,
        _conclusion = conclusion,
        _duration = duration,
        _videourl = videourl;

  final String _thumbnailUrl;
  final String _elapsedTimeText;
  final String? _title;
  final String? _summary;
  final String? _introduction;
  final List<String>? _bulletPoints;
  final String? _conclusion;
  final String _duration;
  final String _videourl;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _thumbnailUrl != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
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
                              border:
                                  Border.all(color: const Color(0xff2e2e2e))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            // child:
                            child: Image.network(_thumbnailUrl),
                          )),
                    ),
                    Container(
                      width: 300.h,
                      padding: EdgeInsets.all(10.h),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.8, color: const Color(0xff2e2e2e)),
                          color: const Color(0xff2f2f2f33),
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time Taken: ',
                            style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: const Color(0xff565656)),
                          ),
                          SizedBox(
                            width: 7.h,
                          ),
                          Text(
                            _elapsedTimeText,
                            style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                                color: const Color(0xffe5e5e5)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      width: 300.h,
                      padding: EdgeInsets.all(10.h),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.8, color: const Color(0xff2e2e2e)),
                          color: const Color(0xff2f2f2f33),
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Video Duration: ',
                            style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: const Color(0xff565656)),
                          ),
                          SizedBox(
                            width: 7.h,
                          ),
                          Text(
                            _duration,
                            style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                                color: const Color(0xffe5e5e5)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    CustomTap(
                      onTap: null,
                      child: Material(
                        borderRadius: BorderRadius.circular(10.r),
                        color: const Color(0xff9263E9),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.r),
                          onTap: () {
                            _launchURLGithub(_videourl);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Container(
                              width: 300.h,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10.h),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.8,
                                      color: const Color(0xff2e2e2e)),
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Text(
                                "View Video",
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : Container(),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TypeWriterText(
                    duration: const Duration(milliseconds: 30),
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
                    style:
                        GoogleFonts.ibmPlexSans(color: const Color(0xc3ffffff)),
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
                  margin: EdgeInsets.only(right: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: const Color(0xdffffff),
                  ),
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
          ),
        ],
      ),
    );
  }
}

_launchURLGithub(String t) async {
  final Uri url = Uri.parse(t);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
