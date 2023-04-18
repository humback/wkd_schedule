import 'dart:developer';

import 'dart:io';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    //fetcg data from API
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
          title: const Text('WKD'), backgroundColor: const Color(0xff004982)),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text(wkdItem_W != null
                  ? ' ${wkdItem_W!.station} ${wkdItem_W!.direction}'
                  : '',style: Theme.of(context).textTheme.headlineMedium),
              ListView.builder(
                  itemCount: wkdItem_W?.trains.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 70,
                       decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.schedule),
                        title: Row(
                          children: [
                            Text(
                                '${parseHour(wkdItem_W!.trains[index].scheduleDepartureTime)}'),
                            const SizedBox(width: 50),
                            Icon(Icons.more_time,
                                color: wkdItem_W!.trains[index].delay > 0
                                    ? Colors.red
                                    : Colors.black),
                            Text(
                              ' ${wkdItem_W!.trains[index].delay.toInt()} min ',
                              style: wkdItem_W!.trains[index].delay > 0
                                  ? const TextStyle(color: Colors.red)
                                  : const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        subtitle: Text(' ${wkdItem_W!.trains[index].id}'),
                        tileColor: Colors.lightBlue.shade50,
                      ),
                    );
                  }),
              Text(wkdItem_P != null
                  ? ' ${wkdItem_P!.station} ${wkdItem_P!.direction}'
                  : '',style: Theme.of(context).textTheme.headlineMedium),
              ListView.builder(
                  itemCount: wkdItem_P?.trains.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.schedule),
                        title: Row(
                          children: [
                            Text(
                                '${parseHour(wkdItem_P!.trains[index].scheduleDepartureTime)}'),
                            const SizedBox(width: 50),
                            Icon(Icons.more_time,
                                color: wkdItem_P!.trains[index].delay > 0
                                    ? Colors.red
                                    : Colors.black),
                            Text(
                              ' ${wkdItem_P!.trains[index].delay.toInt()} min ',
                              style: wkdItem_P!.trains[index].delay > 0
                                  ? const TextStyle(color: Colors.red)
                                  : const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        subtitle: Text(' ${wkdItem_P!.trains[index].id}'),
                        tileColor: Colors.lightBlue.shade50,
                      ),
                    );
                  }),
              Text(wkdItem_W != null ? ' ${wkdItem_W!.update}' : ''),
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
    );
  }
}
