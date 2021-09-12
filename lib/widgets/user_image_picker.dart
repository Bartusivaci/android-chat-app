import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickfn);

  final void Function(File pickedImageFile) imagePickfn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File pickedImageFile;
  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      pickedImageFile = File(pickedImage.path);
    });
    widget.imagePickfn(pickedImageFile);
  }

  void _takePicture() async {
    final picker2 = ImagePicker();
    final tookPicture = await picker2.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      pickedImageFile = File(tookPicture.path);
    });
    widget.imagePickfn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          //resme tıklayınca da çalışıcak
          onTap: _takePicture,
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 50,
            backgroundImage:
                pickedImageFile != null ? FileImage(pickedImageFile) : null,
          ),
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(
            Icons.image,
          ),
          label: Text(
            "Add Image",
          ),
        ),
      ],
    );
  }
}
