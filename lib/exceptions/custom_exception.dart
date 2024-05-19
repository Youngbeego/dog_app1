class CustomException implements Exception {
  final String code;
  final String message;

  const CustomException({
    required this.code,
    required this.message,
  });

  @override
  String toString() {
    return this.message;
  }
}


//비밀번호 틀렷을 경우
//이미 가입된 이메일일 경우
