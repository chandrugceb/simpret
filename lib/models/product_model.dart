class ProductModel {
  int id;
  String name;
  String category;
  double unitPrice;
  String unitName;
  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.unitPrice,
    required this.unitName,
  });

  factory ProductModel.fromJson(dynamic jSON) {
    return ProductModel(
        id: jSON['id'],
        name: jSON['name'],
        category: jSON['category'],
        unitPrice: double.parse(jSON['unitPrice'].toString()),
        unitName: jSON['unitName']);
  }

  Map toJson() => {
    "id": id,
    "name": name,
    "category": category,
    "unitPrice": unitPrice,
    "unitName": unitName
  };

  Map toJsonWithParams({required int transId, required double qty, required double total, required String phone, required String mode, required double amountPaid}) => {
    "transId": "$transId",
    "id": "$id",
    "name": name,
    "category": category,
    "unitPrice": "$unitPrice",
    "unitName": unitName,
    "qty": "$qty",
    "total": "$total",
    "phone": phone,
    "mode": mode,
    "amountPaid": "$amountPaid"
  };
}
