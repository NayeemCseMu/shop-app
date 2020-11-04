import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/utilis/constants.dart';
import 'product_item.dart';

class ProductsPages extends StatelessWidget {
  final String dataFetch;
  final bool isFav;

  ProductsPages({this.dataFetch, this.isFav});

  Future<void> _refreshPage(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchData(dataFetch);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildTitleText(dataFetch),
          buildReusableDataFetcher(context),
        ],
      ),
    );
  }

  Padding buildTitleText(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title Products',
            style: kTextStyleTitle,
          ),
          Text(
            'See All',
            style: kTextStyleButton.copyWith(color: Colors.brown),
          ),
        ],
      ),
    );
  }

  Padding buildReusableDataFetcher(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: FutureBuilder(
          future: _refreshPage(context),
          builder: (context, snapshot) {
            // print(snapshot.data );
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('An error occured'),
              );
            } else {
              return Consumer<Products>(
                builder: (context, prod, child) {
                  final products = isFav ? prod.favoriteItems : prod.items;
                  return AspectRatio(
                    aspectRatio: 3 / 2,
                    child: RefreshIndicator(
                      onRefresh: () => _refreshPage(context),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return ChangeNotifierProvider.value(
                              value: products[index],
                              child: ProductItem(),
                            );
                          }),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
