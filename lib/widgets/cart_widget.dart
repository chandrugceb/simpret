import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simpret/models/cart_model.dart';
import 'package:simpret/providers/cart_provider.dart';

// ignore: must_be_immutable
class CartWidget extends StatelessWidget {
  late CartProvider cartProvider;
  bool enableButtons = true;

  @override
  Widget build(BuildContext contextCartWidget) {
    cartProvider = Provider.of<CartProvider>(contextCartWidget);
    if (cartProvider.cartitems.length == 0) {
      enableButtons = false;
    } else {
      enableButtons = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "balki",
            style: GoogleFonts.righteous(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  letterSpacing: 10),
            ),
          ),
        ),
      ),
      floatingActionButton: !enableButtons
          ? Container()
          : Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 31),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(
                      onPressed: () {
                        this.cartProvider.clearCart();
                      },
                      child: Icon(Icons.remove_shopping_cart),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: () {
                      showDialog(
                          context: contextCartWidget,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: RichText(
                                    text: TextSpan(
                                        text: "Submit Cart",
                                        style: TextStyle(
                                            color: Colors.deepOrange,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold))),
                                content: CartSubmissionWidget(
                                    contextCartWidget: contextCartWidget));
                          });
                    },
                    child: Icon(Icons.add_shopping_cart),
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 12,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: this.cartProvider.cartitems.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    this.cartProvider.removeCartItem(
                        this.cartProvider.cartitems.keys.toList()[index]);
                  },
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: contextCartWidget,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: RichText(
                                text: TextSpan(
                                    text: this
                                        .cartProvider
                                        .cartitems
                                        .values
                                        .toList()[index]
                                        .productModel
                                        .name,
                                    style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold))),
                            content: CartItemEditWidget(
                                cartModel: this
                                    .cartProvider
                                    .cartitems
                                    .values
                                    .toList()[index],
                                contextCartWidget: contextCartWidget),
                          );
                        },
                      );
                    },
                    child: CartItemWidget(
                        cartModel:
                            this.cartProvider.cartitems.values.toList()[index]),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[700],
              ),
              child: Center(
                child: Text(
                  NumberFormat.currency(locale: 'HI', symbol: "₹")
                      .format(this.cartProvider.getTotal()),
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CartItemWidget extends StatelessWidget {
  late CartModel cartModel;
  CartItemWidget({required this.cartModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.cartModel.productModel.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    NumberFormat.currency(locale: 'HI', symbol: "₹")
                            .format(this.cartModel.productModel.unitPrice) +
                        " per " +
                        this.cartModel.productModel.unitName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(this.cartModel.qty.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                )),
                            Text(this.cartModel.productModel.unitName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                )),
                          ],
                        )),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "₹" +
                            (this.cartModel.productModel.unitPrice *
                                    this.cartModel.qty)
                                .toStringAsFixed(0),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue[800]),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CartItemEditWidget extends StatefulWidget {
  CartModel cartModel;
  BuildContext contextCartWidget;
  late CartProvider cartProvider;
  final textStyle = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 30, color: Colors.blue[900]);
  CartItemEditWidget(
      {required this.cartModel, required this.contextCartWidget});
  @override
  _CartItemEditWidgetState createState() => _CartItemEditWidgetState();
}

