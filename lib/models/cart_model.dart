import 'package:simpret/models/product_model.dart';

class CartModel {
  ProductModel productModel;
  double qty;
  CartModel({
    required this.productModel,
    required this.qty,
  });

  Map toJsonWithParams(
      {required int transId, required String phone, required String mode, required double amountPaid }) {
    return productModel.toJsonWithParams(
        transId: transId,
        qty: qty,
        total: productModel.unitPrice * qty,
        phone: phone,
        mode: mode,
        amountPaid : amountPaid);
  }
}
