import 'dart:developer';

import 'package:wkd_schedule/models/wkd.dart';
import 'package:http/http.dart' as http;
import 'package:wkd_schedule/utils/constans.dart';



class RemoteService
{
  Future<WkdDelay?> getWKD(station, dir) async  {
    var client = http.Client();
    var uri = Uri.parse(ApiConstants.baseUrl+ApiConstants.usersEndpoint+'?station='+station+'&dir='+dir);
    
    try {
      var response = await client.get(uri);
      print('try http');
      if (response.statusCode == 200){
        return wkdDelayFromJson(response.body);
      }
    } catch(e) {
        throw Exception('Failed to fetch WkdDelay data');
    }
    return null;
  }
}