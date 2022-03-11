import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ClientHelper {
  final String baseUrl = "https://jsonplaceholder.typicode.com";

  Future<dynamic> fetchData(String url, {Map<String, String>? params}) async{
    String requestUrl = "$baseUrl/$url${params != null ? queryParameters(params) : ""}";

    var header = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    var responseJson;
    try {
      final response = await http.get(Uri.parse(requestUrl), headers: header);
      responseJson = json.decode(response.body.toString());
    } on SocketException {
      throw Exception("No Internet Connection");
    }
    return responseJson;
  }

  Future<dynamic> postData(String url, dynamic body, {bool isPost = true}) async{
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json'
    };

    var responseJson;
    try {
      final response = isPost ? await http.post(Uri.parse("$baseUrl/$url"), headers: header)
       : await http.put(Uri.parse("$baseUrl/$url"), headers: header);
      responseJson = json.decode(response.body.toString());
    } on SocketException {
      throw Exception("No Internet Connection");
    }
    return responseJson;
  }

  Future<dynamic> patchData(String url, {Map<String, dynamic>? body}) async{
    String requestUrl = "$baseUrl/$url";

    var header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json'
    };

    //Set Multipart Request
    var request = http.MultipartRequest("PATCH", Uri.parse(requestUrl));
    request.headers.addAll(header);

    if (body != null){
      for(var v in body.entries){
        request.fields[v.key] = v.value.toString();
      }
    }

    var responseJson;
    try {
      final response = await request.send();
      responseJson = await response.stream.bytesToString();
    } on SocketException {
      throw Exception("No Internet Connection");
    }
    return responseJson;


  }

  Future<dynamic> deleteData(String url, {Map<String, String>? body}) async{
    var request = http.Request('DELETE', Uri.parse('$baseUrl/$url'));
    var responseJson;

    try {
      final client = http.Client();
      var response = await client.send(request).then((value) => value);
      responseJson = await response.stream.bytesToString();
    } on SocketException {
      throw Exception("No Internet Connection");
    }
    return responseJson;
  }

  String queryParameters(Map<String, String>? params){
    if (params != null){
      final jsonString = Uri(queryParameters: params);
      return '?${jsonString.query}';
    }
    return '';
  }
}