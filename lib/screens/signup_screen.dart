import 'dart:typed_data';

import 'package:dog_app/exceptions/custom_exception.dart';
import 'package:dog_app/providers/auth_provider.dart';
import 'package:dog_app/screens/signin_screen.dart';
import 'package:dog_app/widgets/error_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  Uint8List? _image;
  TextEditingController _passwordeditingController = TextEditingController();
  TextEditingController _emaileditingController = TextEditingController();
  TextEditingController _nameeditingController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isEnabled = true;

//갤러리에서 사진 가져오기
  Future<void> selectImage() async{
    ImagePicker imagePicker = new ImagePicker();
  XFile? file = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 512, //사진 해상도 512도 이하로 조정
      maxWidth: 512,
    );

  if(file != null){
    Uint8List unit8list = await file.readAsBytes();
    setState(() {
      _image = unit8list;
    });

  }
  }

  void dispose(){
    _emaileditingController.dispose();
    _nameeditingController.dispose();
    _passwordeditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _globalKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                shrinkWrap: true,//정가운데 정렬 ->리스트뷰
                reverse: true,
                children: [
                  //로고
                  Text("유기견 입양·후원·봉사앱",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,

                  )),

                  SizedBox(height: 20,),
                      //프로필사진
                  Container(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        _image == null ?
                        CircleAvatar(

                          radius: 64,
                          backgroundImage: AssetImage('assets/images/profile (1).png'),
                        ) : CircleAvatar(

                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        ),

                        Positioned(
                          left: 80,
                          bottom: -10,
                          child: IconButton(onPressed: _isEnabled ?() async{
                           await selectImage();
                          }:null,
                            icon: Icon(Icons.add_a_photo),

                          ),
                        )
                      ],
                    ),
                  ),
                   SizedBox(height: 30,),

                  //이메일
                  TextFormField(
                    enabled: _isEnabled,
                    controller: _emaileditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      filled: true,
                    ),
                    validator: (value) {
                      // 아무것도 입력 x
                      // 공백만 입력
                      // 이메일 형식이 아닐 때
                      if (value == null || value.trim().isEmpty || !isEmail(value.trim())){
                        return '이메일을 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                 SizedBox(height: 20,),
                //이름
                  TextFormField(
                    enabled: _isEnabled,
                    controller: _nameeditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '이름',
                      prefixIcon: Icon(Icons.account_circle),
                      filled: true,
                    ),
                    validator: (value){
                      if(value == null || value.trim().isEmpty){
                        return '이름을 입력해주세요.';
                      }
                      if(value.length<3 || value.length>10){
                        return '이름은 최소 3글자,최대 10글자 까지 입력가능합니다.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                //패스워드
                  TextFormField(
                    enabled: _isEnabled,
                    controller: _passwordeditingController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '비밀번호',
                      prefixIcon: Icon(Icons.lock),
                      filled: true,
                    ),
                    validator: (value){
                      if(value == null || value.trim().isEmpty){
                        return '패스워드를 입력해주세요.';
                      }
                      if(value.length<6){
                        return '패스워드는 6글자 이상 입력해주세요'; // firebas 에서 6글자 이상 받도록 함
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                //패스워드 확인
                  TextFormField(
                    enabled: _isEnabled,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '비밀번호 확인',
                      prefixIcon: Icon(Icons.lock),
                      filled: true,
                    ),
                      validator:(value){
                      if(_passwordeditingController.text != value){
                        return '패스워드가 일치 하지 않습니다.';
                      }
                      return null;
                      } ,
                  ),
                  SizedBox(height: 40,),

                  ElevatedButton(onPressed:_isEnabled ? () async {
                    final form = _globalKey.currentState;

                    setState(() {
                      _autovalidateMode = AutovalidateMode.always;
                    });

                    if(form == null || !form.validate()){
                      return;
                    }
                    setState(() {
                      _isEnabled = false;
                    });


                  //회원가입로직
                    try{
                     await context.read<AuthProvider>().signUp(
                          email: _emaileditingController.text,
                          name: _nameeditingController.text,
                          password: _passwordeditingController.text, profileImage: _image
                      );

                     Navigator.pushReplacement(
                         context,
                         MaterialPageRoute(
                             builder: (context) => SigninScreen()
                         ),
                     );

                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('인증 메일을 전송했습니다.'),
                       duration: Duration(seconds: 120),
                       )
                     );
                    } on CustomException catch (e){
                      setState(() {
                        _isEnabled = true;
                      });
                      errorDialogWidget(context, e);
                    }
                     } : null,
                      child: Text('회원가입'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 20),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                  ),
                  SizedBox(height: 10,),

                  TextButton(onPressed: _isEnabled ?() => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SigninScreen(),
                      )) : null,
                      child: Text('이미 회원이신가요? 로그인하기 ',
                      style: TextStyle(fontSize: 20),),)

                ].reversed.toList(),//자판버튼키면  최적화
              ),
            ),
          ),
        ),
      ),
    );

  }
}
