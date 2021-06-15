import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simpret/models/product_model.dart';
import 'package:simpret/providers/cart_provider.dart';
import 'package:simpret/providers/product_provider.dart';

class ProductWidget extends StatefulWidget {
  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  late ProductProvider _productProvider;
  late CartProvider _cartProvider;
  late Set<String> _categories = new Set<String>();
  bool isProductRefreshing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this._productProvider =
        Provider.of<ProductProvider>(context);
    this
        ._productProvider
        .products
        .forEach((product) => _categories.add(product.category));
    print("_ProductWidgetState");
    this._cartProvider = Provider.of<CartProvider>(context, listen: false);
    return DefaultTabController(
      length: this._categories.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            isProductRefreshing
                ? Container()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: IconButton(icon: Icon(
                      Icons.cloud_download,
                      color: Colors.white,
                    ), onPressed: () async {
                      await this._productProvider.getProducts();
                    },),
                  ),
          ],
          title: TitleWidget(),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            tabs: this
                ._categories
                .map(
                  (category) => Tab(
                    text: category.toUpperCase(),
                  ),
                )
                .toList(),
          ),
        ),
        body: TabBarView(
          children: this._categories.map((_category) {
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      childAspectRatio: 4 / 3,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1),
                  cacheExtent: 2000,
                  itemCount: this
                      ._productProvider
                      .products
                      .where((product) => product.category == _category)
                      .toList()
                      .length,
                  itemBuilder: (context, index) {
                    ProductModel _productModel = this
                        ._productProvider
                        .products
                        .where((product) => product.category == _category)
                        .toList()[index];
                    return SingleProductWidget(
                      currentState: this
                              ._cartProvider
                              .cartitems
                              .containsKey(_productModel.id)
                          ? true
                          : false,
                      isSelected: (bool value) {
                        if (value) {
                          this._cartProvider.addToCart(_productModel);
                        } else {
                          this._cartProvider.removeCartItem(_productModel.id);
                        }
                      },
                      key: Key(_productModel.id.toString()),
                      productModel: _productModel,
                    );
                  }),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TitleWidget extends StatelessWidget {
  late CartProvider cartProvider;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartProvider>(context);
    count = cartProvider.cartitems.length;
    return Center(
      child: count == 0
          ? Text(
              "balki",
              style: GoogleFonts.righteous(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    letterSpacing: 10),
              ),
            )
          : Text(
              "$count Selected",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
    );
  }
}

class SingleProductWidget extends StatefulWidget {
  final ProductModel productModel;
  final Key key;
  final ValueChanged<bool> isSelected;
  final bool currentState;

  SingleProductWidget(
      {required this.productModel,
      required this.isSelected,
      required this.key,
      required this.currentState});

  @override
  _SingleProductWidgetState createState() =>
      _SingleProductWidgetState(this.currentState);
}

class _SingleProductWidgetState extends State<SingleProductWidget> {
  bool isSelected = false;
  Color backgroundColor = Colors.white, textColor = Colors.black54;
  _SingleProductWidgetState(this.isSelected);
  @override
  Widget build(BuildContext context) {
    print("SingleProductWidget");
    return InkResponse(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      },
      child: Stack(
        children: [
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Text(
                      widget.productModel.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: this.textColor),
                    ),
                  ),
                  Divider(
                    height: 2,
                    thickness: 1,
                    color: this.textColor,
                  ),
                  Text(
                    NumberFormat.currency(locale: 'HI', symbol: "₹")
                            .format(this.widget.productModel.unitPrice) +
                        " per " +
                        this.widget.productModel.unitName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: this.textColor,
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: this.backgroundColor,
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
          isSelected
              ? Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green.withOpacity(0.4),
                      size: 100,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
