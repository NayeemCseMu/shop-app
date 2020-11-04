import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import '../../add_new_product/new_data_screen.dart';

class ManageItems extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  ManageItems({this.title, this.imgUrl, this.id});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, NewProduct.routeName, arguments: id);
            print(id);
          },
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.network(
              imgUrl,
              height: 100,
              width: 100,
            ),
          ),
          title: Text(title.toUpperCase()),
          subtitle: Text('click to edit item'),
          trailing: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.black54,
                ),
                onPressed: () async {
                  try {
                    return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Delete Item!'),
                              content:
                                  Text('Do you want to delete this product?'),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text('NO')),
                                FlatButton(
                                    onPressed: () async {
                                      await Provider.of<Products>(context,
                                              listen: false)
                                          .deleteProductItem(id);
                                      scaffold.showSnackBar(
                                        SnackBar(
                                          content: Text('Deleted item'),
                                        ),
                                      );
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text('YES')),
                              ],
                            ));
                  } on Exception catch (e) {
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                }),
          ),
        ),
        Divider(height: 0, color: Colors.black54),
      ],
    );
  }
}
