import "package:flutter/material.dart";
import 'dart:ui';

import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:provider/provider.dart';

import 'package:arrival/states/app_state.dart';

import 'package:arrival/constants.dart';

class HiCardsInkWell extends StatelessWidget {

  var onTap;
  var onLongPress;
  Widget? child;
  Color? color;
  BorderRadius? borderRadius;
  HiCardsInkWell({this.onTap, this.borderRadius, this.onLongPress, this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      highlightColor: color ?? Colors.white.withOpacity(.3),
      splashColor: Colors.transparent,
      onLongPress: onLongPress,
      child: child
    );
  }

}

class HiCardsButton extends StatefulWidget {
  var onTap;
  String? title;
  IconData? icon;
  HiCardsButton({this.onTap, this.icon, this.title});
  @override
  _HiCardsButton createState() => _HiCardsButton();
}

class _HiCardsButton extends State<HiCardsButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(6),
        child: HiCardsInkWell(
          color: Colors.black.withOpacity(.1),
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: EdgeInsets.only(right:10, left: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, color: Theme.of(context).unselectedWidgetColor, size: 18),
                  SizedBox(width: 5),
                  Text(widget.title.toString(), style: TextStyle(color: Theme.of(context).unselectedWidgetColor, fontSize: 15, fontWeight: FontWeight.w500),)
                ],
              ),
            )
        ),
      ),
    );
  }

}

class HiCardsGradientButton extends StatefulWidget {
  var onTap;
  String? title;
  IconData? icon;
  Gradient? gradient;
  HiCardsGradientButton({this.onTap, this.icon, this.title, this.gradient});
  @override
  _HiCardsGradientButton createState() => _HiCardsGradientButton();
}

class _HiCardsGradientButton extends State<HiCardsGradientButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        gradient: widget.gradient
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: EdgeInsets.only(right:10, left: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, color: Colors.white, size: 19),
                  SizedBox(width: 5),
                  Text(widget.title.toString(), style: TextStyle(color: Colors.white),)
                ],
              ),
            )
        ),
      ),
    );
  }

}

class GradientIcon extends StatelessWidget {
  GradientIcon(
      this.icon,
      this.size,
      this.gradient,
      );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}

class GradientLinearProgressIndicator extends StatelessWidget {
  GradientLinearProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: MediaQuery.of(context).size.width.toDouble(),
        height: 2,
        child: LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          backgroundColor: Colors.white.withOpacity(.5),
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, MediaQuery.of(context).size.width.toDouble(), 2);
        return LinearGradient(
            colors: [
              appColors['gradients'][0][1].withOpacity(.8),
              appColors['gradients'][0][0].withOpacity(.8),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            stops: [0, 1],
            tileMode: TileMode.clamp
        ).createShader(rect);
      },
    );
  }
}