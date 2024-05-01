import 'package:flutter/material.dart';

class OverflowCheckRow extends StatefulWidget {
  final Widget logo;
  final Widget locatedAt;

  const OverflowCheckRow(
      {super.key, required this.logo, required this.locatedAt});

  @override
  _OverflowCheckRowState createState() => _OverflowCheckRowState();
}

class _OverflowCheckRowState extends State<OverflowCheckRow> {
  double logoWidth = 0;
  double locatedAtWidth = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Check if the row's combined width exceeds its parent's width
        double rowWidth = logoWidth + locatedAtWidth;

        // Determine overflow state
        bool isOverflowing = rowWidth > constraints.maxWidth;

        return isOverflowing ? _buildOverflowDesign() : _buildNormalDesign();
      },
    );
  }

  Widget _buildNormalDesign() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [widget.logo, widget.locatedAt],
    );
  }

  Widget _buildOverflowDesign() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.logo,
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.locatedAt,
              ],
            ),
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateWidths();
    });
  }

  void _updateWidths() {
    final RenderBox logoRenderBox = context.findRenderObject() as RenderBox;
    logoWidth = logoRenderBox.size.width;

    final RenderBox locatedAtRenderBox =
        context.findRenderObject() as RenderBox;
    locatedAtWidth = locatedAtRenderBox.size.width;

    setState(() {}); // Trigger rebuild to reflect updated widths
  }
}
