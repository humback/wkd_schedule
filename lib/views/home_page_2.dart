import 'dart:developer';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wkd_schedule/models/wkd.dart';
import 'package:wkd_schedule/services/remote_service.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //List<WkdDelay>? wkdItem_W;
  WkdDelay? wkdItem_W;
  WkdDelay? wkdItem_P;
  var isLoaded = false;
  String _update = '';
    
    
    void loadSettings() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    setState(() {
      _update = (pre.getString('name') ?? '');
    });
  }

  @override
  void initState() {
    
    super.initState();
    
    //fetcg data from API
    loadSettings();
    getData();
  }

  getData() async {
    wkdItem_W = (await RemoteService().getWKD('nwwar', 'W'));
    wkdItem_P = (await RemoteService().getWKD('wzach', 'P'));
    print(wkdItem_W?.trains.length);
    if (wkdItem_W != null && wkdItem_P != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  parseHour(strTime) {
    
    var dateTime= HttpDate.parse(strTime);
     dateTime=dateTime.toLocal();
    
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String formattedTime =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  @override
  
  

  Widget build(BuildContext context) {
    print(wkdItem_W?.trains.length);
    
    return Scaffold(
      appBar: AppBar(
          title: const Text('WKD'), backgroundColor: const Color(0xffE02521)),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            
            children: 
            [
              schedule(wkdItem_W),
              schedule(wkdItem_P),
              schedule(wkdItem_W),
              Text(wkdItem_W != null ? ' ${wkdItem_W!.update}' : ''),
              Text(_update),
              
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.refresh),
        onPressed: () {
          getData();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ustawienia',
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            label: 'Odśwież',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.red,
        onTap: null,
      ),
    
    );
  }
  Widget schedule(WkdDelay? wkdItem) {
    if (wkdItem == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Container(
          height: 50,
          width: double.infinity,
          color: Color(0xff004982),
          child: Text('${wkdItem.station} ${wkdItem.direction}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30) ),
        ),
        ListView.builder(
          itemCount: wkdItem.trains.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final train = wkdItem.trains[index];
            return Container(
              height: 70,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              child: ListTile(
                leading: const Icon(Icons.schedule),
                title: Row(
                  children: [
                    Text('${parseHour(train.scheduleDepartureTime)}'),
                    const SizedBox(width: 50),
                    Icon(Icons.more_time,
                        color: train.delay > 0 ? Colors.red : Colors.black),
                    Text(
                      ' ${train.delay.toInt()} min ',
                      style: train.delay > 0
                          ? const TextStyle(color: Colors.red)
                          : const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                subtitle: Text(' ${train.id}'),
                tileColor: Colors.white,
              ),
            );
          },
        ),
      ],
    );
  }
}



