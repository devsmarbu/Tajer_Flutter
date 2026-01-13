class SizeChartModel {
  final String? status;
  final String? responseCode;
  final String? msg;
  final SizeChart? data;

  SizeChartModel({
    this.status,
    this.responseCode,
    this.msg,
    this.data,
  });

  factory SizeChartModel.fromJson(Map<String, dynamic> json) => SizeChartModel(
    status: json["status"],
    responseCode: json["responseCode"],
    msg: json["msg"],
    data: json["data"] == null ? null : SizeChart.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "responseCode": responseCode,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class SizeChart {
  final String? currencySymbol;
  final String? totalFavouriteItems;
  final String? totalUnreadMessageCount;
  final String? totalUnreadNotificationCount;
  final String? cartItemsCount;
  final ChartData? chartData;
  final List<TableChartData>? tableChartData;
  final List<MeasurementsJson>? measurementsJson;
  final List<ModelMeasurement>? modelMeasurement;
  final String? sizeChartUrl;
  final String? productTitle;
  final String? productPrice;
  final String? productImage;
  final String? currentStock;
  final String? isOutOfMinOrderQty;
  final String? displayComingsoon;

  SizeChart({
    this.currencySymbol,
    this.totalFavouriteItems,
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.chartData,
    this.measurementsJson,
    this.modelMeasurement,
    this.sizeChartUrl,
    this.productTitle,
    this.productPrice,
    this.productImage,
    this.currentStock,
    this.isOutOfMinOrderQty,
    this.displayComingsoon,
    this.tableChartData
  });

  factory SizeChart.fromJson(Map<String, dynamic> json) => SizeChart(
    currencySymbol: json["currencySymbol"],
    totalFavouriteItems: json["totalFavouriteItems"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    cartItemsCount: json["cartItemsCount"],
    chartData: (json["chartData"] is Map)
        ? ChartData.fromJson(json["chartData"])
        : null,

    measurementsJson: (json["measurements_json"] is List)
        ? List<MeasurementsJson>.from(
        json["measurements_json"].map((x) => MeasurementsJson.fromJson(x)))
        : [],

    tableChartData: (json["tablesdata"] is List)
        ? List<TableChartData>.from(
        json["tablesdata"].map((x) => TableChartData.fromJson(x)))
        : [],

    modelMeasurement: (json["model_measurement"] is List)
        ? List<ModelMeasurement>.from(
        json["model_measurement"].map((x) => ModelMeasurement.fromJson(x)))
        : [],
    sizeChartUrl: json["sizeChartUrl"],
    productTitle: json["productTitle"],
    productPrice: json["productPrice"],
    productImage: json["productImage"],
    currentStock: json["currentStock"],
    isOutOfMinOrderQty: json["isOutOfMinOrderQty"],
    displayComingsoon: json["displayComingsoon"],
  );

  Map<String, dynamic> toJson() => {
    "currencySymbol": currencySymbol,
    "totalFavouriteItems": totalFavouriteItems,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "cartItemsCount": cartItemsCount,
    "chartData": chartData?.toJson(),
    "measurements_json": measurementsJson == null ? [] : List<dynamic>.from(measurementsJson!.map((x) => x.toJson())),
    "model_measurement": modelMeasurement == null ? [] : List<dynamic>.from(modelMeasurement!.map((x) => x.toJson())),
    "sizeChartUrl": sizeChartUrl,
    "productTitle": productTitle,
    "productPrice": productPrice,
    "productImage": productImage,
    "currentStock": currentStock,
    "isOutOfMinOrderQty": isOutOfMinOrderQty,
    "displayComingsoon": displayComingsoon,
  };
}

class ChartData {
  final List<Title>? titles;
  final List<List<ChartValue>>? values;

  ChartData({
    this.titles,
    this.values,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
    titles: json["titles"] == null ? [] : List<Title>.from(json["titles"]!.map((x) => Title.fromJson(x))),
    values: json["values"] == null ? [] : List<List<ChartValue>>.from(json["values"]!.map((x) => List<ChartValue>.from(x.map((x) => ChartValue.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "titles": titles == null ? [] : List<dynamic>.from(titles!.map((x) => x.toJson())),
    "values": values == null ? [] : List<dynamic>.from(values!.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
  };
}

class Title {
  final String? optionId;
  final String? title;

  Title({
    this.optionId,
    this.title,
  });

  factory Title.fromJson(Map<String, dynamic> json) => Title(
    optionId: json["option_id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "option_id": optionId,
    "title": title,
  };
}

class ChartValue {
  final String? valueId;
  final String? value;

  ChartValue({
    this.valueId,
    this.value,
  });

  factory ChartValue.fromJson(Map<String, dynamic> json) => ChartValue(
    valueId: json["value_id"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "value_id": valueId,
    "value": value,
  };
}

class MeasurementsJson {
  final String? title;
  final List<MeasurementsJsonAdjective>? adjectives;

  MeasurementsJson({
    this.title,
    this.adjectives,
  });

  factory MeasurementsJson.fromJson(Map<String, dynamic> json) => MeasurementsJson(
    title: json["title"],
    adjectives: json["adjectives"] == null ? [] : List<MeasurementsJsonAdjective>.from(json["adjectives"]!.map((x) => MeasurementsJsonAdjective.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "adjectives": adjectives == null ? [] : List<dynamic>.from(adjectives!.map((x) => x.toJson())),
  };
}

class MeasurementsJsonAdjective {
  final String? id;
  final String? value;
  final String? selected;

  MeasurementsJsonAdjective({
    this.id,
    this.value,
    this.selected,
  });

  factory MeasurementsJsonAdjective.fromJson(Map<String, dynamic> json) => MeasurementsJsonAdjective(
    id: json["id"],
    value: json["value"],
    selected: json["selected"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
    "selected": selected,
  };
}

class ModelMeasurement {
  final String? title;
  final List<ModelMeasurementAdjective>? adjectives;

  ModelMeasurement({
    this.title,
    this.adjectives,
  });

  factory ModelMeasurement.fromJson(Map<String, dynamic> json) => ModelMeasurement(
    title: json["title"],
    adjectives: json["adjectives"] == null ? [] : List<ModelMeasurementAdjective>.from(json["adjectives"]!.map((x) => ModelMeasurementAdjective.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "adjectives": adjectives == null ? [] : List<dynamic>.from(adjectives!.map((x) => x.toJson())),
  };
}

class ModelMeasurementAdjective {
  final String? id;
  final String? value;
  final String? extra;

  ModelMeasurementAdjective({
    this.id,
    this.value,
    this.extra,
  });

  factory ModelMeasurementAdjective.fromJson(Map<String, dynamic> json) => ModelMeasurementAdjective(
    id: json["id"],
    value: json["value"],
    extra: json["extra"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
    "extra": extra,
  };
}


class TableChartData {
  final String? sctblId;
  final String? sctblName;
  final ChartData? chartData;

  TableChartData({
    this.sctblId,
    this.sctblName,
    this.chartData,
  });

  factory TableChartData.fromJson(Map<String, dynamic> json) => TableChartData(
    sctblId: json["sctbl_id"],
    sctblName: json["sctbl_name"],
    chartData: json["chart_data"] == null ? null : ChartData.fromJson(json["chart_data"]),
  );

  Map<String, dynamic> toJson() => {
    "sctbl_id": sctblId,
    "sctbl_name": sctblName,
    "chart_data": chartData?.toJson(),
  };
}

class Value {
  final String? valueId;
  final String? value;

  Value({
    this.valueId,
    this.value,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    valueId: json["value_id"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "value_id": valueId,
    "value": value,
  };
}