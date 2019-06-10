import 'dart:convert';

List<Mlab> mlabFromJson(String str) => new List<Mlab>.from(json.decode(str).map((x) => Mlab.fromJson(x)));

String mlabToJson(List<Mlab> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class Mlab {
    Id id;
    String userName;
    String purpose;

    Mlab({
        this.id,
        this.userName,
        this.purpose,
    });

    factory Mlab.fromJson(Map<String, dynamic> json) => new Mlab(
        id: Id.fromJson(json["_id"]),
        userName: json["user_name"],
        purpose: json["purpose"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id.toJson(),
        "user_name": userName,
        "purpose": purpose,
    };
}

class Id {
    String oid;

    Id({
        this.oid,
    });

    factory Id.fromJson(Map<String, dynamic> json) => new Id(
        oid: json["\u0024oid"],
    );

    Map<String, dynamic> toJson() => {
        "\u0024oid": oid,
    };
}
