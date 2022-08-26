import 'package:flutter/material.dart';
import 'package:phpservice/page/cocopage.dart';
import 'package:phpservice/map.dart';

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
