import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:cutis_ai/DashBoard Data/DashBoard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'Message.dart';
import 'Palm_Api.dart';

String? HomeScreen_prompt;

class Chat_UI extends ConsumerStatefulWidget {
  const Chat_UI({super.key});

  @override
  ConsumerState<Chat_UI> createState() {
    return _Chat_UI();
  }
}

class _Chat_UI extends ConsumerState<Chat_UI> {
  @override
  void initState() {
    home_message();
    load_bg();
    super.initState();
  }
  @override
  void dispose() {
    textcontroler.dispose();
    super.dispose();
  }
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = "";
  final textcontroler = TextEditingController();

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
  void load_bg() async{
    await Future.delayed(Duration(seconds:2));
    print("Loading");
  }
  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    _isListening=true;
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      localeId: "en_En",
      cancelOnError: false,
      partialResults: false,
      listenMode: ListenMode.confirmation,
    );
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    _isListening=false;
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(result) {
    setState(() {
      _lastWords = "$_lastWords${result.recognizedWords} ";
      textcontroler.text = _lastWords;
      _isListening=false;
    });
  }
  List<ChatMessage> all_messages = [];

  String convoID='';
  void home_message() {
    ChatMessage home = ChatMessage(
      user: user,
      createdAt: DateTime.now(),
      text: HomeScreen_prompt!,
    );
    return send_message(home);
  }

  ChatUser user = ChatUser(id: '1', firstName:'default user ',profileImage:'image_url');
  ChatUser Chat_Bot = ChatUser(id: '2', firstName: 'Chat_GPT');
  bool  _isListening = false;
  List<ChatUser> is_responding = [];

  void send_message(ChatMessage message) async {
    final newReq= bot_req(convo_detail:convoID);
    convoID=newReq.convo_detail;
    is_responding.add(Chat_Bot);
    all_messages.insert(0, message);
    setState(() {});
    final data = await newReq.makeApiRequest(message.text);
    convoID=data['conversationId'];
    final textResponse=data['text'];
    ChatMessage gptResponse = ChatMessage(
      user: Chat_Bot,
      createdAt: DateTime.now(),
      text: textResponse,
    );
    all_messages.insert(0, gptResponse);
    is_responding.remove(Chat_Bot);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60.h,
        backgroundColor: Color.fromARGB(255, 71, 79, 215),
        elevation: 1,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.chevron_left_sharp,color: Colors.white,)),
        centerTitle: true,
        title: SizedBox(
          child: Row( mainAxisAlignment: MainAxisAlignment.center,mainAxisSize:MainAxisSize.min,
            children: [
              Text('Aixtur AI',
                  style: GoogleFonts.bevan(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white)),
            ],
          ),
        ),
        actions: [
          // IconButton(onPressed:(){
          //   showModalBottomSheet(clipBehavior: Clip.antiAlias,context: context, builder: (context) {
          //     return more_option(context);
          //   });
          // },icon: const Icon(Icons.more_vert,color: Colors.white)),
          // SizedBox(
          //   width: 15.w,
          // )
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 71, 79, 215),
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
                    topRight: Radius.circular(60.r))
            ),
            child: Stack( alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 90.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 111, 117, 236),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.r),
                          topRight: Radius.circular(35.r))),),
                DashChat(
                    inputOptions: InputOptions( textController:textcontroler,
                      inputToolbarStyle: BoxDecoration(color: Colors.white,
                          borderRadius:BorderRadius.circular(25.r)),
                      inputToolbarMargin: EdgeInsets.only(left: 15.w,right: 15.w,top:30.h,bottom:20.h),
                      inputTextStyle: TextStyle(fontSize:14.sp,),
                      // maxInputLength: 200,
                      inputToolbarPadding: EdgeInsets.symmetric(horizontal: 12),
                      inputDecoration: InputDecoration(
                          border: InputBorder.none,
                          // prefixIcon: GestureDetector(
                          //   child: SvgPicture.asset(
                          //     'lib/Assets/image/Attach file Bottom Icon.svg',
                          //   ),
                          //   onTap: () {
                          //     showModalBottomSheet(context: context, builder: (context) {
                          //       return file_handdle(context);
                          //     });
                          //   }
                          // ),
                          prefixIconConstraints:
                          BoxConstraints(minHeight: 27.h, minWidth: 27.w),
                          suffixIcon: GestureDetector(
                            onTap:
                            _speechToText.isNotListening
                                ? _startListening
                                : _stopListening,
                            child:SizedBox(
                              height: 100,width: 100,
                              child: Lottie.network(
                                'https://lottie.host/7869efe7-2e65-4b86-8d49-f71b2a9d2f50/mTbkVPTjvX.json',
                                animate: true,
                              )
                            ),
                          ),
                          suffixIconConstraints:
                          BoxConstraints(maxHeight: _isListening?50.h:25.h, maxWidth: _isListening?50.w:25.w),
                          hintText: _isListening?'Listening...':'Ask Aixture'),
                    ),
                    messageOptions:  MessageOptions(
                      bottom: (message, previousMessage, nextMessage) =>share_msg(message.text),
                      maxWidth: 250.w,
                      containerColor: Color.fromARGB(255, 214, 217, 255),
                      currentUserContainerColor: Color.fromARGB(255, 226, 226, 226),
                      currentUserTextColor: Colors.black,
                      showCurrentUserAvatar: true,
                    ),
                    typingUsers: is_responding,
                    messageListOptions: MessageListOptions(typingBuilder:(user) {
                      return Container(
                        height: 100.h,
                        width: 180.w,
                        alignment: Alignment.centerLeft,
                        child: Stack(alignment:Alignment.centerLeft,fit: StackFit.expand,
                          children: [
                            Positioned(width:200,
                              height: 200,
                              child: Lottie.network(
                                alignment:Alignment.bottomCenter,
                                'https://lottie.host/934c550d-e57c-4412-b165-55a3fbfc9f78/EdFUTrswoc.json',

                              ),
                            ),
                          ],
                        ),
                      );
                    },),
                    currentUser: user,
                    onSend: (ChatMessage message) {
                      send_message(message);
                    },
                    messages: all_messages),

              ],
            ),
          )),
    );
  }

  bot_req({required String convo_detail}) {

  }

  share_msg(String text) {}
}

Column more_option(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(height:10.h,),
      GestureDetector(
        onTap: () {

        },
        child: options(
            image_resource:Icon(Icons.volume_up),
            text: 'Turn On Voice'),
      ),
      const Divider(color: Colors.grey, height: 2),
      GestureDetector(
        onTap: (){pickFile(context);},
        child: options(
            image_resource: Icon(Icons.share),

            text: 'Share Chat'),
      ),
      const Divider(color: Colors.grey, height: 2),
      options(
          image_resource:Icon(Icons.delete_forever_rounded),
          text: 'Delete chat'),
    ],
  );
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
      color: Color.fromARGB(255, 241, 239, 247),
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
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}