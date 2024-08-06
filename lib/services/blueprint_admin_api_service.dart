import 'dart:convert';
import 'dart:io';

import 'package:blueprint_app2/model/api_response.dart';
import 'package:blueprint_app2/model/notification/notification_response.dart';
import 'package:blueprint_app2/model/signal/signal_data.dart';
import 'package:blueprint_app2/model/user/user_profile.dart';
import 'package:blueprint_app2/services/shared_pref.dart';
import 'package:blueprint_app2/utils.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as http_dio;
import 'package:http_parser/http_parser.dart';

class AdminApiService {
  static const API = 'https://equigro.org/api';
  static const loginHeaders = {'Accept': 'application/json'};
  Variables variables = Variables();
  SharedPref sharedPref = SharedPref();
  http_dio.Dio dio = http_dio.Dio();

  void initiateDio(String token) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        var signalHeaders = {
          'Authorization': 'Bearer ' + token,
          'Accept': 'application/json'
        };
        options.headers.addAll(signalHeaders);
        return handler.next(options);
      },
    ));
  }

  Future<ApiResponse> createSignal(
      String token, File imagePath, NewSignals signals) async {
    ApiResponse apiResponse = ApiResponse();
    initiateDio(token);

    String photoName = imagePath.path.split('/').last;
    FormData form = new FormData.fromMap({
      'symbol': signals.symbol,
      'time_frame': signals.time_frame,
      'trade_type': signals.trade_type,
      'entry_price_one': signals.entry_price_one,
      'entry_price_two': signals.entry_price_two,
      'take_profit_one': signals.take_profit_one,
      'take_profit_two': signals.take_profit_two,
      'stop_loss': signals.stop_loss,
      'text': signals.text,
      'created_at': signals.created_at,
      'updated_at': signals.updated_at,
      'images': await http_dio.MultipartFile.fromFile(imagePath.path.toString(),
          filename: photoName, contentType: MediaType('image', 'png'))
    });
    try {
      Response result = await dio.post(API + '/signal/create', data: form);
      if (result.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(jsonEncode(result.data));
        apiResponse =
            ApiResponse(data: jsonData["data"], status: jsonData["status"]);
        return apiResponse;
      }
      return apiResponse =
          ApiResponse(data: result.statusMessage, status: false);
    } on DioException catch (e) {
      if (e.response!.statusCode == 503) {
        print(e.response!.data + " :::" + e.response!.statusCode);
        return apiResponse =
            ApiResponse(data: e.response!.statusMessage, status: false);
      } else {
        return apiResponse =
            ApiResponse(data: e.response!.statusMessage, status: false);
      }
    }
  }

  Future<ApiResponse?> deleteSignal(String token, signalID) async {
    initiateDio(token);

    try {
      Response response = await dio.post(API + '/signal/delete/' + signalID);

      if (response.statusCode == 200) {
        String jsonData = jsonEncode(response.data);
        Map<String, dynamic> responseData = jsonDecode(jsonData);
        ApiResponse apiResponse = ApiResponse(
            data: responseData["data"], status: responseData["status"]);
        return apiResponse;
      }
    } on DioException catch (e) {
      return ApiResponse(data: e.message, status: false);
    }
    return null;
  }

  Future<ApiResponse> successfulApi(String token, signalID) async {
    initiateDio(token);

    Response response = await dio.post(API + '/signal/success/' + signalID);

    if (response.statusCode == 200) {
      String jsonData = jsonEncode(response.data);
      Map<String, dynamic> responseData = jsonDecode(jsonData);
      ApiResponse apiResponse = ApiResponse(
          data: responseData["data"], status: responseData["status"]);
      return apiResponse;
    }
    return ApiResponse(data: response.statusMessage, status: false);
  }

  Future<ApiResponse> failedApi(String token, signalID) async {
    initiateDio(token);

    Response response = await dio.post(API + '/signal/failed/' + signalID);
    if (response.statusCode == 200) {
      String jsonData = jsonEncode(response.data);
      Map<String, dynamic> responseData = jsonDecode(jsonData);
      ApiResponse apiResponse = ApiResponse(
          data: responseData["data"], status: responseData["status"]);
      return apiResponse;
    }
    return ApiResponse(data: response.statusMessage, status: false);
  }

  Future<String> getActiveSubscribers(String token) async {
    initiateDio(token);

    try {
      var response = await dio.get(API + '/active-subscribers');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(jsonEncode(response.data));
        ApiResponse apiResponse =
            ApiResponse(data: jsonData["data"], status: true);
        if (apiResponse.data != null) {
          Map<String, dynamic> rawData =
              json.decode(jsonEncode(apiResponse.data));
          String message = rawData["active_subscribers"].toString();
          return message;
        } else {
          return "";
        }
      } else {
        return "";
      }
    } on DioException {
      return "";
    }
  }

  Future<String> getTotalSignals(String token) async {
    initiateDio(token);

    var response = await dio.get(API + '/total-signals');
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(jsonEncode(response.data));
      ApiResponse apiResponse =
          ApiResponse(data: jsonData["data"], status: true);
      if (apiResponse.data != null) {
        Map<String, dynamic> rawData =
            json.decode(jsonEncode(apiResponse.data));
        String message = rawData["total_signals"].toString();
        return message;
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  Future<String> getSuccessfulSignals(String token) async {
    initiateDio(token);

    var response = await dio.get(API + '/successful-signals');
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(jsonEncode(response.data));
      ApiResponse apiResponse =
          ApiResponse(data: jsonData["data"], status: true);
      if (apiResponse.data != null) {
        Map<String, dynamic> rawData =
            json.decode(jsonEncode(apiResponse.data));
        int vv = rawData["successful_signals"];
        String message = vv.toString();
        return message;
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  Future<String> getTotalUsers(String token) async {
    initiateDio(token);

    var response = await dio.get(API + '/total-users');
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(jsonEncode(response.data));
      ApiResponse apiResponse =
          ApiResponse(data: jsonData["data"], status: true);
      if (apiResponse.data != null) {
        Map<String, dynamic> rawData =
            json.decode(jsonEncode(apiResponse.data));
        String message = rawData["total_users"].toString();
        return message;
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  Future<List<UserProfile>> getAccounts(String token) async {
    initiateDio(token);

    Response response = await dio.get(API + '/accounts');
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(jsonEncode(response.data));
      ApiResponse apiResponse =
          ApiResponse(data: jsonData["data"], status: true);
      Map<String, dynamic> convertedApiResponse =
          jsonDecode(jsonEncode(apiResponse.data));
      List<dynamic> val = convertedApiResponse["accounts"];
      List<UserProfile>? userList;
      for (Map<String, dynamic> hh in val) {
        UserProfile account = UserProfile.fromJson(hh);
        userList!.add(account);
      }
      return userList!;
    } else {
      return [];
    }
  }

  Future<List<Signals>> getLiveSignals(String token) async {
    initiateDio(token);
    try {
      Response response = await dio.get(API + '/live-signals');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(jsonEncode(response.data));
        ApiResponse apiResponse =
            ApiResponse(data: jsonData["data"], status: true);
        Map<String, dynamic> rawData = jsonDecode(jsonEncode(apiResponse.data));
        List<dynamic> data = rawData["live_signals"];
        List<Signals>? sigist;
        for (Map<String, dynamic> hh in data) {
          Signals nals = Signals.fromJson(hh);
          sigist!.insert(0, nals);
        }
        return sigist!;
      } else {
        return [];
      }
    } on DioException {
      return [];
    }
  }

  Future<List<Signals>> getSignalsHistory(String token) async {
    initiateDio(token);
    Response response = await dio.get(API + '/signal-history');

    if (response.statusCode == 200) {
      String jsonData = jsonEncode(response.data);
      Map<String, dynamic> responseData = jsonDecode(jsonData);
      ApiResponse apiResponse =
          ApiResponse(data: responseData["data"], status: true);
      Map<String, dynamic> rawData = jsonDecode(jsonEncode(apiResponse.data));
      List<dynamic> data = rawData["signal_history"];
      List<Signals>? sigist;
      for (Map<String, dynamic> hh in data) {
        Signals nals = Signals.fromJson(hh);
        sigist!.insert(0, nals);
      }
      return sigist!;
    } else {
      return [];
    }
  }

  Future<String> composeMessage(
      String title, String text, String token, List<String> mails) async {
    initiateDio(token);
    Map dat = {'title': title, 'text': text, 'recipients': mails};

    try {
      Response response = await dio.post(API + '/message/create',
          data: dat,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
          ));
      //  Response response = await dio.post(API + '/message/create', data: dat);
      if (response.statusCode == 200) {
        String jsonData = jsonEncode(response.data);
        Map<String, dynamic> responseData = jsonDecode(jsonData);
        ApiResponse apiResponse =
            ApiResponse(data: responseData["data"], status: true);
        if (apiResponse.status!) {
          Map<String, dynamic> convertedApiResponse =
              jsonDecode(jsonEncode(apiResponse.data));
          String message = convertedApiResponse["message"];
          return message;
        } else {
          return "";
        }
      } else {
        return "";
      }
    } on DioException {
      return "";
    }
  }

  Future<List<FeedbackResponse>> getFeedbackHistory(String token) async {
    initiateDio(token);
    try {
      Response response = await dio.get(API + '/feedback-history');
      if (response.statusCode == 200) {
        String jsonData = jsonEncode(response.data);
        Map<String, dynamic> responseData = jsonDecode(jsonData);
        ApiResponse apiResponse =
            ApiResponse(data: responseData["data"], status: true);
        Map<String, dynamic> rawData = jsonDecode(jsonEncode(apiResponse.data));
        List<dynamic> data = rawData["feedbacks"];
        List<FeedbackResponse>? feedbackList;
        for (Map<String, dynamic> hh in data) {
          FeedbackResponse feedback = FeedbackResponse.fromJson(hh);
          feedbackList!.insert(0, feedback);
        }
        return feedbackList!;
      } else {
        return [];
      }
    } on DioException {
      return [];
    }
  }

  Future<List<NotificationResponse>> getNotificationHistory(
      String token) async {
    initiateDio(token);

    try {
      Response response = await dio.get(API + '/message-history');
      if (response.statusCode == 200) {
        String jsonData = jsonEncode(response.data);
        Map<String, dynamic> responseData = jsonDecode(jsonData);
        ApiResponse apiResponse =
            ApiResponse(data: responseData["data"], status: true);
        Map<String, dynamic> rawData = jsonDecode(jsonEncode(apiResponse.data));
        List<dynamic> data = rawData["messages"];
        List<NotificationResponse>? messageList;
        for (Map<String, dynamic> hh in data) {
          NotificationResponse message = NotificationResponse.fromJson(hh);
          messageList!.insert(0, message);
        }
        return messageList!;
      } else {
        return [];
      }
    } on DioException {
      return [];
    }
  }
}
