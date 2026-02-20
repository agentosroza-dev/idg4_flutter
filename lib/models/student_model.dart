// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:my_students/services/base_url.dart';



StudentModel studentModelFromJson(String str) => StudentModel.fromJson(json.decode(str));

String studentModelToJson(StudentModel data) => json.encode(data.toJson());


class StudentModel {
    String currentPage;
    List<Datum> data;
    String firstPageUrl;
    String from;
    String lastPage;
    String lastPageUrl;
    List<Link> links;
    String nextPageUrl;
    String path;
    String perPage;
    String prevPageUrl;
    String to;
    String total;

    StudentModel({
        required this.currentPage,
        required this.data,
        required this.firstPageUrl,
        required this.from,
        required this.lastPage,
        required this.lastPageUrl,
        required this.links,
        required this.nextPageUrl,
        required this.path,
        required this.perPage,
        required this.prevPageUrl,
        required this.to,
        required this.total,
    });

    factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        currentPage: json["current_page"].toString(),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"].toString(),
        from: json["from"].toString(),
        lastPage: json["last_page"].toString(),
        lastPageUrl: json["last_page_url"].toString(),
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"].toString(),
        path: json["path"].toString(),
        perPage: json["per_page"].toString(),
        prevPageUrl: json["prev_page_url"].toString(),
        to: json["to"].toString(),
        total: json["total"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
    };
}

class Datum {
    String id;
    String name;
    String image;
    String majorId;
    String createdAt;
    String updatedAt;
    Major major;

    Datum({
        required this.id,
        required this.name,
        required this.image,
        required this.majorId,
        required this.createdAt,
        required this.updatedAt,
        required this.major,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"].toString(),
        name: json["name"].toString(),
        image: '${BaseUrl.base}/storage/${json["image"]}',
        majorId: json["major_id"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
        major: Major.fromJson(json["major"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "major_id": majorId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "major": major.toJson(),
    };
}

class Major {
    String id;
    String title;
    String createdAt;
    String updatedAt;

    Major({
        required this.id,
        required this.title,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Major.fromJson(Map<String, dynamic> json) => Major(
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

class Link {
    String url;
    String label;
    String page;
    String active;


    Link({
        required this.url,
        required this.label,
        required this.page,
        required this.active,
    });

    factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"].toString(),
        label: json["label"].toString(),
        page: json["page"].toString(),
        active: json["active"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "page": page,
        "active": active,
    };
}
