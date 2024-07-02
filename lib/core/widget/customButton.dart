import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../screen_size/mediaQuery.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
        required this.color,
        this.width = 0,
        this.height = 50,
        required this.text,
        required this.onTap,
        this.borderColor = const Color(0xffDDB45A),
        this.textSize = 17,
        this.isLoading = false,
        this.textColor = const Color(0xff172B59),
        this.widget = const SizedBox(),
        this.borderRadius = 16,
        this.shadowOpacity = 0.2});

  final Color color, borderColor, textColor;
  final double width, height;
  final String text;
  final double textSize;
  final VoidCallback onTap;
  final bool isLoading;
  final Widget widget;
  final double borderRadius;
  final double shadowOpacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height+3,
      child: Stack(
        children: [
          // Shadow
          Positioned(
            left: 5,
            bottom: 5,
            child: Container(
              width: width == 0 ? getWidth(context) - 32 : width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 2,
                    color: Colors.black.withOpacity(shadowOpacity),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          // Button
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Material(
              color: color,
              child: InkWell(
                splashColor: Colors.white.withOpacity(0.3),
                splashFactory: InkRipple.splashFactory,
                onTap: onTap,
                child: Container(
                  width: width == 0 ? getWidth(context) - 32 : width,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget,
                      Center(
                        child: isLoading
                            ? CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.2),
                        ).animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        ).scaleXY(duration: 500.ms, begin: 0.2, end: 0.6)
                            : Text(
                          text,
                          style: TextStyle(
                            color: textColor,
                            fontSize: textSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
