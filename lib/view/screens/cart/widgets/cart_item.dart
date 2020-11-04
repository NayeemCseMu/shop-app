import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/utilis/constants.dart';

class CartItemProduct extends StatelessWidget {
  final String id;
  final String cartItemKey;
  final String title;
  final String imgUrl;
  final double price;
  final int quantity;

  CartItemProduct(
      {this.id,
      this.title,
      this.price,
      this.quantity,
      this.imgUrl,
      this.cartItemKey});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, size: 40, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Delete Item!'),
                  content: Text('Do you want to delete this item?'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('NO')),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('YES')),
                  ],
                ));
      },
      onDismissed: (direction) async {
        try {
          await Provider.of<Cart>(context, listen: false)
              .removerCartItem(cartItemKey);

          scaffold.removeCurrentSnackBar();
          scaffold.showSnackBar(
            SnackBar(
              content: Text('product item deleted'),
            ),
          );
        } on Exception catch (e) {
          scaffold.removeCurrentSnackBar();
          scaffold.showSnackBar(SnackBar(
            content: Text(
              e.toString(),
            ),
          ));
        }
      },
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imgUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    title.toUpperCase(),
                    style: kTextStyleTitle.copyWith(color: Colors.brown),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: kTextStyleTitle.copyWith(color: Colors.black),
                      ),
                      SizedBox(width: 10),
                      Chip(
                          backgroundColor: Colors.black54.withOpacity(0.1),
                          label: Text('$quantity x'))
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Consumer<Cart>(
              builder: (context, cart, child) => Row(
                children: [
                  itemCounterButton(
                      child: Icon(Icons.remove),
                      bl: 5.0,
                      tl: 5.0,
                      press: () {
                        cart.incrementAndDecremebtItemQuantity(
                            cartItemKey, false);
                      }),
                  itemCounterButton(
                    child: Text(
                      quantity.toString().padLeft(2, '0'),
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  itemCounterButton(
                      child: Icon(Icons.add),
                      br: 5.0,
                      tr: 5.0,
                      press: () {
                        cart.incrementAndDecremebtItemQuantity(
                            cartItemKey, true);
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemCounterButton(
      {Widget child,
      Function press,
      double bl = 0,
      double br = 0,
      double tl = 0,
      double tr = 0}) {
    return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(bl),
              bottomRight: Radius.circular(br),
              topLeft: Radius.circular(tl),
              topRight: Radius.circular(tr),
            ),
            color: Colors.orange[50],
            border: Border.all(color: Colors.black, width: 0.5)),
        child: OutlineButton(
          padding: EdgeInsets.zero,
          onPressed: press,
          child: child,
        ));
  }
}
