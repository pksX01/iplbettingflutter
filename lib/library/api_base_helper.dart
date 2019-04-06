import 'dart:io';

import 'package:async/async.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:async';

import 'exceptions.dart';

class ApiBaseHelper {
  String baseUrl;
  String _token;
  ApiBaseHelper(this.baseUrl, this._token);
  Future<dynamic> _getApiData(String api) async {
    var request = new http.Request("GET", Uri.parse(join(baseUrl, api)));
    request.headers["Authorization"] = "Bearer $_token";
    print("Requesting data from $baseUrl/$api with token $_token");

    return await _returnResponse(request);
  }

  Future<dynamic> _postApi(String api, dynamic data) async {
    var request = new http.Request("POST", Uri.parse(join(baseUrl, api)));
    request.body = json.encode(data);
    request.headers["Authorization"] = "Bearer $_token";
    request.headers["content-type"] = "application/json";
    print("Posting data to $baseUrl/$api with token $_token:\n${request.body}");
    return await _returnResponse(request);
  }

  Future<dynamic> postFile<T>(
      String api, File imageFile, String fileName) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var request =
        new http.MultipartRequest("POST", Uri.parse(join(baseUrl, api)));

    // add file to multipart
    request.files.add(
        new http.MultipartFile('file', stream, length, filename: fileName));
    request.headers["Authorization"] = "Bearer $_token";
    print("Posting data to $baseUrl/$api with token $_token: $fileName");
    return await _returnResponse(request);
  }

  Future<dynamic> _returnResponse(http.BaseRequest request) async {
    try {
      final response = await request.send();
      switch (response.statusCode) {
        case 200:
          return await response.stream.bytesToString();
        case 400:
          throw BadrequestException(await response.stream.bytesToString());
        case 401:
          throw BadrequestException(await response.stream.bytesToString());
        case 403:
        case 500:
        default:
          //throw BadrequestException(await response.stream.bytesToString());
          throw FetchDataException(
              'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<Map<String, dynamic>> getApiDataAsMap(String api) async {
    return json.decode(await _getApiData(api));
  }

  Future<List<dynamic>> getApiDataAsMapList(String api) async {
    var data = json.decode(await _getApiData(api));
    return data;
  }

  Future<String> getApiDataAsString(String api) async {
    return (await _getApiData(api)).toString();
  }

  Future<String> postAndGetApiDataAsString<T>(String api, T data) async {
    return (await _postApi(api, data)).toString();
  }

  Future postApiData<T>(String api, T data) async {
    return await _postApi(api, data);
  }

  Future<List<dynamic>> postApiDataForMapList<T>(String api, T data) async {
    return json.decode(await _postApi(api, data));
  }

  Future<Map<String, dynamic>> postApiDataForResult<T>(
      String api, T data) async {
    return json.decode(await _postApi(api, data));
  }
}
