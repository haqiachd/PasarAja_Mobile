class CreateTransactionModel {
  final int? idShop;
  final int? idUser;
  final String? email;
  final String? takenDate;
  final List<ProductTransactionModel>? products;

  CreateTransactionModel({
    this.idShop,
    this.idUser,
    this.email,
    this.takenDate,
    this.products,
  });

  factory CreateTransactionModel.fromJson(Map<String, dynamic> json) =>
      CreateTransactionModel(
        idShop: json["id_shop"] ?? 0,
        idUser: json["id_user"] ?? 0,
        email: json["email"] ?? '',
        takenDate: json["taken_date"] ?? '',
        products: json["products"] == null
            ? []
            : List<ProductTransactionModel>.from(
                json["products"]!.map(
                  (x) => ProductTransactionModel.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "id_shop": idShop ?? 0,
        "id_user": idUser ?? 0,
        "email": email ?? '',
        "taken_date": takenDate ?? '',
        "products": products == null
            ? []
            : List<dynamic>.from(
                products!.map(
                  (x) => x.toJson(),
                ),
              ),
      };
}

class ProductTransactionModel {
  final int? idProduct;
  final int? quantity;
  final int? promoPrice;
  final String? notes;

  ProductTransactionModel({
    this.idProduct,
    this.quantity,
    this.promoPrice,
    this.notes,
  });

  factory ProductTransactionModel.fromJson(Map<String, dynamic> json) => ProductTransactionModel(
        idProduct: json["id_product"] ?? 0,
        quantity: json["quantity"] ?? 0,
        promoPrice: json["promo_price"] ?? 0,
        notes: json["notes"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id_product": idProduct ?? 0,
        "quantity": quantity ?? 0,
        "promo_price": promoPrice ?? 0,
        "notes": notes ?? '',
      };
}
