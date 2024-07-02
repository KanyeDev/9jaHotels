import 'package:_9jahotel/core/screen_size/mediaQuery.dart';
import 'package:_9jahotel/core/services/data_models.dart';
import 'package:_9jahotel/core/utility/buttomSheet.dart';
import 'package:_9jahotel/core/widget/customButton.dart';
import 'package:_9jahotel/core/widget/my_textform_field.dart';
import 'package:_9jahotel/features/auth/signup/page/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/services/api_services.dart';
import '../../../home/page/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final apiService = ApiService();

  final _formKey = GlobalKey<FormState>();

  final BottomSheetResponse _bottomSheetResponse = BottomSheetResponse();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RxBool isObscured = true.obs;
  RxBool isLoading = false.obs;
  String errorMessage = '';


  String _getErrorMessage() {
    String errorMessage = '';
    if (_emailController.text.isEmpty) {
      errorMessage = 'Please enter an email';
    } else if (!_isValidEmail(_emailController.text)) {
      errorMessage = 'Invalid email, Please enter a valid email';
    } else if (_passwordController.text.isEmpty) {
      errorMessage = 'Password field cannot be empty';
    } else if (_passwordController.text.length < 6) {
      errorMessage = 'Password length must be greater than 6';
    }
    return errorMessage.trim();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );
    return emailRegex.hasMatch(email);
  }

  void login() async {
    isLoading.value = true;
    if ((_formKey.currentState?.validate() ?? false) &&
        (_passwordController.text.length > 6)) {
      try {
        await apiService.login(_emailController.text, _passwordController.text)
            .then((value) {
          if (value != null && value.success) {
            isLoading.value = false;
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                HomeScreen(
                    firstName: value.user.firstName, lastName: value.user.lastName, email:value.user.email)));
            return value;
          } else {
            // Handle unsuccessful login
            isLoading.value = false;
            _bottomSheetResponse.showErrorBottomSheet(
                context, 'Failed', "Incorrect login credentials");
            return null;
          }
        });
      } catch (error) {
        // Handle other errors
        isLoading.value = false;
        throw(error);
        return null;
      }
      errorMessage = ''; // Clear the error message
    } else {
      // Form is invalid, collect error messages
      setState(() {
        errorMessage = _getErrorMessage();
      });
      isLoading.value = false;
      // Show the error message in a bottom sheet
      _bottomSheetResponse.showErrorBottomSheet(
          context, 'Failed', errorMessage);
    }
    isLoading.value = false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffB02700),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(40),
            Align(
                alignment: Alignment.center,
                child: SizedBox(
                    height: getHeight(context) / 4.3,
                    width: getWidth(context) / 1.7,
                    child: Image.asset(
                      "assets/images/icon.png",
                    ))),
            const Text(
              "Hotel Login",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 21),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Gap(18),
                    MyTextFormField(
                      height: 50,
                      textPaddingSIze: 50,
                      textToHintInput: "Email Address",
                      prefixIcon: const Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.mail,
                          color: Color(0xffB02700),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      width: getWidth(context) - 35,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        } else if (!_isValidEmail(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const Gap(20),
                    Obx(
                          () =>
                          MyTextFormField(

                            height: 50,
                            isObscured: isObscured.value,
                            textPaddingSIze: 50,
                            textToHintInput: "Password",
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Icon(
                                Icons.lock,
                                color: Color(0xffB02700),
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passwordController,
                            width: getWidth(context) - 35,
                            icon: IconButton(
                              onPressed: () {
                                isObscured.value = !isObscured.value;
                              },
                              icon: Icon(
                                isObscured.value == false
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xffB02700),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                    ),
                  ],
                )),
            const Gap(35),
            Obx(
                  () =>
                  CustomButton(
                    isLoading: isLoading.value,
                    color: const Color(0xffEA5232),
                    text: "Login",
                    onTap: () {

                      login();
                    },
                    borderRadius: 5,
                    borderColor: Colors.transparent,
                    textColor: Colors.white,
                  ),
            ),
            const Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "New Hotel?",
                  style: TextStyle(color: Colors.white),
                ),
                const Gap(9),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//const Color(0xffEA5232)
