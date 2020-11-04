import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/order.dart';
import 'package:shop_app/utilis/constants.dart';

class TotalCountHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return Card(
      elevation: 1.0,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Image.network(cart.cartItems{}),

              Consumer<Cart>(
                builder: (context, cart, _) => Chip(
                    backgroundColor: Colors.indigo,
                    label: Text(
                      'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                      style: kTextStyleTitle.copyWith(color: Colors.white),
                    )),
              ),

              Consumer<Cart>(
                builder: (context, cart, _) => RaisedButton.icon(
                  elevation: 3.0,
                  icon: Icon(Icons.shopping_cart_outlined),
                  color: Colors.amber[300],
                  disabledColor: Colors.amber[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  onPressed: cart.cartItems.isEmpty
                      ? null
                      : () async {
                          try {
                            await Provider.of<Order>(context).placeToOrderList(
                                cartProducts: cart.cartItems.values.toList(),
                                amount: cart.totalAmount);  
                            cart.clearCart(cart.cartItems.values.toList());
                          } on Exception catch (e) {
                            scaffold.removeCurrentSnackBar();
                            scaffold.showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          }
                        },
                  label: Text(
                    'Order Now',
                    style: kTextStyleButton.copyWith(
                        color: cart.cartItems.isEmpty
                            ? Colors.black54
                            : Colors.black87),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
