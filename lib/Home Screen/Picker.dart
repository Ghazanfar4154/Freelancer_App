import 'package:file_picker/file_picker.dart';

class Picker
{
  static Future<void> pickFile([FileType? fileType]) async {
    FileType type = fileType!=null ? fileType : FileType.any;
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: type);

    if (result != null) {
      print("Name of File Picked : "+result.files.first.name);
      PlatformFile file = result.files.first;
    } else {
      // User canceled the picker
    }
  }
}