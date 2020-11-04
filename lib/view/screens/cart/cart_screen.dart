import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/landing_page.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/utilis/constants.dart';
import 'widgets/total_count_header.dart';
import 'widgets/cart_item.dart' show CartItemProduct;

class CartOverViewScreen extends StatelessWidget {
  static const String routeName = '/cart_screen';

  Future<void> _refreshPage(BuildContext context) async {
    await Provider.of<Cart>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TotalCountHeader(),
          FutureBuilder(
              future: _refreshPage(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error'),
                  );
                }

                return Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: RefreshIndicator(
                    onRefresh: () => _refreshPage(context),
                    child: Consumer<Cart>(
                      builder: (context, cart, _) {
                        final cartItem = cart.cartItems.values.toList();
                        if (cartItem.isEmpty) {
                          return emptyCartMessage(context);
                        }
                        return ListView.builder(
                          itemCount: cart.cartItems.length,
                          itemBuilder: (context, index) {
                            // final i = snapshot.data[index];
                            // print(i);
                            return CartItemProduct(
                                id: cartItem[index].id,
                                cartItemKey:
                                    cart.cartItems.keys.toList()[index],
                                title: cartItem[index].title,
                                imgUrl: cartItem[index].imgUrl,
                                price: cartItem[index].price,
                                quantity: cartItem[index].quantity);
                          },
                        );
                      },
                    ),
                  ),
                ));
              })
        ],
      ),
    );
  }

  Widget emptyCartMessage(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/emptycart.png',
            height: 150,
          ),
          OutlineButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, LandingPage.routeName);
            },
            child: Text(
              'Continue Shopping'.toUpperCase(),
              style: kTextStyleButton,
            ),
          ),
        ],
      ),
    );
  }
}
