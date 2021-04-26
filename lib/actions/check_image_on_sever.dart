import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as Http;

Future<List> checkImageOnSever(
    {String key = 'image', @required List<Map> imagelist}) async {
  List<Map> result = [];
  for (var value in imagelist) {
    var response = await Http.get(value[key]);
    if (response.statusCode == 200) {
      result.add(value);
    }
  }

  return result;
}
