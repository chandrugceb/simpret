import 'package:flutter/cupertino.dart';
import 'package:simpret/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> products = [];
  late SharedPreferences pref;

  Future<void> getSharedPrefInstance() async {
    pref = await SharedPreferences.getInstance();
  }

  Future<void> getProducts() async {
    print("getProducts + ${DateTime.now()}");
    await getSharedPrefInstance();
    var uri = Uri.parse(
        "https://script.google.com/macros/s/AKfycbz-ZsZl2bBIpc2mGTSLNHt0ad-vDYbz90NQrH1r3h24BAMQMzgxWt_2Mu-ks1sQlx4Q/exec");
    await http.get(uri).then((resp) {
      saveProducts(resp.body);
    });
  }

  Future<void> getProductsFromCache() async {
    print("getProductsfromCache + ${DateTime.now()}");
    await getSharedPrefInstance();
    if (pref.containsKey("products")) {
      saveProducts(pref.getString("products") ?? "");
    } else {
      await getProducts();
    }
  }

  void saveProducts(String products) {
    print("saveProducts + ${DateTime.now()}");
    this.products.clear();
    pref.setString("products", products);
    List<dynamic> jsonList =
        convert.jsonDecode(pref.getString("products") ?? "");
    jsonList.forEach((jsonProductModel) {
      this.products.add(ProductModel.fromJson(jsonProductModel));
    });
    notifyListeners();
  }
}
