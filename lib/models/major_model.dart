import 'dart:convert';

List<MajorModel> majorModelFromJson(String str) => List<MajorModel>.from(json.decode(str).map((x) => MajorModel.fromJson(x)));

String majorModelToJson(List<MajorModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MajorModel {
    String id;
    String title;
    String createdAt;
    String updatedAt;

    MajorModel({
        required this.id,
        required this.title,
        required this.createdAt,
        required this.updatedAt,
    });

    factory MajorModel.fromJson(Map<String, dynamic> json) => MajorModel(
        id: json["id"].toString(),
        title: json["title"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };

}
