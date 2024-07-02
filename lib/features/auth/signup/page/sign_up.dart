import 'package:_9jahotel/core/screen_size/mediaQuery.dart';
import 'package:_9jahotel/core/utility/buttomSheet.dart';
import 'package:_9jahotel/core/widget/customButton.dart';
import 'package:_9jahotel/core/widget/my_textform_field.dart';
import 'package:_9jahotel/features/auth/login/page/login.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/services/api_services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final apiService = ApiService();

  final _formKey = GlobalKey<FormState>();

  final BottomSheetResponse _bottomSheetResponse = BottomSheetResponse();
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _hotelAddressController = TextEditingController();
  final TextEditingController _hotelEmailController = TextEditingController();
  final TextEditingController _hotelNumberController = TextEditingController();
  final TextEditingController _hotelStateController = TextEditingController();
  final TextEditingController _hotelCityController = TextEditingController();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ownerEmailController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  FocusNode focusNode = FocusNode();


  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {

        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
    // Scroll to the last item when the screen is initially built
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   scrollDown();
    // });
  }


  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  RxBool isObscured = true.obs;
  RxBool isLoading = false.obs;
  String errorMessage = '';
  bool isHotelDetailsComplete = false;

  // List of states and their corresponding cities
  final Map<String, List<String>> stateCities = {
    'Oyo': ['Ibadan', 'Egbeda'],
    'Ogun': ['Abeokuta', 'Sango Ota', 'ISagamu'],
    'Lagos': [
      'Ikeja',
      'Ajah',
      'Lekki',
      'Ibeju-Lekki',
      'Ikorodu',
      'Oshodi -isolo',
      'Mushin',
      'Festac',
      'Somolu',
      'Epe',
      'Lagos islan'
    ],
    'Abuja': [ 'Maitama', 'Wuse','Garki','Gwagwalada'],
    'Rivers State': ['Port Harcourt']
  };

  String? selectedState;
  String? selectedCity;

  void _validateOwnerForm(BuildContext context) {
    isLoading.value = true;
    if (_getSecondErrorMessage() == "") {
      errorMessage = '';
      isLoading.value = false;
      // Form is valid, proceed with the signup
      signUp();
      // success message and navigate to another screen
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      // Form is invalid, collect error messages
      setState(() {
        errorMessage = _getSecondErrorMessage();
      });
      // Show the error message in a bottom sheet
      isLoading.value = false;
      _bottomSheetResponse.showErrorBottomSheet(
          context, 'Failed', errorMessage);
    }
  }

  void _validateHotelForm(BuildContext context) {
    if (_getFirstErrorMessage() == '') {
      setState(() {
        errorMessage = '';
        isHotelDetailsComplete = true;
      });
    } else {
      setState(() {
        errorMessage = _getFirstErrorMessage();
      });
      // Show the error message in a bottom sheet
      _bottomSheetResponse.showErrorBottomSheet(
          context, 'Failed', errorMessage);
    }
  }

  String _getSecondErrorMessage() {
    if (_firstNameController.text.isEmpty) {
      errorMessage = 'Please enter first name';
    } else if (_lastNameController.text.isEmpty) {
      errorMessage = 'Please enter last name';
    } else if (_ownerPhoneController.text.isEmpty) {
      errorMessage = 'Please enter phone number';
    } else if (!_isValidEmail(_ownerEmailController.text)) {
      errorMessage = 'Invalid email, Please enter a valid email';
    } else if (_passwordController.text.isEmpty) {
      errorMessage = 'Please enter a password';
    } else if (_passwordController.text.length < 6) {
      print("Password length ${_passwordController.text.length}");
      errorMessage = 'Password length must be greater than 6';
    }

    return errorMessage;
  }

  String _getFirstErrorMessage() {
    String errorMessage = '';
    if (_hotelNameController.text.isEmpty) {
      errorMessage = 'Please enter hotel name';
    } else if (_hotelAddressController.text.isEmpty) {
      errorMessage = 'Please enter hotel address';
    } else if (_hotelNumberController.text.isEmpty) {
      errorMessage = 'Please enter hotel phone number';
    } else if (_hotelEmailController.text.isEmpty) {
      errorMessage = 'Please enter hotel email';
    } else if (_hotelStateController.text.isEmpty) {
      errorMessage = 'Please select state';
    } else if (_hotelCityController.text.isEmpty) {
      errorMessage = 'Please select city';
    }

    return errorMessage;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );
    return emailRegex.hasMatch(email);
  }

  void signUp() {
    apiService
        .register(
      _hotelNameController.text,
      _hotelAddressController.text,
      _hotelEmailController.text,
      _hotelNumberController.text,
      "1",
      "2",
      _firstNameController.text,
      _lastNameController.text,
      _ownerEmailController.text,
      _ownerPhoneController.text,
      _passwordController.text,
    )
        .then((registerResponse) {
      if (registerResponse != null && registerResponse.success) {
        print('Registration successful: ${registerResponse.message}');
      } else {
        print('Registration failed: ${registerResponse?.message}');
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffB02700),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0),
          child:  Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(25),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: getHeight(context) / 6,
                      width: getWidth(context) / 1.5,
                      child: Image.asset("assets/images/icon.png"),
                    ),
                  ),
                  const Gap(10),
                  const Text(
                    "Hotel Signup",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleText(number: '1'),
                      const Gap(10),
                      const Text(
                        "Hotel Details",
                        style: TextStyle(color: Colors.white),
                      ),
                      const Gap(10),
                      SizedBox(
                        width: getWidth(context) / 4,
                        child: const Divider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                      ),
                      const Gap(10),
                      const CircleText(number: '2'),
                      const Gap(10),
                      const Text(
                        "Owners Details",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const Gap(40),
        
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(children: [
                      Visibility(
                          visible: !isHotelDetailsComplete,
                          child: SizedBox(
                            height: getHeight(context) / 1.74,
                            child: GlowingOverscrollIndicator(
                              axisDirection: AxisDirection.down,
                              color: const Color(0xffB02700),
                              child: SingleChildScrollView(
                                physics: const PageScrollPhysics(),
                                child: Column(children: [
                                  const Gap(20),
                                  const Text(
                                    "Please provide accurate information during this sign up process",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        const Gap(18),
                                        MyTextFormField(
                                          height: 50,
                                          textPaddingSIze: 20,
                                          textToHintInput: "Hotel Name",
                                          keyboardType:
                                          TextInputType.emailAddress,
                                          controller: _hotelNameController,
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
                                        MyTextFormField(
                                          height: 50,
                                          textPaddingSIze: 20,
                                          textToHintInput: "Hotel Address",
                                          keyboardType: TextInputType.text,
                                          controller: _hotelAddressController,
                                          width: getWidth(context) - 35,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a address';
                                            }
                                            return null;
                                          },
                                        ),
                                        const Gap(20),
                                        MyTextFormField(
                                          height: 50,
                                          textPaddingSIze: 20,
                                          textToHintInput: "Hotel Email",
                                          keyboardType: TextInputType.text,
                                          controller: _hotelEmailController,
                                          width: getWidth(context) - 35,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a address';
                                            }
                                            return null;
                                          },
                                        ),
                                        const Gap(20),
                                        MyTextFormField(
                                          height: 50,
                                          textPaddingSIze: 20,
                                          textToHintInput: "Hotel phone number",
                                          keyboardType: TextInputType.phone,
                                          controller: _hotelNumberController,
                                          width: getWidth(context) - 35,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a address';
                                            }
                                            return null;
                                          },
                                        ),
                                        const Gap(20),
                                        DropdownButtonFormField<String>(
                                          iconEnabledColor:
                                          const Color(0xffB02700),
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black),
                                              borderRadius:
                                              BorderRadius.circular(8.0),
                                            ),
                                            fillColor: Colors.white,
                                            filled: true,
                                            contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            border: OutlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black),
                                              borderRadius:
                                              BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          hint: const Text("Select State"),
                                          value: selectedState,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedState = newValue;
                                              _hotelStateController.text =
                                              newValue!;
                                              selectedCity =
                                              null; // Reset city selection
                                            });
                                          },
                                          items: stateCities.keys
                                              .map((String state) {
                                            return DropdownMenuItem<String>(
                                              value: state,
                                              child: Text(state, style: TextStyle(fontSize: 13),),
                                            );
                                          }).toList(),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please select a state';
                                            }
                                            return null;
                                          },
                                        ),
                                        const Gap(20),
                                        DropdownButtonFormField<String>(
                                          iconEnabledColor:
                                          const Color(0xffB02700),
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black),
                                              borderRadius:
                                              BorderRadius.circular(8.0),
                                            ),
                                            fillColor: Colors.white,
                                            filled: true,
                                            contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            border: OutlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.black),
                                              borderRadius:
                                              BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          hint: const Text("Select City"),
                                          value: selectedCity,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedCity = newValue;
                                              _hotelCityController.text =
                                              newValue!;
                                            });
                                          },
                                          items: selectedState != null
                                              ? stateCities[selectedState]!
                                              .map((String city) {
                                            return DropdownMenuItem<String>(
                                              value: city,
                                              child: Text(city,  style: TextStyle(fontSize: 13),),
                                            );
                                          }).toList()
                                              : [],
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please select a city';
                                            }
                                            return null;
                                          },
                                        ),
                                        const Gap(30),
                                        Obx(
                                              () => CustomButton(
                                            isLoading: isLoading.value,
                                            color: const Color(0xffEA5232),
                                            text: "Continue",
                                            onTap: () {
                                              _validateHotelForm(context);
                                            },
                                            borderRadius: 5,
                                            borderColor: const Color(0xffEA5232),
                                            textColor: Colors.white,
                                          ),
                                        ),
        
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          )),
                      Visibility(
                        visible: isHotelDetailsComplete,
                        child: SizedBox(
                          height: getHeight(context) / 1.74,
                          child: SingleChildScrollView(
                            physics: PageScrollPhysics(),
                            child: Column(
                              children: [
                                const Text(
                                  "Please provide accurate information during this sign up process",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      const Gap(18),
                                      MyTextFormField(
                                        height: 50,
                                        textPaddingSIze: 20,
                                        textToHintInput: "First Name",
                                        keyboardType: TextInputType.name,
                                        controller: _firstNameController,
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
                                      MyTextFormField(
                                        height: 50,
                                        textPaddingSIze: 20,
                                        textToHintInput: "Last Name",
                                        keyboardType: TextInputType.name,
                                        controller: _lastNameController,
                                        width: getWidth(context) - 35,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a address';
                                          }
                                          return null;
                                        },
                                      ),
                                      const Gap(20),
                                      MyTextFormField(
                                        height: 50,
                                        textPaddingSIze: 20,
                                        textToHintInput: "Owner's Email",
                                        keyboardType: TextInputType.text,
                                        controller: _ownerEmailController,
                                        width: getWidth(context) - 35,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a address';
                                          }
                                          return null;
                                        },
                                      ),
                                      const Gap(20),
                                      MyTextFormField(
                                        height: 50,
                                        textPaddingSIze: 20,
                                        textToHintInput: "Owner's phone number",
                                        keyboardType: TextInputType.phone,
                                        controller: _ownerPhoneController,
                                        width: getWidth(context) - 35,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a address';
                                          }
                                          return null;
                                        },
                                      ),
                                      const Gap(20),
                                      Obx(
                                            () => MyTextFormField(
                                          height: 50,
                                          isObscured: isObscured.value,
                                          textPaddingSIze: 20,
                                          textToHintInput: "Password",
                                          keyboardType:
                                          TextInputType.visiblePassword,
                                          controller: _passwordController,
                                          width: getWidth(context) - 35,
                                          icon: IconButton(
                                            onPressed: () {
                                              isObscured.value =
                                              !isObscured.value;
                                            },
                                            icon: Icon(
                                              isObscured.value == false
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: const Color(0xffB02700),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a password';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(30),
                                Obx(
                                      () => CustomButton(
                                    isLoading: isLoading.value,
                                    color: const Color(0xffEA5232),
                                    text: "Continue",
                                    onTap: () {
                                      _validateOwnerForm(context);
                                    },
                                    borderRadius: 5,
                                    borderColor: const Color(0xffEA5232),
                                    textColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Gap(25),
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
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Already have an account?",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],),
                  )
                ],
              )
        
        ),
      ),
    );
  }
}

class CircleText extends StatelessWidget {
  const CircleText({
    super.key,
    required this.number,
  });

  final String number;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Color(0xff6D1400),
      radius: 12,
      child: Text(
        number,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 13,
        ),
      ),
    );
  }
}
