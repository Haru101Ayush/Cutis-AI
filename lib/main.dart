import 'package:cutis_ai/DashBoard%20Data/DashBoard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Splash_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375,812),
      builder: (_, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CUTIS-AI',
        themeMode: ThemeMode.system,
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
            seedColor: PrimaryColor,
          ).copyWith(
            primary: PrimaryColor,
            onPrimary: OnPrimaryColor,
            secondary: SecondaryColor,
            onSecondary: OnSecondaryColor,
            surface: SurfaceColor,
            onSurface: OnSurfaceColor,
            background: BackgroundColor,
            onBackground: OnBackgroundColor,
            error: ErrorColor,
            onError: OnErrorColor,
          ),
        ),
        darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
            seedColor: PrimaryColor,
          ).copyWith(
            primary: PrimaryColor,
            onPrimary: OnPrimaryColor,
            secondary: SecondaryColor,
            onSecondary: OnSecondaryColor,
            surface: DarkSurfaceColor,
            onSurface: OnDarkSurfaceColor,
            background: DarkBackgroundColor,
            onBackground: OnDarkBackgroundColor,
            error: ErrorColor,
            onError: OnErrorColor,
          ),
        ),
        home: Dashboard(),
      ),
    );
  }
}

const PrimaryColor = Color.fromARGB(255, 7, 104, 79);
const OnPrimaryColor = Color.fromARGB(255, 255, 255, 255);
const SecondaryColor = Color.fromARGB(255, 0, 141, 105);
const OnSecondaryColor = Color.fromARGB(255, 3, 100, 76);
const SurfaceColor = Color.fromARGB(255, 255, 255, 255);
const OnSurfaceColor = Color.fromARGB(255, 7, 104, 79);
const BackgroundColor = Color.fromARGB(255, 247, 247, 247);
const OnBackgroundColor = Color.fromARGB(255, 7, 104, 79);
const ErrorColor = Color.fromARGB(255, 255, 24, 24);
const OnErrorColor = Color.fromARGB(255, 255, 255, 255);
const Textcolor = Color.fromARGB(255, 0, 0, 0);
const DarkSurfaceColor = Color.fromARGB(255, 0, 0, 0);
const OnDarkSurfaceColor = Color.fromARGB(255, 255, 255, 255);
const DarkBackgroundColor = Color.fromARGB(255, 24, 24, 24);
const OnDarkBackgroundColor = Color.fromARGB(255, 255, 255, 255);