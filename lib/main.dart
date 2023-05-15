import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syno/widgets/home/home_page.dart';
import 'package:syno/widgets/splash/splash_page.dart';
import 'package:toasta/toasta.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://sxfxnzlzybpezhehacby.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN4Znhuemx6eWJwZXpoZWhhY2J5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODQwNzAxMjgsImV4cCI6MTk5OTY0NjEyOH0.lvpL6ZgIZehai1gdukqWSDh9wbmUlPf84FklCM1zGmk",
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
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
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                    transitionType: SharedAxisTransitionType.horizontal,
                    fillColor: Color(0xff1b1b1b),
                  ),
                },
              ),
            ),
            routes: {
              '/': (context) => SplashPage(),
              '/home': (context) => HomePage(),
            },
          );
        },
      ),
    );
  }
}
