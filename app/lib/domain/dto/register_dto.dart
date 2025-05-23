class RegisterDto {
  String firstName;
  String lastName;
  String email;
  String password;
  String confirmPassword;

  RegisterDto({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
  });

  factory RegisterDto.withTestUser() => RegisterDto(
    email: 'jacobinho3@gmail.com',
    password: 'Teste@1234',
    confirmPassword: 'Teste@1234',
    firstName: 'Jacob',
    lastName: 'Moura',
  );

  void setFirstName(String value) => firstName = value;

  void setLastName(String value) => lastName = value;

  void setEmail(String value) => email = value;

  void setPassword(String value) => password = value;

  void setConfirmPassword(String value) => confirmPassword = value;

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'password': password,
  };
}
