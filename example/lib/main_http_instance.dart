import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:june/june.dart';

// http: ^1.2.1
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FilledButton(
                onPressed: () {
                  June.getState(() => MyController()).getBoredApi();
                },
                child: const Text("Get boredApi"),
              ),
              JuneBuilder(
                () => MyController(),
                builder: (c) {
                  return c.boredApi == null
                      ? const Text("NULL")
                      : Text(
                          c.boredApi!.toJson().toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        );
                },
              ),
              FilledButton(
                onPressed: () {
                  checkInstanceNoTag();
                },
                child: const Text("Check instance no tag"),
              ),
              JuneBuilder(
                () => MyController(),
                builder: (c) {
                  return c.instance == null
                      ? const Text("NULL")
                      : Text(
                          c.instance.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        );
                },
              ),
              FilledButton(
                onPressed: () {
                  checkInstanceWithTag();
                },
                child: const Text("Check instance with tag"),
              ),
              JuneBuilder(
                () => MyController(),
                tag: "new",
                builder: (c) {
                  return c.instance == null
                      ? const Text("NULL")
                      : Text(
                          c.instance.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

checkInstanceWithTag() {
  var c = June.getState(() => MyController());
  var c2 = June.getState(() => MyController(), tag: "new");
  c2.instance = c == c2;
  c2.setState();
}

checkInstanceNoTag() {
  var c = June.getState(() => MyController());
  var c2 = June.getState(() => MyController());
  c.instance = c == c2;
  c.setState();
}

class MyController extends JuneState {
  BoredApiModel? boredApi;
  bool? instance;

  Future getBoredApi() async {
    final res =
        await http.get(Uri.parse("https://www.boredapi.com/api/activity/"));
    boredApi = BoredApiModel.fromRawJson(res.body);
    setState();
  }
}

class BoredApiModel {
  String activity;
  String type;
  int participants;
  double price;
  String link;
  String key;
  double accessibility;

  BoredApiModel({
    required this.activity,
    required this.type,
    required this.participants,
    required this.price,
    required this.link,
    required this.key,
    required this.accessibility,
  });

  factory BoredApiModel.fromRawJson(String str) =>
      BoredApiModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BoredApiModel.fromJson(Map<String, dynamic> json) => BoredApiModel(
        activity: json["activity"],
        type: json["type"],
        participants: json["participants"],
        price: json["price"].toDouble(),
        link: json["link"],
        key: json["key"],
        accessibility: json["accessibility"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "activity": activity,
        "type": type,
        "participants": participants,
        "price": price,
        "link": link,
        "key": key,
        "accessibility": accessibility,
      };
}
