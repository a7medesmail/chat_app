import 'package:chat_app/Pages/ChatPage.dart';
import 'package:chat_app/Pages/SignUp_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Widgets/CustomButton.dart';
import '../Widgets/CustomTexFormtField.dart';
import '../Widgets/customScaffoldMessanger.dart';
import '../constant.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  static String id = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;

  String? passWord;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: Colors.black,
      inAsyncCall: isLoading,
      child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    kLoginAndSignup,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 125,
                          ),
                          Image.asset(kLogo),
                          const Center(
                            child: Text(
                              'Scholar Chat',
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontFamily: 'Pacifico'),
                            ),
                          ),
                          const SizedBox(
                            height: 75,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 310),
                            child: Text(
                              'LogIn',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            onChange: (data) {
                              email = data;
                            },
                            hintText: 'Email',
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextFormField(
                            obscureText: true,
                            onChange: (data) {
                              passWord = data;
                            },
                            hintText: 'PassWord',
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          CustomButton(
                            ontap: () async {
                              if (formKey.currentState!.validate()) {
                                isLoading = true;
                                setState(() {});

                                try {
                                  await LoginUser();

                                  showSnackBar(
                                    context,
                                    'Successfully signed in',
                                    Colors.green,
                                  );
                                  Navigator.pushNamed(context, ChatPage.id,
                                      arguments: email);
                                } on FirebaseAuthException catch (ex) {
                                  if (ex.code == 'user-not-found') {
                                    showSnackBar(
                                      context,
                                      'No user found for that email',
                                      Colors.red,
                                    );
                                  } else if (ex.code == 'wrong-password') {
                                    showSnackBar(
                                      context,
                                      'Wrong password provided for that user',
                                      Colors.red,
                                    );
                                  }
                                } catch (ex) {
                                  showSnackBar(
                                    context,
                                    'Error signing in',
                                    Colors.red,
                                  );
                                }

                                isLoading = false;
                                setState(() {});
                              } else {}
                            },
                            inputStatus: 'Login',
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'don\'t have an account ?  ',
                                style: TextStyle(color: Colors.white),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, SignUpPage.id);
                                },
                                child: const Text(
                                  'Sign Up',
                                  style:
                                      TextStyle(color: Colors.lightGreenAccent),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Future<void> LoginUser() async {
    // ignore: unused_local_variable
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: passWord!);
  }
}
