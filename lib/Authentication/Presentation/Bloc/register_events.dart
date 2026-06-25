class RegisterEvents {}

class AttemptedRegisterEvent extends RegisterEvents {
 final String name;
 final String email;
 final String password;
 final String confirmPassword;

 AttemptedRegisterEvent({required this.name,required this.email,required this.password,required this.confirmPassword});
}
