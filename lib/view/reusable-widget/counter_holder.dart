import 'package:flutter/material.dart';
import 'package:shop_app/utilis/constants.dart';

class CartCounter extends StatelessWidget {
  final Widget child;
  final int value;

  CartCounter({this.child, this.value});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        value == 0
            ? SizedBox()
            : Positioned(
                right: 0.0,
                top: 0.0,
                child: Container(
                  height: 20.0,
                  width: 20.0,
                  padding: EdgeInsets.all(2.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$value',
                    style: kTextStyleButton.copyWith(
                        fontSize: 12, color: Colors.white),
                  ),
                ),
              )
      ],
    );
  }
}
