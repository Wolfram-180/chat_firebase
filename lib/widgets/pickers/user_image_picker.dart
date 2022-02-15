import 'dart:io';

import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({Key? key}) : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  //String _pickedImagePathDflt = 'assets/images/transparent.png';
  String _pickedImagePath = 'assets/images/transparent.png';
  late File _pickedImage;

  @override
  void initState() {
    _pickedImage = File(_pickedImagePath);
    super.initState();
  }

  final ImagePicker _picker = ImagePicker();

  void _pickImage() async {
    final pickedImageFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _pickedImagePath = pickedImageFile!.path;
      _pickedImage = pickedImageFile as File;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AvatarView(
          radius: 60,
          borderWidth: 8,
          borderColor: Colors.yellow,
          avatarType: AvatarType.CIRCLE,
          backgroundColor: Colors.red,
          imagePath: _pickedImagePath,
          placeHolder: Container(
            child: Icon(
              Icons.person,
              size: 50,
            ),
          ),
          errorWidget: Container(
            child: Icon(
              Icons.error,
              size: 50,
            ),
          ),
        ),
        //CircleAvatar(
        //  radius: 40,
        //  backgroundColor: Colors.grey,
        //  backgroundImage: FileImage(_pickedImage),
        //    AssetImage('assets/images/body.jpg'), // FileImage(_pickedImage),
        //(_pickedImage != null)   ? : AssetImage('assets/images/body.jpg'),
        // ),
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
