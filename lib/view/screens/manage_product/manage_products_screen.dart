import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import 'widget/manage_items.dart';
import 'package:shop_app/view/reusable-widget/drawer.dart';
import '../../screens/add_new_product/new_data_screen.dart';

class ManageProduct extends StatelessWidget {
  static const String routeName = '/manage_product_screen';

  Future<void> _refreshPage(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchData('Men', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: FutureBuilder(
          future: _refreshPage(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return RefreshIndicator(
              onRefresh: () => _refreshPage(context),
              child: Consumer<Products>(
                builder: (context, productsData, _) => ListView.builder(
                    itemCount: productsData.items.length,
                    itemBuilder: (context, index) {
                      final productModel = productsData.items[index];
                      return ManageItems(
                          id: productModel.id,
                          title: productModel.title,
                          imgUrl: productModel.imageUrl);
                    }),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, NewProduct.routeName);
        },
        child: Icon(Icons.add, color: Colors.white, size: 25),
      ),
    );
  }
}
