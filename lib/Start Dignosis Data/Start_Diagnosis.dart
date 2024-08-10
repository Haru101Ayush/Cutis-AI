import 'dart:convert';
import 'dart:io';
import 'package:cutis_ai/Start%20Dignosis%20Data/Palm_Api.dart';
import 'package:cutis_ai/main.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';

String? HomeScreen_prompt;

class Chat_UI extends ConsumerStatefulWidget {
  const Chat_UI({super.key});

  @override
  ConsumerState<Chat_UI> createState() {
    return _Chat_UI();
  }
}

class _Chat_UI extends ConsumerState<Chat_UI> {

  final textcontroler = TextEditingController();
  List<ChatMessage> all_messages = [];
  String convoID = '';
  List<ChatMedia>? medias =[];
  ChatUser user = ChatUser(id: '1', firstName: 'default user ', profileImage: 'https://i.pinimg.com/originals/db/93/25/db93259024d2a436ecf46c9757e3765e.png');
  ChatUser Chat_Bot = ChatUser(id: '2', firstName: 'Dr. CutisMind', profileImage: 'https://doctorlistingingestionpr.blob.core.windows.net/doctorprofilepic/1717045129778_ProfilePic_portrait-of-a-happy-young-doctor-in-his-clinic-royalty-free-image-1661432441.jpg');
  List<ChatUser> is_responding = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textcontroler.dispose();
    super.dispose();
  }

  void send_message(ChatMessage message) async {
    all_messages.add(message);
    is_responding.add(Chat_Bot);
    setState(() {});
    textcontroler.clear();
    final response = await Cutis_bot(message.text)??'no response';
    is_responding.remove(Chat_Bot);
    all_messages.add(ChatMessage(user: Chat_Bot, createdAt: DateTime.now(), text: response));
    setState(() {});
  }

  void send_media() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final media = ChatMedia(
        type: MediaType.image, url: image.path, fileName: 'sample url',
      );
      final message = ChatMessage(
        user: user,
        createdAt: DateTime.now(),
        medias: [media],
      );
      all_messages.add(message);
      is_responding.add(Chat_Bot);
      setState(() {});
      if (image != null) {
        try {
          final Uri uri = Uri.parse('https://detect-skin-disease.p.rapidapi.com/facebody/analysis/detect-skin-disease');

          final http.MultipartRequest request = http.MultipartRequest('POST', uri);

          // Set headers
          request.headers['content-type'] =
          'multipart/form-data; boundary=---011000010111000001101001';
          request.headers['X-RapidAPI-Key'] =
          '5b593c0700msh8275d05164fc81ap1422dajsncee0cb58fc10';
          request.headers['X-RapidAPI-Host'] =
          'detect-skin-disease.p.rapidapi.com';

          // Add image to request
          request.files
              .add(await http.MultipartFile.fromPath('image', image.path));

          final http.StreamedResponse response = await request.send();
          final responseData = await response.stream.bytesToString();

          print(responseData);

          // Convert responseData to Map
          Map<String, dynamic> responseMap = json.decode(responseData);

          print(responseMap['data']['results_english']);
          final Map<String,dynamic> dis = responseMap['data']['results_english'];
          final String disease=findHighestKey(dis);
          ChatMessage message = ChatMessage(user: Chat_Bot, createdAt: DateTime.now(), text: 'Disease: $disease');
          is_responding.remove(Chat_Bot);
          send_message(message);
          setState(() {});


        } catch (e) {
          print('Error uploading image: $e');
        }
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60.h,
        backgroundColor: PrimaryColor,
        elevation: 1,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.chevron_left_sharp,
              color: Colors.white,
            )),
        centerTitle: true,
        title: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Cutis AI',
                  style: GoogleFonts.rufina(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white)),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    clipBehavior: Clip.antiAlias,
                    context: context,
                    builder: (context) {
                      return more_option(context);
                    });
              },
              icon: const Icon(Icons.more_vert, color: Colors.white)),
          SizedBox(
            width: 15.w,
          )
        ],
      ),
      backgroundColor: PrimaryColor,
      body: SafeArea(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 80),
            padding: const EdgeInsets.only(top: 0),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
            color: const Color.fromARGB(255, 244, 244, 244),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60.r),
                topRight: Radius.circular(60.r))),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 90.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: PrimaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35.r),
                      topRight: Radius.circular(35.r))),
            ),
            DashChat(
                inputOptions: InputOptions(
                  inputToolbarStyle: BoxDecoration( color: Colors.white,
                      borderRadius: BorderRadius.circular(25.r)),
                  inputToolbarMargin: EdgeInsets.only(
                      left: 15.w, right: 15.w, top: 30.h, bottom: 20.h),
                  inputTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),

                  // maxInputLength: 200,
                  inputToolbarPadding: EdgeInsets.symmetric(horizontal: 10.w),
                  inputDecoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: GestureDetector(
                          child: Icon(CupertinoIcons.paperclip),
                          onTap: () {
                            showModalBottomSheet(
                                clipBehavior: Clip.antiAlias,
                                context: context,
                                builder: (context) {
                                  return file_handdle(context);
                                });
                          }),
                      prefixIconConstraints:
                          BoxConstraints(minHeight: 27.h, minWidth: 27.w),
                      hintText: 'Ask Aixture'),
                ),

                messageOptions: MessageOptions(
                  maxWidth: 230.w,
                  containerColor:  Color.fromARGB(102, 24, 170, 136),
                  currentUserContainerColor: const Color.fromARGB(255, 226, 226, 226),
                  currentUserTextColor: Colors.black,
                  showCurrentUserAvatar: true,
                ),
                typingUsers: is_responding,
                currentUser: user,
                onSend: (ChatMessage message) {
                  send_message(message);
                },
                messages: all_messages.reversed.toList()),
          ],
        ),
      )),
      floatingActionButton: Padding(
        padding:  EdgeInsets.only(bottom: 80.h),
        child: FloatingActionButton(

          onPressed: () {
            // uploadImage();
            send_media();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

Column more_option(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        height: 10.h,
      ),
      GestureDetector(
        onTap: () {},
        child: options(
            image_resource: const Icon(Icons.volume_up), text: 'Turn On Voice'),
      ),
      const Divider(color: Colors.grey, height: 2),
      GestureDetector(
        onTap: () {
          pickFile();
        },
        child: options(
            image_resource: const Icon(Icons.share), text: 'Share Chat'),
      ),
      const Divider(color: Colors.grey, height: 2),
      options(
          image_resource: const Icon(Icons.delete_forever_rounded),
          text: 'Delete chat'),
    ],
  );
}

