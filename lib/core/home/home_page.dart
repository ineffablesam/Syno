import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syno/helpers/custom_tap.dart';
import 'package:toasta/toasta.dart';

import '../../app/constants/constants.dart';
import '../../helpers/duration_parsers.dart';
import '../../helpers/thumbnail_helper.dart';
import '../components/CustomBottomSheet.dart';
import '../components/animated_loading_state.dart';
import '../components/custom_app_bar.dart';
import '../components/generated_content_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late Timer _timer;
  int _elapsedSeconds = 0;
  late final AnimationController _controller;
  String _elapsedTimeText = "";
  TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initDeepLinks();
    _urlController.addListener(_onTextChanged);
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _urlController.dispose();
    _linkSubscription?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isTextFieldEmpty = _urlController.text.isEmpty;
    });
  }

  bool _isTextFieldEmpty = true;

  String? _title = '';
  String? _summary = '';
  String? _introduction = '';
  List<String>? _bulletPoints = [];
  String? _conclusion = '';
  String _thumbnailUrl = '';
  bool _componentsvisible = false;
  String _duration = "";
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();
    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      print('onAppLink: $uri');
      setState(() {
        _urlController.text = uri.toString().trim();
        print("printed");
      });
      final toast = Toast(
          status: ToastStatus.success,
          title: "Success",
          subtitle: "Pasted from Youtube");
      Toasta(context).toast(toast);
    });
  }

  void showDurationErrorDialog(BuildContext context) {
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
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: const Color(0xff101010),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xff2e2e2e))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "🕒 Duration Exceeded",
                    style: GoogleFonts.ibmPlexSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 23.sp),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text.rich(
                    TextSpan(
                      text:
                          "Syno restricts the acceptance of videos exceeding a duration of ",
                      style: GoogleFonts.ibmPlexMono(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                      children: [
                        TextSpan(
                          text: "10 minutes",
                          style: GoogleFonts.ibmPlexMono(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                        const TextSpan(
                          text:
                              " solely for free accounts. As part of our service offering, free account holders are limited to summarise videos that adhere to a maximum duration of 10 minutes.",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
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

  Future<void> _getSummary() async {
    _startTimer();
    setState(() {
      _isLoading = true;
    });

    final supabase = Supabase.instance.client;
    // Check if the video summary is already in the database
    final response = await supabase
        .from('syno_main')
        .select('summary, youtube_url')
        .eq('youtube_url', _urlController.text.trim())
        .execute();
    String duration =
        await getVideoDurationFromUrl(_urlController.text.trim(), YT_API_KEY);

    final durationParts = duration.split(':');
    if (durationParts.length >= 2) {
      final minutes = int.tryParse(durationParts[1]);
      if (minutes != null && minutes >= 10) {
        print('Error: Video duration is greater than or equal to 10 minutes');
        showDurationErrorDialog(context);
        setState(() {
          _isLoading = false;
        });
        return;
      }
    } else {
      print('Error: Invalid duration format');
      setState(() {
        _isLoading = false;
      });

      return;
    }
    if (response.data != null && response.data!.isNotEmpty) {
      print("Found in DB");
      String duration =
          await getVideoDurationFromUrl(_urlController.text.trim(), YT_API_KEY);

      final summaryData = jsonDecode(response.data![0]['summary'] as String);
      final thumbnailUrl = await getYoutubeThumbnail(_urlController.text);
      setState(() {
        _duration = duration;
        _title = summaryData['title'];
        _summary = summaryData['summary'];
        _introduction = summaryData['introduction'];
        _bulletPoints = summaryData['bullet points'] != null
            ? List<String>.from(summaryData['bullet points'])
            : null;
        _conclusion = summaryData['conclusion'];
        _thumbnailUrl = thumbnailUrl;
        _componentsvisible = true;
        _isLoading = false;
        _timer.cancel();
      });
      _timer.cancel(); // Stop the timer
      setState(() {
        final minutes = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
        final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');
        _elapsedTimeText = '$minutes:$seconds';
      });
      return;
    }

    // If not in the database, fetch the summary from the API and store it in the database
    print("Not in Db so fetching from Server");
    final body = json.encode({'youtube_link': _urlController.text.trim()});
    final headers = {'Content-type': 'application/json'};
    final uri = Uri.parse(MAIN_BACKEND_URL_DEBUG);
    final apiResponse = await http.post(uri, headers: headers, body: body);
    print(apiResponse.body);
    final summaryString = json.decode(apiResponse.body)['summary'];
    final summaryData = json.decode(summaryString);
    final thumbnailUrl = await getYoutubeThumbnail(_urlController.text);

    final supabaseResponse = await supabase.from('syno_main').insert({
      'user_id': supabase.auth.currentUser?.id,
      'youtube_url': _urlController.text.trim(),
      'summary': summaryString,
      'thumbnail_url': thumbnailUrl,
    }).execute();

    setState(() {
      _duration = duration;
      _title = summaryData['title'];
      _summary = summaryData['summary'];
      _introduction = summaryData['introduction'];
      _bulletPoints = summaryData['bullet points'] != null
          ? List<String>.from(summaryData['bullet points'])
          : null;
      _conclusion = summaryData['conclusion'];
      _thumbnailUrl = thumbnailUrl;
      _componentsvisible = true;
      _isLoading = false;
      _timer.cancel();
    });
    _timer.cancel(); // Stop the timer
    setState(() {
      final minutes = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');
      _elapsedTimeText = '$minutes:$seconds';
    });
  }

  void _getClipboardText() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? clipboardText = clipboardData?.text;
    setState(() {
      _urlController.text = clipboardText ?? "No Text in Clipboard";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          backgroundColor: const Color(0xff0b0b0d),
          body: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              const CustomAppBar(),
              SliverFillRemaining(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: Center(
                      child: _isLoading
                          ? Column(
                              children: const [
                                AnimatedLoadingState(),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  decoration: const BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      offset: Offset(3, 3),
                                      spreadRadius: -13,
                                      blurRadius: 50,
                                      color: Color.fromRGBO(146, 99, 233, 0.45),
                                    )
                                  ]),
                                  child: TextField(
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w200,
                                        color: Colors.white),
                                    controller: _urlController,
                                    decoration: InputDecoration(
                                      hintText: 'Paste Link to Summarise',
                                      suffixIconConstraints: BoxConstraints(
                                        maxHeight: 70.h,
                                      ),
                                      suffixIcon: Visibility(
                                        visible: !_isTextFieldEmpty,
                                        //Paste Button for pasting the text from Clipboard
                                        replacement: CustomTap(
                                          onTap: () {
                                            _getClipboardText();
                                          },
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 12.w),
                                              child: Container(
                                                width: 70.w,
                                                height: 30.h,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xff2e2e2e)),
                                                    color:
                                                        const Color(0xff2e2e2e)
                                                            .withOpacity(0.4),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r)),
                                                child: Text(
                                                  "Paste",
                                                  style: GoogleFonts.poppins(
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              )),
                                        ),
                                        //Clear Button for clearing text field
                                        child: CustomTap(
                                          onTap: () {
                                            _urlController.clear();
                                            setState(() {
                                              _componentsvisible = false;
                                            });
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 12.w),
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  const Color(0xff2e2e2e)
                                                      .withOpacity(0.4),
                                              radius: 13.h,
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white60,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      hintStyle: const TextStyle(
                                          color: Color(0xffbcb9b9)),
                                      prefixIcon: Lottie.asset(
                                        'assets/lottie/Link.json',
                                        controller: _controller,
                                        height: 10.h,
                                        onLoaded: (composition) {
                                          _controller
                                            ..duration = composition.duration
                                            ..forward();
                                          _controller
                                              .addStatusListener((status) {
                                            if (status ==
                                                AnimationStatus.completed) {
                                              _controller
                                                ..reset()
                                                ..forward();
                                            }
                                          });
                                        },
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xD3181818),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.r),
                                        borderSide: const BorderSide(
                                            width: 1, color: Color(0xff2e2e2e)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.r),
                                        borderSide: const BorderSide(
                                            width: 1, color: Color(0xff9263E9)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (_urlController.text.trim().isNotEmpty)
                                  Shimmer(
                                    duration: const Duration(
                                        seconds: 3), //Default value
                                    interval: const Duration(
                                        seconds:
                                            2), //Default value: Duration(seconds: 0)
                                    color: Colors.white, //Default value
                                    colorOpacity: 0, //Default value
                                    enabled: true, //Default value
                                    direction: const ShimmerDirection
                                        .fromLTRB(), //Default Valuelue
                                    child: CustomTap(
                                      onTap: null,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        child: Container(
                                          height: 45.h,
                                          width: 200.w,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xff2e2e2e))),
                                          child: ElevatedButton(
                                            // onPressed: _getSummary,
                                            onPressed: () {
                                              String inputText =
                                                  _urlController.text.trim();
                                              if (inputText.isNotEmpty) {
                                                if (inputText.startsWith(
                                                        'https://www.youtube.com/watch?v=') ||
                                                    inputText.startsWith(
                                                        'https://youtu.be/')) {
                                                  _getSummary();
                                                } else {
                                                  final toast = Toast(
                                                    status: ToastStatus.failed,
                                                    subtitle:
                                                        "Please enter a valid YouTube link",
                                                  );
                                                  Toasta(context).toast(toast);
                                                }
                                              } else {
                                                final toast = Toast(
                                                  status: ToastStatus.failed,
                                                  subtitle:
                                                      "Please enter a valid link",
                                                );
                                                Toasta(context).toast(toast);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                  0xff2f2f2f33), // Background color
                                            ),
                                            child: const Text('Get Summary ✨'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 20),
                                if (_componentsvisible)
                                  GeneratedContentView(
                                    thumbnailUrl: _thumbnailUrl,
                                    elapsedTimeText: _elapsedTimeText,
                                    title: _title,
                                    summary: _summary,
                                    introduction: _introduction,
                                    bulletPoints: _bulletPoints,
                                    conclusion: _conclusion,
                                    duration: _duration,
                                  )
                                else
                                  FadeInUp(child: const BuildBaseSheet())
                              ],
                            ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
