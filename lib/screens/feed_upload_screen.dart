import 'dart:io';

import 'package:dog_app/providers/feed/feed_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FeedUploadScreen extends StatefulWidget {
  const FeedUploadScreen({super.key});

  @override
  State<FeedUploadScreen> createState() => _FeedUploadScreenState();
}

class _FeedUploadScreenState extends State<FeedUploadScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> _files = [];

  // Define the options for the dropdowns
  final List<String> _breedOptions = ['말티즈', '비숑', '시바견', '푸들' ,'치와와','믹스','x'];
  final List<String> _ageOptions = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10+', '추정불가'];
  final List<String> _colorOptions = ['검정색','흰색','갈색'];

  // State variables to manage selected values
  String? _selectedBreed;
  String? _selectedAge;
  String? _selectedColor;

  Future<List<String>> selectImages() async {
    List<XFile> images = await ImagePicker().pickMultiImage(
      maxHeight: 1024,
      maxWidth: 1024,
    );
    return images.map((e) => e.path).toList();
  }

  List<Widget> selectedImageList() {
    return _files.map((data) {
      return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Stack(
          children: [
            ClipRRect(
              child: Image.file(
                File(data),
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.4,
                width: 280,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _files.remove(data);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  height: 30,
                  width: 30,
                  child: Icon(
                    color: Colors.black.withOpacity(0.6),
                    size: 30,
                    Icons.highlight_remove_outlined,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              context.read<FeedProvider>().uploadFeed(
                files: _files,
                desc: _textEditingController.text,  //글 내용
                breed: _selectedBreed,    // 견종
                age: _selectedAge,// 나이
                color:_selectedColor,
              );
            },
            child: Text('Feed'),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      final _images = await selectImages();
                      setState(() {
                        _files.addAll(_images);
                      });
                    },
                    child: Column(
                      children: [
                        Text('사진 등록하기'),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          child: const Icon(Icons.upload),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...selectedImageList(),
                ],
              ),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                hintText: '견종',
                border: InputBorder.none,
              ),
              value: _selectedBreed,
              items: _breedOptions.map((String breed) {
                return DropdownMenuItem<String>(
                  value: breed,
                  child: Text(breed),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBreed = newValue;
                });
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                hintText: '나이',
                border: InputBorder.none,
              ),
              value: _selectedAge,
              items: _ageOptions.map((String age) {
                return DropdownMenuItem<String>(
                  value: age,
                  child: Text(age),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedAge = newValue;
                });
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                hintText: '털색',
                border: InputBorder.none,
              ),
              value: _selectedColor,
              items: _colorOptions.map((String color) {
                return DropdownMenuItem<String>(
                  value: color,
                  child: Text(color),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedColor = newValue;
                });
              },
            ),
            TextFormField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: '강아지에 대해 소개해주세요...',
                border: InputBorder.none,
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
