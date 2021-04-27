import 'dart:convert';

class CheckTransferOrderModel {
  CheckTransferOrderModel({
    this.transfer,
  });

  Transfer transfer;

  factory CheckTransferOrderModel.fromJson(String str) =>
      CheckTransferOrderModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CheckTransferOrderModel.fromMap(Map<String, dynamic> json) =>
      CheckTransferOrderModel(
        transfer: Transfer.fromMap(json["transfer"]),
      );

  Map<String, dynamic> toMap() => {
        "transfer": transfer.toMap(),
      };
}

class Transfer {
  Transfer({
    this.id,
    this.bookbank,
    this.transferDate,
    this.note,
    this.image,
    this.dateCreated,
    this.order,
  });

  int id;
  String bookbank;
  DateTime transferDate;
  String note;
  String image;
  DateTime dateCreated;
  int order;

  factory Transfer.fromJson(String str) => Transfer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Transfer.fromMap(Map<String, dynamic> json) => Transfer(
        id: json["id"],
        bookbank: json["bookbank"],
        transferDate: DateTime.parse(json["transfer_date"]),
        note: json["note"],
        image: json["image"],
        dateCreated: DateTime.parse(json["date_created"]),
        order: json["order"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "bookbank": bookbank,
        "transfer_date": transferDate.toIso8601String(),
        "note": note,
        "image": image,
        "date_created": dateCreated.toIso8601String(),
        "order": order,
      };
}
