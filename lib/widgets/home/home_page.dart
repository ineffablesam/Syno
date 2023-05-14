import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syno/helpers/custom_tap.dart';

import '../../helpers/thumbnail_helper.dart';
import '../components/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _controller;
  TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _title = '';
  String? _summary = '';
  String? _introduction = '';
  List<String>? _bulletPoints = [];
  String? _conclusion = '';
  String _thumbnailUrl = '';
  bool _componentsvisible = false;
  Future<void> _getSummary() async {
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
            physics: const BouncingScrollPhysics(),
            slivers: [
              const CustomAppBar(),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: _isLoading
                        ? Lottie.asset(
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
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                child: TextField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: _urlController,
                                  decoration: InputDecoration(
                                    hintText: 'Paste Link to Summarise',
                                    suffixIconConstraints: BoxConstraints(
                                      maxHeight: 70.h,
                                    ),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(right: 12.w),
                                      child: CircleAvatar(
                                        backgroundColor: const Color(0xff2e2e2e)
                                            .withOpacity(0.4),
                                        radius: 13.h,
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white60,
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
                                        _controller.addStatusListener((status) {
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
                                    fillColor: const Color(0xdffffff),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.r),
                                      borderSide: const BorderSide(
                                          width: 1, color: Color(0xff2e2e2e)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.r),
                                      borderSide: const BorderSide(
                                          width: 1, color: Color(0xff9263E9)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomTap(
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
                                            color: const Color(0xff2e2e2e))),
                                    child: ElevatedButton(
                                      onPressed: _getSummary,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                            0xff2f2f2f33), // Background color
                                      ),
                                      child: const Text('Get Summary'),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (_componentsvisible)
                                Column(
                                  children: [
                                    _thumbnailUrl != null
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              child: Container(
                                                  child: Image.network(
                                                      _thumbnailUrl)),
                                            ),
                                          )
                                        : Container(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Title: $_title'.substring(7),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
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
                                ),
                            ],
                          ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
