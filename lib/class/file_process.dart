import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Class for read/write User Todo json file
class FileProcess {
  String filename;

  FileProcess(this.filename);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents.toString();
    } catch (e) {
      return 'fail';
    }
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;
    return file.writeAsString('$data');
  }
} //end class
