import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/landing_page.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/utilis/constants.dart';
import '../screens/manage_product/manage_products_screen.dart';
import '../screens/order/order_screen.dart';

class MyDrawer extends StatelessWidget {
  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Exit Shop-App'),
              content: Text('Do you want to exit?'),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('NO')),
                FlatButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text('Yes'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(0),
              child: Container(
                height: 100,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/clip-online-shopping.png',
                  fit: BoxFit.contain,
                ),
              )),
          SizedBox(height: 20),
          buildDrawerItem(
            title: 'Shop',
            icon: Icon(
              Icons.shop,
              size: 20,
            ),
            press: () {
              Navigator.pushReplacementNamed(context, LandingPage.routeName);
            },
          ),
          buildDrawerItem(
            title: 'My Order',
            icon: Icon(
              Icons.list_rounded,
              size: 20,
            ),
            press: () {
              Navigator.pushReplacementNamed(
                  context, OrderOverViewScreen.routeName);
            },
          ),
          buildDrawerItem(
            title: 'Manage Products',
            icon: Icon(
              Icons.wb_iridescent,
              size: 20,
            ),
            press: () {
              Navigator.pushReplacementNamed(context, ManageProduct.routeName);
            },
          ),
          buildDrawerItem(
            title: 'Logout',
            icon: Icon(
              Icons.logout,
              size: 20,
            ),
            press: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).signOut();
            },
          ),
          buildDrawerItem(
            title: 'Exit',
            icon: Icon(
              Icons.exit_to_app,
              size: 20,
            ),
            press: () {
              _showDialog(context);
              // SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }

  Widget buildDrawerItem({String title, Icon icon, Function press}) {
    return Column(
      children: [
        ListTile(
            onTap: press,
            leading: icon,
            title: Text(
              title,
              style: kTextStyleButton.copyWith(color: Colors.brown[400]),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15,
            )),
        Divider(
          height: 0,
          color: Colors.black,
          indent: 10,
          endIndent: 20,
        ),
      ],
    );
  }
}
