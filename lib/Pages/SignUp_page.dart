import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Widgets/CustomButton.dart';
import '../Widgets/CustomTexFormtField.dart';
import '../Widgets/customScaffoldMessanger.dart';
import '../constant.dart';

// ignore: must_be_immutable
class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});
  static String id = 'signUpPage';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? email;

  String? passWord;

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

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
                            'SignUp',
                            style: TextStyle(fontSize: 24, color: Colors.white),
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
                          hintText: 'PassWord',
                          onChange: (data) {
                            passWord = data;
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        CustomButton(
                          inputStatus: 'Sign Up',
                          ontap: () async {
                            if (formKey.currentState!.validate()) {
                              isLoading = true;
                              setState(() {});
                              try {
                                await registerUser();
                                showSnackBar(context, 'Sucess', Colors.green);
                                Navigator.pop(context);
                              } on FirebaseAuthException catch (ex) {
                                if (ex.code == 'weak-password') {
                                  showSnackBar(context,
                                      'The Password is too Weak', Colors.red);
                                } else if (ex.code == 'email-already-in-use') {
                                  showSnackBar(context, 'Email already in Used',
                                      Colors.grey);
                                  Navigator.pop(context);
                                }
                              } catch (ex) {
                                showSnackBar(
                                    context, 'there was an error', Colors.red);
                              }
                              isLoading = false;
                              setState(() {});
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'already have an account ?  ',
                              style: TextStyle(color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Login',
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
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    // ignore: unused_local_variable
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: passWord!);
  }
}
