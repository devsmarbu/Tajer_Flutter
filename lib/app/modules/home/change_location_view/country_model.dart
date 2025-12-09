import 'package:intl/intl.dart';

class CountryModel {
  final int? pageCount;
  final List<Result>? results;

  CountryModel({this.pageCount, this.results});

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    pageCount: json["pageCount"],
    results: json["results"] == null
        ? []
        : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageCount": pageCount,
    "results": results == null
        ? []
        : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Result {
  final int? id;
  final String? text;

  Result({this.id, this.text});

  factory Result.fromJson(Map<String, dynamic> json) =>
      Result(id: json["id"], text: json["text"]);

  Map<String, dynamic> toJson() => {"id": id, "text": text};
}

class CountrySelectModel {
  final int? status;
  final String? msg;

  CountrySelectModel({this.status, this.msg});

  factory CountrySelectModel.fromJson(Map<String, dynamic> json) =>
      CountrySelectModel(status: json["status"],msg: "msg");

  Map<String, dynamic> toJson() => {"status": status, "msg": msg};
}
