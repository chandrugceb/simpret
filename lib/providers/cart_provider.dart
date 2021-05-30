import 'package:flutter/cupertino.dart';
import 'package:simpret/models/cart_model.dart';
import 'package:simpret/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CartProvider extends ChangeNotifier {
  Map<int, CartModel> cartitems = new Map();
  void addToCart(ProductModel productModel) {
    if (!cartitems.containsKey(productModel.id)) {
      cartitems[productModel.id] =
          new CartModel(productModel: productModel, qty: 1);
    }
    notifyListeners();
  }

  void editCartItemQty(int id, double qty) {
    if (cartitems.containsKey(id)) {
      cartitems[id]!.qty = qty;
    }
    notifyListeners();
  }

  void editCartItemUnitPrice(int id, double unitPrice) {
    if (cartitems.containsKey(id)) {
      cartitems[id]!.productModel.unitPrice = unitPrice;
    }
    notifyListeners();
  }

  void editCartItemPrice(int id, double itemPrice) {
    if (cartitems.containsKey(id)) {
      cartitems[id]!.qty = double.parse(
          (itemPrice / cartitems[id]!.productModel.unitPrice)
              .toStringAsPrecision(2));
    }
    notifyListeners();
  }

  void removeCartItem(int id) {
    cartitems.remove(id);
    notifyListeners();
  }

  double getTotal() {
    double total = 0;
    cartitems.forEach((key, value) {
      total = total + (value.productModel.unitPrice * value.qty);
    });
    return total;
  }

  void clearCart() {
    cartitems.clear();
    notifyListeners();
  }

  List<Map> toJsonWithParams(
      {required int transId, required String phone, required String mode, required double amountPaid}) {
    List<Map> result = [];
    cartitems.forEach((key, cartModel) {
      result.add(cartModel.toJsonWithParams(
          transId: transId, phone: phone, mode: mode, amountPaid: amountPaid));
    });
    print(result);
    return result;
  }

  Future<String> submitCart(
      {required String phone, required String mode, required double amountPaid}) async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    final response = await http.post(
      Uri.parse(
          'https://script.google.com/macros/s/AKfycbz-ZsZl2bBIpc2mGTSLNHt0ad-vDYbz90NQrH1r3h24BAMQMzgxWt_2Mu-ks1sQlx4Q/exec'),
      headers: <String, String>{
        "accept": "application/json",
        "content-Type": "application/json",
        "cache-control": "no-cache",
        "postman-token": "145cb441-29d8-c8da-4ccd-115064628e4c2f",
        "User-Agent":
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36"
      },
      body: convert.jsonEncode(<String, dynamic>{
        'payload':
            toJsonWithParams(transId: timeStamp, phone: phone, mode: mode, amountPaid: amountPaid),
      }),
    );

    if (response.statusCode == 201) {
      return "Transaction $timeStamp submitted Successfully";
    }
    if (response.statusCode == 200) {
      print(response.body);
      return "Transaction $timeStamp submitted Successfully";
    }
    if (response.statusCode == 302) {
      print(response.body);
      return "Transaction $timeStamp submitted Successfully";
    }
    print(response.body);
    throw Exception('Failed to submit Transaction.');
  }
}
