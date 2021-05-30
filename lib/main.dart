import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simpret/providers/cart_provider.dart';
import 'package:simpret/providers/product_provider.dart';
import 'package:simpret/widgets/home_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CartProvider cartProvider = new CartProvider();
  ProductProvider productProvider = new ProductProvider();
  bool isLoading = true;
  static const spinkit = SpinKitRotatingCircle(
    color: Colors.white,
    size: 100.0,
  );

  @override
  void initState() {
    loadProducts();
    super.initState();
  }

  void loadProducts() async {
    productProvider.getProductsFromCache();
    isLoading = false;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Built with isLoading $isLoading");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoading
          ? loading()
          : MultiProvider(
              providers: [
                ListenableProvider<CartProvider>(
                    create: (context) => cartProvider),
                ListenableProvider<ProductProvider>(
                    create: (context) => productProvider),
              ],
              child: HomeWidget(),
            ),
    );
  }

  Widget loading() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Center(
        child: spinkit,
        ),
    );
  }
}
