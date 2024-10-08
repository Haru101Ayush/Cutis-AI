import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class Splash_screen extends StatefulWidget {
  const Splash_screen({super.key});

  @override
  State<Splash_screen> createState() => _Splash_screenState();
}

class _Splash_screenState extends State<Splash_screen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
              child: Padding(
            padding: EdgeInsets.only(bottom: 5), child: SizedBox(
                height: 230,
                width: 230,
                child: Image(image: AssetImage('lib/Assects/Ellipse 2.png'))),
          )),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Text('Cutis-AI',
                style: GoogleFonts.spaceMono(
                    textStyle: const TextStyle(
                  color: Color.fromARGB(255, 7, 104, 79),
                  letterSpacing: 15,
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                ))),
          )
        ],
      ),
    );
  }
}
