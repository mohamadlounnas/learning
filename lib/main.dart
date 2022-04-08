import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(Salaty());

class Salaty extends StatefulWidget {
  const Salaty({Key? key}) : super(key: key);

  @override
  State<Salaty> createState() => _SalatyState();
}

class _SalatyState extends State<Salaty> {
  var mawa9it = {};
  var location = {};
  var city = "blida";
  var isLoading = false;
  @override
  void initState() {
    _load();
    super.initState();
  }

  Future<void> _load() async {
    setState(() {
      isLoading = true;
    });
    try {
      var url =
          Uri.parse('https://api.pray.zone/v2/times/today.json?city=$city');
      var response = await http.get(url);
      var json = jsonDecode(response.body);
      mawa9it = json["results"]["datetime"][0]["times"];
      location = json["results"]["location"];
    } catch (e) {}
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(
            "Salaty",
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Salaty is a simple app to display the salaty times",
            style:
                TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7)),
          ),
        ),
        toolbarHeight: 90,
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          // the city input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              child: TextField(
                // icon
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter the city",
                  prefixIcon: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : Icon(Icons.search),
                ),
                onChanged: (value) {
                  city = value;
                },
                onSubmitted: (value) {
                  _load();
                },

                controller: TextEditingController(text: city),
              ),
            ),
          ),
          // small text for location
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(
              "Location: ${location["city"]}, ${location["country"]}",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: Icon(Icons.brightness_3),
            title: Text(
              "الفجر - Fajr",
            ),
            subtitle: Text(
              mawa9it["Fajr"] ?? "جاري التحميل...",
            ),
          ),
          ListTile(
            leading: Icon(Icons.brightness_5),
            title: Text(
              "الظهر - Dhuhr",
            ),
            subtitle: Text(
              mawa9it["Dhuhr"] ?? "جاري التحميل...",
            ),
          ),
          ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text(
              "العصر - Asr",
            ),
            subtitle: Text(
              mawa9it["Asr"] ?? "جاري التحميل...",
            ),
          ),
          // display Text in rounded box with a border contains 'موعد قلب اللوز 😂'
          Row(
            children: [
              // a line
              Expanded(
                child: Divider(
                  color: Colors.orangeAccent,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "🍮 هنا تروح تشري قلب اللوز 😂",
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.orangeAccent,
                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.brightness_4, color: Colors.orange),
            title: Text(
              "المغرب - Maghreb",
              style: TextStyle(color: Colors.orange),
            ),
            subtitle: Text(
              mawa9it["Maghrib"] ?? "جاري التحميل...",
              style: TextStyle(color: Colors.orange),
            ),
          ),
          ListTile(
            leading: Icon(Icons.brightness_2),
            title: Text(
              "العشاء - Isha",
            ),
            subtitle: Text(
              mawa9it["Isha"] ?? "جاري التحميل...",
            ),
          ),
        ],
      ),
    ));
  }
}
