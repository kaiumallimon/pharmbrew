import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorDialog extends StatefulWidget {
  final String errorMessage;

  const ErrorDialog({super.key, required this.errorMessage});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<ErrorDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _createController();
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
              width: 100,
              height: 100,
              child: Lottie.asset(
                'assets/animations/error.json',
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
                widget.errorMessage,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CupertinoColors.activeBlue,
              ),
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
            ),
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
