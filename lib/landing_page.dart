import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/view/screens/cart/cart_screen.dart';
import 'package:shop_app/view/screens/product/product_screen.dart';
import 'view/reusable-widget/counter_holder.dart';

class LandingPage extends StatefulWidget {
  static const String routeName = '/landing_screen';

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int currentPage = 0;
  PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(initialPage: currentPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Products>(context);
    void _handPageView(int index) {
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }

    void _navItem(int index) {
      Provider.of<Products>(context, listen: false).selectedNavItem(index);
      _handPageView(index);
    }

    return Scaffold(
      body: PageView.builder(
          controller: _pageController,
          itemCount: _pages.length,
          onPageChanged: (value) {
            Provider.of<Products>(context, listen: false)
                .selectedNavItem(value);
          },
          itemBuilder: (context, index) {
            return _pages[index];
          }),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: Offset(0, -3),
              blurRadius: 20,
              color: Color.fromRGBO(32, 32, 32, 0.09))
        ]),
        child: BottomNavigationBar(
          currentIndex: prod.selectedIndex,
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: Colors.black54,
          type: BottomNavigationBarType.shifting,
          elevation: 10.0,
          onTap: _navItem,
          items: _listOfBottomNavItem(),
        ),
      ),
    );
  }

  List<Widget> _pages = [ProductScreen(), CartOverViewScreen()];

  List<BottomNavigationBarItem> _listOfBottomNavItem() {
    return [
      BottomNavigationBarItem(
        label: 'Home',
        icon: Icon(
          Icons.home_outlined,
          size: 30.0,
        ),
      ),
      BottomNavigationBarItem(
        label: 'Cart',
        icon: Consumer<Cart>(
            builder: (context, cart, ch) => CartCounter(
                  value: cart.itemCount,
                  child: ch,
                ),
            child: Icon(
              Icons.shopping_cart_sharp,
              size: 35.0,
            )),
      ),
    ];
  }
}
