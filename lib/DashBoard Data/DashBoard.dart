import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cutis_ai/Start Dignosis Data/Start_Diagnosis.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

bool valid = true;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Color scaffold_color = Color.fromARGB(255, 95, 103, 236);

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    active_page.add('Chat');
    scaffold_color = Color.fromARGB(255, 95, 103, 236);
    listenForPermissions();
    if (!_speechEnabled) {
      _initSpeech();
      validate();
    }
    super.initState();
  }

  List<String> active_page = [];
  final user_image = 'https://cdn-icons-png.flaticon.com/512/9131/9131529.png';
  final textcontroler = TextEditingController();

  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  String _recognizedText = "";

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = "";

  void listenForPermissions() async {
    final status = await Permission.microphone.status;
    switch (status) {
      case PermissionStatus.denied:
        requestForPermission();
        break;
      case PermissionStatus.granted:
        break;
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.provisional:
      // TODO: Handle this case.
    }
  }

  Future<void> requestForPermission() async {
    await Permission.microphone.request();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    _isListening = true;
    setState(() {});
    await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 30),
        localeId: "en_En",
        listenOptions: SpeechListenOptions(
          cancelOnError: false,
          partialResults: false,
          listenMode: ListenMode.dictation,
        ));
    setState(() {});
  }


  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    _isListening = false;
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(result) {
    print("Speech to text");
    // Get current text and selection information
    final currentText = textcontroler.value.text;
    final selection = textcontroler.selection;

    // Update text by appending the new text
    final newText = currentText + result.recognizedWords;

    // Update selection to be at the end of the new text
    final newSelection = selection.copyWith(
      baseOffset: newText.length,
      extentOffset: newText.length,
    );

    // Apply the changes to the controller
    textcontroler.value = textcontroler.value.copyWith(
      text: newText,
      selection: newSelection,);
    setState(() {
      _isListening = false;
    });
  }


  Future<bool> validate() async{
    return true;
  }

  Widget _buildAnimatedBar(bool active) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: active ? 50.w : 0,
      height: 4.0,
      color: Colors.white,
      margin: EdgeInsets.only(
        top: 3.h,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffold_color,
        surfaceTintColor: Colors.transparent,
        actions: [
          SizedBox(
            width: 8.w,
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 10.w),
            child: Text(
              'Aixtur AI',
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: 'ClashDisplay-Variable',
                fontWeight: FontWeight.normal,
                color: scaffold_color == Color.fromARGB(255, 251, 248, 252)
                    ? Color.fromARGB(255, 0, 8, 184)
                    : Colors.white,
              ),
            ),
          ),

          const Spacer(),

          GestureDetector(
            onTap: () {

            },
            child: Container(
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 144, 144),
                      Color.fromARGB(255, 17, 0, 218)
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12.w))),
              padding: EdgeInsets.all(2.w),
              child: Row(
                children: [
                  Text(
                    ' PRO ',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 13.sp),
                  ),
                ],
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: GestureDetector(
                onTap: () {

                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user_image),
                  radius: 18.r,
                ),
              )),
          SizedBox(
            width: 8.w,
          ),
        ],
      ),
      backgroundColor: scaffold_color,
      bottomSheet: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 112, 118, 238),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r))),
        width: double.infinity,
        padding:EdgeInsets.only(right: 10.w, left: 10.w, top: 13.h, bottom: 8.h),
        child: Column(
          mainAxisSize:MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.r),),
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.only(right: 5),
                    child: TextField(
                        controller: textcontroler,
                        keyboardType: TextInputType.text,
                        maxLength:200,
                        buildCounter: (context, {required currentLength, required isFocused, required maxLength}) {
                          return null;
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.h, horizontal: 5.w),
                            hintText:_isListening?"Listening...":"Ask Aixtur",
                            border: InputBorder.none,
                            // prefixIcon: GestureDetector(
                            //   child: SvgPicture.asset(
                            //     'lib/Assets/image/Attach file Bottom Icon.svg',
                            //   ),
                            //   onTap: () {
                            //     showModalBottomSheet(
                            //       backgroundColor: Colors.white,
                            //       context: context,
                            //       builder: (context) {
                            //         return file_handdle(context);
                            //       },
                            //     );
                            //   },
                            // ),
                            prefixIconConstraints:
                            BoxConstraints(minHeight: 30.h, minWidth: 30.w),
                            suffixIcon: GestureDetector(
                              onTap: _speechToText.isNotListening
                                  ? _startListening
                                  : _stopListening,
                              child: SizedBox(
                                height: 100,width: 100,
                              ),
                            ),
                            suffixIconConstraints: BoxConstraints(
                                maxHeight: _isListening?50.h:25.h, maxWidth: _isListening?50.w:25.w))),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    }
                    ,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 23.r,
                  ),
                ),
              ],
            ),
            SizedBox(height:10.h,),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30.w,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      scaffold_color = Color.fromARGB(255, 251, 248, 252);
                      active_page.clear();
                      active_page.add('Explorer');
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        Image(
                          image: const AssetImage(
                              'lib/Assets/png/element-4_360.png'),   //
                          color: Colors.white,
                          width: 32.w,
                          height: 32.h,
                        ),
                        Text(
                          'Explorer',
                          style:
                          TextStyle(color: Colors.white, fontSize: 10.sp),
                        ),
                        _buildAnimatedBar(active_page.contains('Explorer'))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      scaffold_color = Color.fromARGB(255, 95, 103, 236);
                      active_page.clear();
                      active_page.add('Chat');
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        Image(
                          image: const AssetImage(
                              'lib/Assets/png/messages_360.png'),
                          color: Colors.white,
                          width: 32.w,
                          height: 32.h,
                        ),
                        Text(
                          'Chat',
                          style:
                          TextStyle(color: Colors.white, fontSize: 10.sp),
                        ),
                        _buildAnimatedBar(active_page.contains('Chat'))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      scaffold_color = Color.fromARGB(255, 251, 248, 252);
                      active_page.clear();
                      active_page.add('History');
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        Image(
                          image: const AssetImage(
                              'lib/Assets/png/history_icon_360.png'),
                          color: Colors.white,
                          width: 32.w,
                          height: 32.h,
                        ),
                        Text(
                          'History',
                          style:
                          TextStyle(color: Colors.white, fontSize: 10.sp),
                        ),
                        _buildAnimatedBar(active_page.contains('History'))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}

