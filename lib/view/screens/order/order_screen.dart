import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/order.dart';
import 'package:shop_app/utilis/constants.dart';
import '../../reusable-widget/drawer.dart';

class OrderOverViewScreen extends StatelessWidget {
  static const String routeName = '/order_screen';

  @override
  Widget build(BuildContext context) {
    print('building');

    return Scaffold(
        appBar: AppBar(
          title: Text('Your Order'),
          centerTitle: true,
        ),
        drawer: MyDrawer(),
        body: FutureBuilder(
          future: Provider.of<Order>(context, listen: false).fetchOrder(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('An error is occured'),
              );
            } else {
              return Consumer<Order>(
                builder: (context, order, child) => ListView.builder(
                    itemCount: order.orderItem.length,
                    itemBuilder: (context, index) {
                      return OrderItemScreen(
                        orderItem: order.orderItem[index],
                      );
                    }),
              );
            }
          },
        ));
  }
}

class OrderItemScreen extends StatelessWidget {
  final OrderItem orderItem;

  OrderItemScreen({this.orderItem});
  @override
  Widget build(BuildContext context) {
    var cnt = 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: ExpansionTile(
          childrenPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          title: Text(
            'Total:   \$${orderItem.totalAmount}',
            style: kTextStyleTitle,
          ),
          subtitle: Text(DateFormat('yMMMMd').format(orderItem.dateTime)),
          children: [
            ...orderItem.cartProducts
                .map((prod) => borderContainer(
                      childWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.orange[50],
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                                '${cnt++}:\t ${prod.title}'.toUpperCase(),
                                style: kTextStyleButton),
                          ),
                          SizedBox(height: 10),
                          Container(
                            color: Colors.grey[200],
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Row(
                              children: [
                                buildExpanded(
                                  text: '${prod.quantity}',
                                ),
                                buildExpanded(
                                  text: '${prod.price}',
                                ),
                                buildExpanded(
                                  text: '\$ ${prod.price * prod.quantity}',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ))
                .toList(),
          ]),
    );
  }

  Widget buildExpanded({String text}) {
    return Expanded(
        child: borderContainer(
      childWidget: Text(
        text,
        textAlign: TextAlign.center,
        style: kTextStyleButton,
      ),
    ));
  }

  Widget borderContainer({Widget childWidget}) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(width: 1.0, color: Colors.black)),
      child: childWidget,
    );
  }
}