Future<void> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    // Get the picked file
    PlatformFile file = result.files.first;
    print('File picked: ${file.name}');
    // You can now use the file, like accessing its path or bytes
  } else {
    // User canceled the picker
    print('File picking canceled');
  }
}

class options extends StatelessWidget {
  options({
    required this.text,
    required this.image_resource,
    super.key,
  });
  String text;
  Icon image_resource;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 241, 239, 247),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Leading icon
            image_resource,
            const SizedBox(width: 16.0),
            // Text content
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  color: Textcolor,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),
      ),
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
        child:
            Attach_file(image_resource: CupertinoIcons.camera, text: 'Camera'),
      ),
      const Divider(color: Colors.grey, height: 2),
      GestureDetector(
        onTap: () {
          pickImage_from_gal(context);
        },
        child:
            Attach_file(image_resource: CupertinoIcons.photo, text: 'Photos'),
      ),
      const Divider(color: Colors.grey, height: 2),
      GestureDetector(
        onTap: () {
          pickFile();
        },
        child: Attach_file(image_resource: CupertinoIcons.doc, text: 'Files'),
      ),
      const Divider(color: Colors.grey, height: 2),
      Attach_file(image_resource: CupertinoIcons.link, text: 'Web Link'),
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
  IconData image_resource;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Leading icon
            Icon(
              image_resource,
              size: 20.sp,
            ),
            const SizedBox(width: 16.0),
            // Text content
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  color: Textcolor,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

Future<XFile?> pickImage_from_gal(BuildContext context) async {
  try {
    // Check for camera and storage permissions
    var status = await Permission.photos.request();
    if (status.isDenied) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission denied'),
          content: const Text('Please grant permission to use the gallery'),
          actions: [
            TextButton(
              onPressed: () => exit(0),
              child: const Text('Close'),
            ),
          ],
        ),
      );
      return null;
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
