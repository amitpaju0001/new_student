import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_info/auth/model/user_model.dart';
import 'package:student_info/student_detail/model/reuse_validator_model.dart';
import 'package:student_info/student_detail/service/database_service.dart';
import 'package:student_info/student_detail/shared/const.dart';
import 'package:student_info/student_detail/ui/screen/login_screen.dart';
import 'package:student_info/student_detail/ui/screen/student_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool passToggle = true;
  final GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                    padding: EdgeInsets.all(20), child: Icon(Icons.person)),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: StringConst.signUpName,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: reuseValidatorModel,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: StringConst.signUpEmail,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: reuseValidatorModel,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: StringConst.signUpPhone,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: reuseValidatorModel,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: passToggle ? true : false,
                    decoration: InputDecoration(
                        labelText: StringConst.signUpPassword,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: InkWell(
                          onTap: () {
                            if (passToggle == true) {
                              passToggle = false;
                            } else {
                              passToggle = true;
                            }
                            setState(() {});
                          },
                          child: passToggle
                              ? const Icon(CupertinoIcons.eye_slash_fill)
                              : const Icon(CupertinoIcons.eye_fill),
                        )),
                    validator: reuseValidatorModel,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          if (formKey.currentState?.validate() ?? false) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StudentScreen(),
                                ));
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 40),
                          child: Center(
                            child: Text(
                              StringConst.signUp,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      StringConst.signUpAlreadyAccount,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                    ),
                    TextButton(
                      onPressed: () {
                        register(context);
                      },
                      child: const Text(
                        StringConst.logIn,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future register(BuildContext context) async {
    DatabaseService databaseService = DatabaseService();
    bool isUserExist = await databaseService.isUserExists(emailController.text);
    if (!isUserExist) {
      try {
        UserModel userModel = UserModel(
            userName: nameController.text,
            password: passwordController.text,
            phone: phoneController.text,
            email: emailController.text);
        await databaseService.registerUser(userModel);
        if(mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
        }
      } catch (e) {
        print(e.toString());
      }
    }else{
      print('User already exists');
    }
  }
}
