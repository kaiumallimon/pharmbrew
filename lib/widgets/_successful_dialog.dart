import 'dart:async';

import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessDialog extends StatefulWidget {
  final String successMessage;

  const SuccessDialog({super.key, required this.successMessage});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<SuccessDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _controller = _createController();
    timer = Timer(Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the dialog after 5 seconds
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Lottie.asset(
                fit: BoxFit.fill,
                'assets/animations/successful.json',
                controller: _controller,
                onLoaded: (composition) {
                  _playAnimationOnce();
                },
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.successMessage,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 10.0),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).pop(); // Close the dialog
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: CupertinoColors.activeBlue,
            //   ),
            //   child: const Text(
            //     'Continue',
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
          ],
        ),
      ),
    ).frosted(blur: 20, borderRadius: BorderRadius.circular(10));
  }

  AnimationController _createController() {
    return AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  void _playAnimationOnce() {
    _controller.forward().whenComplete(() {
      _controller
          .dispose(); // Dispose the controller after animation completion
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }
}

void showCustomSuccessDialog(String successMessage, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return SuccessDialog(successMessage: successMessage);
    },
  );
}