class _CartItemEditWidgetState extends State<CartItemEditWidget> {
  final _formKey = GlobalKey<FormState>();
  double _unitPrice = 0;
  double _qty = 0;
  final unitPriceController = TextEditingController();
  final qtyController = TextEditingController();
  final totalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.cartProvider =
        Provider.of<CartProvider>(widget.contextCartWidget, listen: false);
    _unitPrice = widget.cartModel.productModel.unitPrice;
    _qty = widget.cartModel.qty;
    unitPriceController.text = _unitPrice.toStringAsFixed(2);
    qtyController.text = _qty.toStringAsFixed(2);
    totalController.text = (_unitPrice * _qty).toStringAsFixed(1);
    print("initStat initiated");
  }

  @override
  void dispose() {
    super.dispose();
    unitPriceController.dispose();
    qtyController.dispose();
    totalController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextFormField(
                  controller: unitPriceController,
                  keyboardType: TextInputType.number,
                  style: widget.textStyle.copyWith(fontSize: 20),
                  decoration: const InputDecoration(
                    labelText: 'Unit Price',
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    prefix: Text("₹"),
                  ),
                  validator: numberValidator,
                  onTap: () => unitPriceController.selection = TextSelection(baseOffset: 0, extentOffset: unitPriceController.value.text.length),
                  onChanged: (value) {
                    if (_formKey.currentState!.validate()) {
                      totalController.text = (double.parse(value) *
                              double.parse(qtyController.text))
                          .toStringAsFixed(2);
                    }
                  },
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  style: widget.textStyle.copyWith(fontSize: 20),
                  decoration: const InputDecoration(
                    labelText: 'Qty',
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  validator: numberValidator,
                  onTap: () => qtyController.selection = TextSelection(baseOffset: 0, extentOffset: qtyController.value.text.length),
                  onChanged: (value) {
                    if (_formKey.currentState!.validate()) {
                      totalController.text = (double.parse(value) *
                              double.parse(unitPriceController.text))
                          .toStringAsFixed(2);
                    }
                  },
                ),
              ),
            ],
          ),
          Center(
            child: TextFormField(
              controller: totalController,
              keyboardType: TextInputType.number,
              style: widget.textStyle,
              decoration: const InputDecoration(
                labelText: 'Total',
                prefix: Text("₹"),
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              validator: numberValidator,
              onTap: () => totalController.selection = TextSelection(baseOffset: 0, extentOffset: totalController.value.text.length),
              onChanged: (value) {
                if (_formKey.currentState!.validate()) {
                  qtyController.text =
                      (double.parse(value) / _unitPrice).toStringAsFixed(2);
                }
              },
            ),
          ),
          new Container(
              padding: const EdgeInsets.only(top: 40.0),
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text('Save',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.cartProvider.editCartItemQty(
                          widget.cartModel.productModel.id,
                          double.parse(qtyController.text));
                      widget.cartProvider.editCartItemUnitPrice(
                          widget.cartModel.productModel.id,
                          double.parse(unitPriceController.text));
                      Navigator.pop(context);
                    }
                  },
                ),
              )),
        ],
      ),
    );
  }

  String? numberValidator(String? value) {
    if (value == null || value.isEmpty || value == "0") {
      return "InValid Number";
    }
    return null;
  }
}

// ignore: must_be_immutable
class CartSubmissionWidget extends StatefulWidget {
  BuildContext contextCartWidget;
  late CartProvider cartProvider;
  final textStyle = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 30, color: Colors.blue[900]);
  CartSubmissionWidget({required this.contextCartWidget});
  @override
  _CartSubmissionWidgetState createState() => _CartSubmissionWidgetState();
}

class _CartSubmissionWidgetState extends State<CartSubmissionWidget> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final amountPaidController = TextEditingController();
  static const spinkit = SpinKitRotatingCircle(
    color: Colors.blue,
    size: 50.0,
  );

  var isLoading = false;

  @override
  void initState() {
    super.initState();
    widget.cartProvider =
        Provider.of<CartProvider>(widget.contextCartWidget, listen: false);
    amountPaidController.text =
        widget.cartProvider.getTotal().toStringAsFixed(2);
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    amountPaidController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              style: widget.textStyle.copyWith(fontSize: 30),
              decoration: const InputDecoration(
                labelText: 'Phone',
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                icon: Icon(Icons.phone),
              ),
              validator: phoneValidator,
            onTap: () => phoneController.selection = TextSelection(baseOffset: 0, extentOffset: phoneController.value.text.length),
            ),
            TextFormField(
              controller: amountPaidController,
              keyboardType: TextInputType.number,
              style: widget.textStyle.copyWith(fontSize: 40),
              decoration: const InputDecoration(
                labelText: 'Amount Paid',
                hintText: 'Enter Amount Paid',
                prefix: Text("₹"),
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              validator: numberValidator,
              onTap: () => amountPaidController.selection = TextSelection(baseOffset: 0, extentOffset: amountPaidController.value.text.length),
            ),
          new Container(
              padding: const EdgeInsets.only(top: 40.0),
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text('Submit',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      try {
                        widget.cartProvider
                            .submitCart(
                                phone: phoneController.text,
                                mode: (amountPaidController.text ==
                                        widget.cartProvider
                                            .getTotal()
                                            .toStringAsFixed(2))
                                    ? "cash"
                                    : "loan",
                                amountPaid:
                                    double.parse(amountPaidController.text))
                            .then((value) {
                          widget.cartProvider.clearCart();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                value,
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                      }

                      setState(() {
                        isLoading = true;
                      });
                    }
                  },
                ),
              )),
          isLoading ? loading() : Container(),
        ],
      ),
    );
  }

  String? numberValidator(String? value) {
    if (value == null || value.isEmpty || value == "0") {
      return "InValid Number";
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (value.length != 10) {
      return "Enter 10 digit mobile number";
    }
    return null;
  }

  Widget loading() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: spinkit,
      ),
    );
  }
}
