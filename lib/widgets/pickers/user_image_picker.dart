import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class UserImagePicker extends StatefulWidget {
  late final void Function(File? pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();

  UserImagePicker(this.imagePickFn);
}

class _UserImagePickerState extends State<UserImagePicker> {
  //String _pickedImagePathDflt = 'assets/images/transparent.png';
  String _pickedImagePath = 'assets/images/transparent.png';
  late File _pickedImage;
  bool _isPicked = false;

  // @override
  // void initState() {
  //   _pickedImage = File(_pickedImagePath);
  //   super.initState();
  // }

  ImagePicker _picker = ImagePicker();

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  void _pickImage() async {
    final pickedImageFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _isPicked = true;
      _pickedImage = (File(pickedImageFile!.path));
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _isPicked == false
              ? AssetImage('assets/images/transparent.png') as ImageProvider
              : FileImage(_pickedImage), //FileImage(_pickedImage as File),
          //    AssetImage('assets/images/body.jpg'), // FileImage(_pickedImage),
          //  (_pickedImage != null)   ? : AssetImage('assets/images/body.jpg'),
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: const Icon(
            Icons.image,
          ),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
