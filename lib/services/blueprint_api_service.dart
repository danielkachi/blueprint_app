import 'dart:convert';
import 'dart:io';
import 'package:blueprint_app2/model/api_response.dart';
import 'package:blueprint_app2/model/authentication/sign_in_response.dart';
import 'package:blueprint_app2/model/authentication/sign_up.dart';
import 'package:blueprint_app2/model/notification/notification_response.dart';
import 'package:blueprint_app2/model/plan/plan_data.dart';
import 'package:blueprint_app2/model/signal/signal_data.dart';
import 'package:blueprint_app2/model/user/user_profile.dart';
import 'package:blueprint_app2/utils.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as http_dio;
import 'package:http_parser/http_parser.dart';

import 'shared_pref.dart';

class ApiService {
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

  Future<ApiResponse> registerUser(SignUpRequest signUpRequest) async {
    ApiResponse apiResponse = ApiResponse();

    Map dat = {
      'email': signUpRequest.email,
      'username': signUpRequest.username,
      'password': signUpRequest.password,
      'sponsor_code': signUpRequest.sponsor_code,
      'phone': signUpRequest.phone
    };

    try {
      Response result = await dio.post(
        API + '/signup',
        data: dat,
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      if (result.statusCode == 200) {
        final String jsonData = jsonEncode(result.data);
        Map<String, dynamic> responseData = jsonDecode(jsonData);
        apiResponse = ApiResponse(data: responseData["data"], status: true);
        return apiResponse;
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 502 || e.response!.statusCode == 503) {
        return apiResponse = ApiResponse(
            data: "Check  your internet connections", status: false);
      } else {
        return apiResponse = ApiResponse(data: e.message, status: false);
      }
    }
    return ApiResponse(data: null, status: false);
  }

  Future<ApiResponse> loginUser(String username, password) async {
    Map dat = {'username': username, 'password': password};

    try {
      var response = await dio.post(API + '/signin', data: dat);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData =
            new Map<String, dynamic>.from(response.data);
        ApiResponse apiResponse =
            ApiResponse(data: jsonData["data"], status: true);
        return apiResponse;
      } else {
        return ApiResponse(data: null, status: false);
      }
    } on DioException catch (e) {
      print(e.response!.data + " :::" + e.response!.statusCode);
      if (e.response!.statusCode == 503) {
        return ApiResponse(data: e.response!.statusMessage, status: false);
      } else {
        return ApiResponse(data: e.response!.statusMessage, status: false);
      }
    }
  }

  Future<String> fetchToken() async {
    String token;
    Map<String, dynamic> val = await SharedPref().read(new Variables().users);
    SignInResponse signInResponse = SignInResponse.fromJson(val);
    token = signInResponse.bearer_token!;
    return token;
  }

  Future<Profile> getUserProfile(String token) async {
    initiateDio(token);

    Response response = await dio.get(API + '/my-profile');
    if (response.statusCode == 200) {
      String jsonData = jsonEncode(response.data);
      Map<String, dynamic> responseData = jsonDecode(jsonData);
      ApiResponse apiResponse =
          ApiResponse(data: responseData["data"], status: true);
      Map<String, dynamic> convertedApiResponse =
          jsonDecode(jsonEncode(apiResponse.data));
      List<dynamic> val = convertedApiResponse["profile"];
      bool sub = convertedApiResponse["active_subscription"];
      if (val.isNotEmpty) {
        Profile profile = Profile(UserProfile.fromJson(val[0]), sub);
        return profile;
      } else {
        // Handle the case where UserProfile is null
        // Return a default Profile object or throw an exception
        throw Exception('Failed to fetch user profile');
      }
    } else {
      // Return a default Profile object or throw an exception
      throw Exception('Failed to fetch user profile');
    }
  }

