import 'package:flutter/material.dart';
import 'package:phpservice/page/cocopage.dart';
import 'package:phpservice/map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const TapMain(),
    );
  }
}
class TapMain extends StatefulWidget {
  const TapMain({Key? key}) : super(key: key);

  @override
  _TapMainState createState() => _TapMainState();
}

class _TapMainState extends State<TapMain> {
  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).padding.top;
    kToolbarHeight;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.green,
            flexibleSpace: Container(
              decoration: const BoxDecoration(),
            ),
            title: const Text('Cocoworks',
              style: TextStyle(color: Colors.white),
            ),
            bottom: const TabBar(
                tabs: [
                  Tab(
                    text: "สวนของฉัน",
                  ),
                  Tab(
                      text: "แผนที่สวนมะพร้าว"
                  )
                ]
            ),
          ),
          body: TabBarView(children: [Cocopage(), GetPoints()],)
      ),
    );
  }
}




