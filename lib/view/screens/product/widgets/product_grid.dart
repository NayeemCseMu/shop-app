import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/view/screens/product/widgets/griditems.dart';

class ProductsGridPages extends StatelessWidget {
  final String dataFetch;
  final bool isFav;

  ProductsGridPages({this.dataFetch, this.isFav});

  Future<void> _refreshPage(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchData(dataFetch);
  }

  @override
  Widget build(BuildContext context) {
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
                  return RefreshIndicator(
                    onRefresh: () => _refreshPage(context),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.71,
                            crossAxisCount:
                                MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? 2
                                    : 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                            value: products[index],
                            child: GridItem(),
                          );
                        }),
                  );
                },
              );
            }
          }),
    );
  }
}
