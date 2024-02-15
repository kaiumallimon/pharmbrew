import 'package:flutter/cupertino.dart';

void _scrollToTop(ScrollController _scrollController) {
  _scrollController.animateTo(
    0.0,
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );
}