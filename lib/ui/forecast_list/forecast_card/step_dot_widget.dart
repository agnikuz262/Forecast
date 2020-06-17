import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StepDotWidget extends StatelessWidget {
  final bool selected;
  final Color color;
  final double radius;

  const StepDotWidget(this.selected, {Key key, this.color, this.radius = 12.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 4),
        width: radius,
        height: radius,
        decoration: BoxDecoration(
            color: color == null
                ? selected
                    ?  Color.fromRGBO(50, 130, 209, 1.0)
                    : Color.fromRGBO(229, 229, 229, 1)
                : color,
            borderRadius: BorderRadius.circular(16)));
  }
}
