import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: 'AIzaSyBnOdr_8c5P8IYNUkfMTaKOQiV2BFwy59c');

Future<String?> Cutis_bot(String prompt) async {
  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);
  print(response.text);
  return response.text;
}

//-------------------------------------------------------------------------------------------------->>>>>>>>>
// ----------------------------------- for uploading the image file -------------------------------->>>>>>>>>
//-------------------------------------------------------------------------------------------------->>>>>>>>>



Future<String> uploadImage() async {
  final ImagePicker picker = ImagePicker();

  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

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
      return disease;

    } catch (e) {
      print('Error uploading image: $e');
    }
  }
  return 'An error occurred';
}

String findHighestKey(Map<String,dynamic> map) {

  double highestValue = map.values.first;
  String highestKey = map.keys.first;

  map.forEach((key, value) {
    if (value > highestValue) {
      highestValue = value;
      highestKey = key;
    }
  });

  return highestKey;
}