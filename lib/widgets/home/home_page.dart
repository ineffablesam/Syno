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

import '../../helpers/thumbnail_helper.dart';
import '../components/animated_text.dart';
import '../components/custom_app_bar.dart';

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

    if (response.data != null && response.data!.isNotEmpty) {
      print("Found in DB");
      final summaryData = jsonDecode(response.data![0]['summary'] as String);
      final thumbnailUrl = await getYoutubeThumbnail(_urlController.text);
      setState(() {
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
    const url = 'http://10.0.2.2:8000/summary/';
    final body = json.encode({'youtube_link': _urlController.text.trim()});
    final headers = {'Content-type': 'application/json'};
    final uri = Uri.parse(url);
    final apiResponse = await http.post(uri, headers: headers, body: body);
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
      print(clipboardText);
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
                              children: [
                                Lottie.asset(
                                  'assets/lottie/loader.json',
                                  controller: _controller,
                                  height: 100.h,
                                  onLoaded: (composition) {
                                    _controller
                                      ..duration = composition.duration
                                      ..forward();
                                    _controller.addStatusListener((status) {
                                      if (status == AnimationStatus.completed) {
                                        _controller
                                          ..reset()
                                          ..forward();
                                      }
                                    });
                                  },
                                ),
                                AnimatedTextList(),
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
                                                    color: Color(0xff2e2e2e)
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
                                      borderRadius: BorderRadius.circular(8.r),
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
                                              _getSummary();
                                            } else {
                                              final toast = Toast(
                                                  status: ToastStatus.failed,
                                                  subtitle:
                                                      "Please Enter Valid link");
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
                                  Column(
                                    children: [
                                      _thumbnailUrl != null
                                          ? CustomTap(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 7.h,
                                                    horizontal: 13.h),
                                                child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                                Offset(3, 3),
                                                            spreadRadius: -13,
                                                            blurRadius: 50,
                                                            color:
                                                                Color.fromRGBO(
                                                                    146,
                                                                    99,
                                                                    233,
                                                                    0.45),
                                                          )
                                                        ]),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r),
                                                      child: Image.network(
                                                          _thumbnailUrl),
                                                    )),
                                              ),
                                            )
                                          : Container(),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Time Taken: $_elapsedTimeText',
                                              style: TextStyle(
                                                  fontFamily: "Gilroy",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13.sp,
                                                  color:
                                                      const Color(0xff565656)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Title: $_title'.substring(7),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 19.sp,
                                              color: const Color(0xfffbfbfb)),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Summary: $_summary'.substring(8),
                                          style: const TextStyle(
                                              color: Color(0xc3ffffff)),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: EdgeInsets.all(10.h),
                                        child:
                                            Text('Introduction: $_introduction',
                                                style: const TextStyle(
                                                  color: Color(0xc3ffffff),
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
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: _bulletPoints?.length,
                                            itemBuilder: (context, index) {
                                              // Use ListTile widgets to display each bullet point as a separate item in the list
                                              return ListTile(
                                                leading: const Icon(
                                                  Icons.arrow_right,
                                                  color: Color(0xff9263E9),
                                                ), // Use a bullet point icon
                                                title: Text(
                                                  _bulletPoints![index],
                                                  style: const TextStyle(
                                                      color: Color(0xc3ffffff)),
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
                                  )
                                else
                                  FadeInUp(child: const _buildBaseSheet())
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

class _buildBaseSheet extends StatelessWidget {
  const _buildBaseSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.h,
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