  Future<List<Signals>> getSignalsFromApi(String token) async {
    initiateDio(token);
    Response response = await dio.get(API + '/my-signals');

    if (response.statusCode == 200) {
      String jsonData = jsonEncode(response.data);
      Map<String, dynamic> responseData = jsonDecode(jsonData);
      ApiResponse apiResponse =
          ApiResponse(data: responseData["data"], status: true);
      Map<String, dynamic> rawData = jsonDecode(jsonEncode(apiResponse.data));
      List<dynamic> data = rawData["signals"];
      if (data.isNotEmpty) {
        List<Signals>? sigist;
        for (Map<String, dynamic> hh in data) {
          Signals nals = Signals.fromJson(hh);
          sigist!.insert(0, nals);
        }
        return sigist!;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<ApiResponse> updateProfile(
      File imagefile, String phoneNumber, String token) async {
    initiateDio(token);

    Response response;

    try {
      String photoName = imagefile.path.split('/').last;
      FormData form = new FormData.fromMap({
        'phone_number': phoneNumber,
        'photo': await http_dio.MultipartFile.fromFile(
            imagefile.path.toString(),
            filename: photoName,
            contentType: MediaType('image', 'png'))
      });
      response = await dio.post(API + '/update-profile', data: form);
      if (response.statusCode == 200) {
        String jsonData = jsonEncode(response.data);
        Map<String, dynamic> responseData = jsonDecode(jsonData);
        ApiResponse apiResponse =
            ApiResponse(data: responseData["data"], status: true);
        return apiResponse;
      } else {
        return ApiResponse(data: null, status: false);
        ;
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 503) {
        print(e.response!.data + " :::" + e.response!.statusCode);
        return ApiResponse(data: e.response!.statusMessage, status: false);
      } else {
        return ApiResponse(data: e.response!.statusMessage, status: false);
      }
    }
  }

  Future<ApiResponse> updatePassword(
      String oldpassword, String newpassword, String token) async {
    initiateDio(token);
    Map dat = {'current_password': oldpassword, 'new_password': newpassword};

    Response response = await dio.post(API + '/change-password', data: dat);
    if (response.statusCode == 200) {
      String jsonData = jsonEncode(response.data);
      Map<String, dynamic> responseData = jsonDecode(jsonData);
      ApiResponse apiResponse = ApiResponse(
          data: responseData["data"], status: responseData["status"]);
      return apiResponse;
    } else {
      return ApiResponse(data: null, status: false);
    }
  }

  Future<ApiResponse> recoverPassword(String email) async {
    Map dat = {'email': email};

    Response response = await dio.post(API + '/forgot-password', data: dat);
    if (response.statusCode == 200) {
      String jsonData = jsonEncode(response.data);
      Map<String, dynamic> responseData = jsonDecode(jsonData);
      ApiResponse apiResponse = ApiResponse(
          data: responseData["data"], status: responseData["status"]);
      return apiResponse;
    } else {
      return ApiResponse(data: null, status: false);
    }
  }

  Future<List<FeedbackResponse>> getNotifications(String token) async {
    initiateDio(token);
    Response response = await dio.get(API + '/my-messages');

    if (response.statusCode == 200) {
      String jsonData = jsonEncode(response.data);
      Map<String, dynamic> responseData = jsonDecode(jsonData);
      ApiResponse apiResponse =
          ApiResponse(data: responseData["data"], status: true);
      Map<String, dynamic> convertedApiResponse =
          jsonDecode(jsonEncode(apiResponse.data));
      List<dynamic> data = convertedApiResponse["messages"];

      List<FeedbackResponse> notificationList = [];
      for (Map<String, dynamic> item in data) {
        FeedbackResponse notificationResponse = FeedbackResponse.fromJson(item);
        notificationList.add(notificationResponse);
      }
      return notificationList;
    } else {
      // Return an empty list if there are no notifications
      return [];
    }
  }

  Future<PlanData> getPaymentPlans(String token) async {
    initiateDio(token);
    Response response = await dio.get(API + '/subscription-plans');

    if (response.statusCode == 200) {
      String jsonData = jsonEncode(response.data);
      Map<String, dynamic> responseData = jsonDecode(jsonData);
      ApiResponse apiResponse =
          ApiResponse(data: responseData["data"], status: true);
      Map<String, dynamic> rawData = jsonDecode(jsonEncode(apiResponse.data));
      PlanData plans = PlanData.fromJson(rawData["plans"]);
      return plans;
    } else {
      // Throw an exception or return a default PlanData object
      throw Exception('Failed to fetch payment plans');
    }
  }

  Future<ApiResponse> paystackSubscriptionCallBack(String token, String planID,
      String amount, String skTest, String transactionRef, int duration) async {
    initiateDio(token);

    Map dat = {
      'id': planID,
      'amount': amount,
      'key': skTest,
      'transaction_ref': transactionRef,
      'duration': duration,
    };

    Response response = await dio.post(API + '/paystack-callback', data: dat);
    if (response.statusCode == 200) {
      String jsonData = jsonEncode(response.data);
      Map<String, dynamic> responseData = jsonDecode(jsonData);
      ApiResponse apiResponse =
          ApiResponse(data: responseData["data"], status: true);
      return apiResponse;
    } else {
      return ApiResponse(data: response.statusMessage, status: false);
    }
  }

  Future<ApiResponse> sendUserFeedBack(
      token, String title, String message) async {
    initiateDio(token);

    Map dat = {'title': title, 'message': message};

    Response response = await dio.post(API + '/send-feedback', data: dat);
    if (response.statusCode == 200) {
      String jsonData = jsonEncode(response.data);
      Map<String, dynamic> responseData = jsonDecode(jsonData);
      ApiResponse apiResponse =
          ApiResponse(data: responseData["data"], status: true);
      return apiResponse;
    } else {
      return ApiResponse(data: null, status: false);
    }
  }

  Future<String> createAccessCode(
      skTest, _getReference, userEmail, double cost) async {
    initiateDio(skTest);

    try {
      Map data = {
        "amount": cost,
        "email": userEmail,
        "reference": _getReference
      };
      String payload = json.encode(data);
      Response response = await dio.post(
          'https://api.paystack.co/transaction/initialize',
          data: payload);
      if (response.statusCode == 200) {
        final Map convertedResponse = jsonDecode(response.data);
        String accessCode = convertedResponse['data']['access_code'];
        return accessCode;
      } else {
        return response.statusMessage!;
      }
    } on DioException catch (e) {
      return e.message!;
    }
  }
}