class Scrll_chathistory extends StatelessWidget {
  const Scrll_chathistory({
    super.key,
    required this.user_image,
  });

  final user_image;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  // Scrr_appbar(user_image: user_image),
                  SizedBox(
                    height: 10.h,
                  ),
                  Center(
                    child: Text(
                      'Let’s talk about anything you want !',
                      style: GoogleFonts.dmSans(
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Stack(children: [
                  //   Container(
                  //     height: 138.h,
                  //     padding: EdgeInsets.fromLTRB(20.w, 20.h, 0.w, 0.h),
                  //     width: 370.w,
                  //     decoration: BoxDecoration(
                  //         gradient: const LinearGradient(
                  //           transform: GradientRotation(0.5 * pi),
                  //           colors: [
                  //             Color.fromARGB(255, 174, 179, 255),
                  //             Color.fromARGB(255, 17, 0, 218)
                  //           ],
                  //         ),
                  //         borderRadius: BorderRadius.all(Radius.circular(20.w)),
                  //         color: Colors.white),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: [
                  //         Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 'Premium Chat ',
                  //                 style: GoogleFonts.dmSans(
                  //                     fontSize: 16.sp,
                  //                     color: Colors.white,
                  //                     fontWeight: FontWeight.bold),
                  //               ),
                  //               SizedBox(
                  //                 height: 5.h,
                  //               ),
                  //               Text(
                  //                 'Unlock your chatbot & get all \npremium features',
                  //                 style: GoogleFonts.dmSans(
                  //                     fontSize: 12.sp,
                  //                     color: Colors.white,
                  //                     fontWeight: FontWeight.bold),
                  //               ),
                  //               SizedBox(
                  //                 height: 5.h,
                  //               ),
                  //               Container(
                  //                 height: 30.h,
                  //                 padding: EdgeInsets.all(5.w),
                  //                 width: 100.w,
                  //                 decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.all(
                  //                         Radius.circular(20.r))),
                  //                 child: Center(
                  //                   child: Text('Upgrade plan',
                  //                       style: GoogleFonts.dmSans(
                  //                           fontSize: 10.sp,
                  //                           color: Colors.black,
                  //                           fontWeight: FontWeight.bold)),
                  //                 ),
                  //               )
                  //             ]),
                  //       ],
                  //     ),
                  //   ),
                  //   Positioned(
                  //       left: 180.w,
                  //       bottom: 1.h,
                  //       top: -10.h,
                  //       child: const Image(
                  //           image: AssetImage('lib/Assets/image/robotmivi.png'),
                  //           width: 200,
                  //           height: 200)),
                  // ]),
                ]),
              ),
              // const Bootom_Sheet(),
              // Positioned(top: 100,
              //   child: Container(
              //     color: Color.fromARGB(255, 95, 103, 236),
              //     width: double.infinity,
              //     height: 100,
              //   ),
              // )
            ]),
          ],
        ),
      ]),
    );
  }
}

