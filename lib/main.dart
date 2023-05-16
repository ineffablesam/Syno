import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toasta/toasta.dart';

import 'core/home/home_page.dart';
import 'core/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: "https://sxfxnzlzybpezhehacby.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN4Znhuemx6eWJwZXpoZWhhY2J5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODQwNzAxMjgsImV4cCI6MTk5OTY0NjEyOH0.lvpL6ZgIZehai1gdukqWSDh9wbmUlPf84FklCM1zGmk",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ToastaContainer(
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                    transitionType: SharedAxisTransitionType.horizontal,
                    fillColor: Color(0xff1b1b1b),
                  ),
                },
              ),
            ),
            routes: {
              '/': (context) => const SplashPage(),
              '/home': (context) => HomePage(),
            },
          );
        },
      ),
    );
  }
}
