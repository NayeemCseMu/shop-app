import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart.dart';
import '../../../../provider/products_model.dart';
import '../../../../utilis/constants.dart';
import '../../product_details/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductModel>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    final authData = Provider.of<Auth>(context);
    final scaffold = Scaffold.of(context);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ProductDetailsScreen.routeName,
            arguments: product.id);
      },
      child: AspectRatio(
        aspectRatio: 0.71,
        child: Card(
          elevation: 3.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    child: Hero(
                      tag: product.id,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/gif/loading_placeholder.gif',
                        image: product.imageUrl,
                        height: 150,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Consumer<ProductModel>(
                      builder: (context, prod, child) => IconButton(
                        onPressed: () async {
                          try {
                            await prod.toogleFavorite(
                                authData.token, authData.userId);
                          } on Exception catch (e) {
                            scaffold.removeCurrentSnackBar();
                            scaffold.showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          }
                        },
                        icon: Icon(
                          prod.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 25.0,
                        ),
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 10,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                      decoration: BoxDecoration(
                          color: Colors.black54.withOpacity(0.7),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          )),
                      child: Text(
                        '\$${product.price}',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: 10.0),
                title: Text(
                  product.title.toUpperCase(),
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: kTextStyleTitle.copyWith(
                      color: Colors.black, fontSize: 18),
                ),
                trailing: Container(
                  height: 50,
                  padding: EdgeInsets.all(0.0),
                  // decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     border: Border.all(color: Colors.black, width: 1.0)),
                  child: IconButton(
                    onPressed: () async {
                      try {
                        await cart.addItems(
                          context: context,
                          productId: product.id,
                        );
                        scaffold.removeCurrentSnackBar();
                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text('added to cart'),
                          ),
                        );
                      } on Exception catch (e) {
                        scaffold.removeCurrentSnackBar();
                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.add_shopping_cart_rounded,
                      color: Colors.black,
                      size: 30.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
