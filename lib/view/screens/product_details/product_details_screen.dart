import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/utilis/constants.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String routeName = '/product_details_screen';

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
    final productId = ModalRoute.of(context).settings.arguments;
    final loadedProduct =
        Provider.of<Products>(context).findById(id: productId);
    // final authData = Provider.of<Auth>(context);

    final cart = Provider.of<Cart>(context);

    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(title: Text(loadedProduct.title.toUpperCase())),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: loadedProduct.id,
              child: Image.network(
                loadedProduct.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),
            // Text(product.creator),
            SizedBox(height: 20),
            Chip(
              label: Text('\$${loadedProduct.price}',
                  textAlign: TextAlign.center,
                  style: kTextStyleTitle.copyWith(
                      color: Colors.brown, fontSize: 24)),
            ),
            SizedBox(height: 20),
            Text(
              loadedProduct.description,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await cart.addItems(
              context: context,
              productId: loadedProduct.id,
            );
            scaffoldState.currentState.removeCurrentSnackBar();
            scaffoldState.currentState.showSnackBar(
              SnackBar(
                content: Text('added to cart'),
              ),
            );
          } on Exception catch (e) {
            scaffoldState.currentState.removeCurrentSnackBar();
            scaffoldState.currentState.showSnackBar(
              SnackBar(
                content: Text(e.toString()),
              ),
            );
          }
        },
        child: Icon(Icons.shopping_cart_outlined),
      ),
    );
  }
}
