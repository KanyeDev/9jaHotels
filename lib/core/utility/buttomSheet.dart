import 'package:_9jahotel/core/screen_size/mediaQuery.dart';
import 'package:_9jahotel/core/widget/customButton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class BottomSheetResponse {

  void showErrorBottomSheet(
      BuildContext context, String title, String message) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          width: getWidth(context),
          padding: const EdgeInsets.all(16.0),
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xffB02700),
                radius: 20,
                child:
                    Icon(FontAwesomeIcons.xmark, color: Colors.white, size: 20),
              ),
              const Gap(10),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Gap( 5),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const Gap( 10),
              CustomButton(
                  textSize: 15,
                  height: 40,
                  shadowOpacity: 0,
                  borderRadius: 10,
                  borderColor: const Color(0xffB02700),
                  color: Colors.white,
                  text: 'Close',
                  onTap: () => Navigator.pop(context)),
            ],
          ),
        );
      },
    );
  }
}
