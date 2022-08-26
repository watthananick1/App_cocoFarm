import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cocopage.dart';
import "dart:convert";
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class cocoadding extends StatefulWidget {
  const cocoadding({Key? key}) : super(key: key);

  @override
  State<cocoadding> createState() => _cocoaddingState();
}

class _cocoaddingState extends State<cocoadding> {
  TextEditingController coco_where = TextEditingController();
  TextEditingController coco_start = TextEditingController();
  String? coco_lat;
  String? coco_long;
  String? selectedValue;
  Position? _currentPosition;
  LocationPermission? permission;
  List categoryItemList = [];

  @override
  void initState() {
    coco_start.text = "";
    getAllCategory();
    super.initState();
  }

  Future<List> getAllCategory() async {
    Uri url = Uri.parse('http://cocoworks.cocopatch.com/cocovari.php');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryItemList = jsonData;
      });
      return categoryItemList;
    } else {
      throw Exception(
          'We were not able to successfully download the json data.');
    }
  }

  Future Cocoadd() async {
    Uri url = Uri.parse('http://cocoworks.cocopatch.com/cocoadd.php');
    var response = await http.post(url, body:{
      "coco_start": coco_start.text,
      "cocovari_id": selectedValue,
      "coco_lat": coco_lat.toString(),
      "coco_long": coco_long.toString(),
    });
    var data;
    if (response.body.isNotEmpty){
      data = json.decode(response.body);
      print(selectedValue);
    }
    var fToast = FToast();
    fToast.init(context);
    print(data);
    if (data == "dataErorr") {
      Fluttertoast.showToast(
          msg: "กรุณาใส่ชื่อรายการ",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (data == "success") {
      Fluttertoast.showToast(
          msg: "ใส่ข้อมูลสำเร็จ",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.black,
          fontSize: 16.0);
      Navigator.of(context).pop();
    } else {
      print;
      Fluttertoast.showToast(
          msg: "กรุณาใส่ข้อมูลให้ครบ",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.redAccent,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }


  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.greenAccent],
                stops: [0.5, 1.0],
              ),
            )
          ),
          title: const Center(
            child: Text(
              'เพิ่มข้อมูลต้นมะพร้าว',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'เลือกพันธุ์',
                ),
                value: selectedValue,
                hint: const Text("เลือกพันธุ์"),
                items: categoryItemList.map((list) {
                  return DropdownMenuItem(
                    value: list['cocovari_id'],
                    child: Text(list['cocovari_name']),
                  );
                }).toList(),
                icon: const Icon(Icons.arrow_drop_down),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value.toString();
                  });
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                readOnly: true,
                controller: coco_where,
                decoration: InputDecoration(
                  isDense: true,
                  suffixIcon: IconButton(
                      onPressed: () async {
                        permission = await Geolocator.requestPermission();
                        if (_currentPosition == null) {
                          _getCurrentLocation();
                        } else {
                          coco_lat = _currentPosition!.latitude.toString();
                          coco_long = _currentPosition!.longitude.toString();
                          List gfg = [coco_lat, coco_long];
                          coco_where.text = gfg.toString();
                        }
                      },
                      icon: const Icon(Icons.location_on)),
                  border: const OutlineInputBorder(),
                  labelText: 'พิกัด',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                    child: TextField(
                      controller: coco_start,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                          labelText: "ว/ด/ป"),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          print(pickedDate);
                          String formattedDate =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                          print(formattedDate);
                          setState(() {
                            coco_start.text = formattedDate as String;
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ),
                ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        height: 50,
                        width: 150.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Cocoadd();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                          ),
                          child: const Text('ยืนยัน'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                          height: 50,
                          width: 150.0,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              onPrimary: Colors.white,
                            ),
                            child: const Text('ยกเลิก'),
                          )),
                    ),
                  ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true)
        .then((Position position) {
      setState((){
        _currentPosition = position;
      });
    }).catchError((e){
      print(e);
    });
  }
}