Column file_handdle(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              'Select Media Source',
              style: GoogleFonts.dmSans(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const Divider(color: Colors.grey, height: 2),
          ],
        ),
      ),
      GestureDetector(
        onTap: () {
          pickImage(context);
        },
        child: Attach_file(
            image_resource: 'lib/Assets/png/mask_group__6__720.png',
            text: 'Camera'),
      ),
      const Divider(color: Colors.grey, height: 2),
      GestureDetector(
        onTap: () {
          pickImage_from_gal(context);
        },
        child: Attach_file(
            image_resource: 'lib/Assets/png/mask_group__7__720.png',
            text: 'Photos'),
      ),
      const Divider(color: Colors.grey, height: 2),
      GestureDetector(
        onTap: () {
          pickFile(context);
        },
        child: Attach_file(
            image_resource: 'lib/Assets/png/mask_group__8__720.png',
            text: 'Files'),
      ),
      const Divider(color: Colors.grey, height: 2),
      Attach_file(
          image_resource: 'lib/Assets/png/mask_group__9__720.png',
          text: 'Web Link'),
    ],
  );
}

class Attach_file extends StatelessWidget {
  Attach_file({
    required this.text,
    required this.image_resource,
    super.key,
  });
  String text;
  String image_resource;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Leading icon
            Image(image: AssetImage(image_resource), width: 20.w, height: 20.h),
            const SizedBox(width: 16.0),
            // Text content
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> pickFile(ctx) async {
  final stor = Permission.storage.request();
  if (stor == PermissionStatus.granted) {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // Set to true for multiple selection
      type:
      FileType.any, // Choose file type or use FileType.image, .audio, etc.
    );

    if (result != null) {
      final path = result.files.single.path;
      if (path != null) {
        final file = File(path);
        // Process the selected file here
        print('Picked file: $file');
      } else {
        print('User cancelled file picking.');
      }
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Camera permission denied')),
      );
    }
  }
}

Future<XFile?> pickImage(context) async {
  try {
    // Check for camera and storage permissions
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
      status = await Permission.camera.status;
      if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission denied')),
        );
        return null;
      }
    }

    // Select image source (gallery or camera)
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    return pickedFile;
  } catch (error) {
    print(error);
    return null;
  }
}

Future<XFile?> pickImage_from_gal(context) async {
  try {
    // Check for camera and storage permissions
    var status = await Permission.photos.status;
    if (status.isDenied) {
      await Permission.photos.request();
      status = await Permission.photos.status;
      if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission denied')),
        );
        return null;
      }
    }

    // Select image source (gallery or camera)
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    return pickedFile;
  } catch (error) {
    print(error);
    return null;
  }
}

void ValidityDialog(context) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Material(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        'Oops, you’ve reached your messaging limit! you can send 2 messages or tools on a free plan. Upgrade to unlock unlimited messages. ',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                            color: Colors.black,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600)),
                    Divider(),
                    SizedBox(
                      height: 10.h,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 112, 118, 238),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r))),
                      onPressed: () {
                      }, // Handle navigation to next screen
                      child: const Text(
                        'Upgrade to pro',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      );
    },
  );
}
