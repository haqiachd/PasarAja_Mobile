class ProductHistoriesEntity {
  final int? idDetail;
  final int? idTrx;
  final int? idProduct;
  final int? quantity;
  final int? totalPrice;
  final DateTime? takenDate;
  final String? status;
  final DateTime? createdAt;
  final String? productName;
  final String? fullName;
  final String? email;
  final String? photo;

  ProductHistoriesEntity({
    this.idDetail,
    this.idTrx,
    this.idProduct,
    this.quantity,
    this.totalPrice,
    this.takenDate,
    this.status,
    this.createdAt,
    this.fullName,
    this.productName,
    this.email,
    this.photo,
  });
}
