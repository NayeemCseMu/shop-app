import 'package:flutter/material.dart';
import 'package:shop_app/view/reusable-widget/drawer.dart';
import 'widgets/body.dart';

enum FilterOption { Favorite, All }

class ProductScreen extends StatefulWidget {
  static const String routeName = '/product_screen';

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _showFav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text('Product'),
          actions: [
            PopupMenuButton(onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.Favorite) {
                  _showFav = true;
                } else {
                  _showFav = false;
                }
              });
            }, itemBuilder: (context) {
              return [
                PopupMenuItem(
                    child: Text('Favorite only'), value: FilterOption.Favorite),
                PopupMenuItem(child: Text('Show all'), value: FilterOption.All),
              ];
            }),
          ],
        ),
        body: Body(_showFav));
  }
}
