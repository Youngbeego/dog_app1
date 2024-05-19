import 'package:dog_app/exceptions/custom_exception.dart';
import 'package:dog_app/providers/auth_provider.dart';
import 'package:dog_app/providers/auth_state.dart';
import 'package:dog_app/screens/signup_screen.dart';
import 'package:dog_app/utils/logger.dart';
import 'package:dog_app/widgets/error_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController _passwordeditingController = TextEditingController();
  TextEditingController _emaileditingController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isEnabled = true;


  void dispose() {
    _emaileditingController.dispose();
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
                  shrinkWrap: true, //정가운데 정렬 ->리스트뷰
                  reverse: true,
                  children: [

                  Text("유기견 입양·후원·봉사앱",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,

                  )),
              SizedBox(height: 200,),
              //로고
              Text("로그인 하세요",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,

                  )),
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
                  if (value == null || value
                      .trim()
                      .isEmpty || !isEmail(value.trim())) {
                    return '이메일을 입력해주세요.';
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
                validator: (value) {
                  if (value == null || value
                      .trim()
                      .isEmpty) {
                    return '패스워드를 입력해주세요.';
                  }
                  if (value.length < 6) {
                    return '패스워드는 6글자 이상 입력해주세요'; // firebas 에서 6글자 이상 받도록 함
                  }
                  return null;
                },
              ),
              SizedBox(height: 20,),

              ElevatedButton(onPressed: _isEnabled ? () async {
                final form = _globalKey.currentState;

                setState(() {
                  _autovalidateMode = AutovalidateMode.always;
                });

                if (form == null || !form.validate()) {
                  return;
                }
                setState(() {
                  _isEnabled = false;
                  _autovalidateMode = AutovalidateMode.always;
                });


                //로그인 로직
                try {
                     logger.d(context.read<AuthState>().authStatus);

                      await context.read<AuthProvider>().signIn(
                           email: _emaileditingController.text,
                           password: _passwordeditingController.text,
                       );

                } on CustomException catch (e) {
                  setState(() {
                    _isEnabled = true;
                  });
                  errorDialogWidget(context, e);
                }
              } : null,
                child: Text('로그인'),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 20),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
              SizedBox(height: 10,),

              TextButton(
                  onPressed: _isEnabled ? () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignupScreen(),
                    )) :null,
                    child: Text('회원이 아니신가요? 회원가입 하기',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),

                  ].reversed.toList(), //자판버튼키면  최적화
            ),
          ),
        ),
      ),
    ),);

  }
}
