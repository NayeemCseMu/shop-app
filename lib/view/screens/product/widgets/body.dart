import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/utilis/constants.dart';
import 'package:shop_app/view/screens/product/widgets/product_grid.dart';
import 'package:shop_app/view/screens/product/widgets/products_page.dart';

import '../../../../provider/products.dart';

class Body extends StatefulWidget {
  final bool isFav;
  Body(this.isFav);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  String categoryText = 'All';
  PageController _pageController;
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      _pageController = PageController(
          initialPage: currentPage, keepPage: true, viewportFraction: 1.0);
    }
    isInit = false;
    super.didChangeDependencies();
  }

// @override
//   void initState() {
//     _pageController = PageController(initialPage: currentPage);
//     super.initState();
//   }
  void _handlePageChanged(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    print('building....');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            children: List.generate(
              categoryList.length,
              (index) => buildTabItem(index),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: PageView.builder(
              controller: _pageController,
              itemCount: categoryList.length,
              onPageChanged: (value) {
                Provider.of<Products>(context, listen: false)
                    .selectedTabItem(value);
              },
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ProductsPages(
                    dataFetch: 'Men',
                    isFav: widget.isFav,
                  );
                }
                return ProductsGridPages(
                  dataFetch: categoryList[index],
                  isFav: widget.isFav,
                );
              }),
        ),
      ],
    );
  }

  Widget buildTabItem(int index) {
    // final prod = Provider.of<Products>(context, listen: false);
    print('object....');
    return Consumer<Products>(
      builder: (context, prod, _) => GestureDetector(
        onTap: () {
          prod.selectedTabItem(index);
          _handlePageChanged(index);
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                categoryList[index],
                style: TextStyle(
                    fontSize: prod.selectedTabIndex == index ? 20 : 18,
                    color: prod.selectedTabIndex == index
                        ? Colors.black
                        : Colors.black54,
                    fontWeight: prod.selectedTabIndex == index
                        ? FontWeight.w600
                        : FontWeight.w500),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: EdgeInsets.only(top: 5),
              height: 2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: prod.selectedTabIndex == index
                      ? Colors.green
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(5)),
            ),
          ],
        ),
      ),
    );
  }
}
