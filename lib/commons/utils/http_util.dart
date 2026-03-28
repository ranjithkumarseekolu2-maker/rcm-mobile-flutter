import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/constants/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class HttpUtils {
  /// global dio object
  static Dio dio = Dio();

  /// default options
  static String apiPrefix = AppConstants.baseUrl;
  static const int CONNECT_TIMEOUT = 1000000;
  static const int RECEIVE_TIMEOUT = 10000;

  static Dio getInstance() {
    dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] =
        CommonService.instance.jwtToken.value;
    dio.options.baseUrl = apiPrefix;
    print('request url: ${dio.options.baseUrl}');
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      return handler.next(options);
    }, onResponse: (response, handler) {
      return handler.next(response);
    }, onError: (DioError e, handler) {
      if (e.response!.statusCode == 404 || e.response!.statusCode! >= 500) {}
      if ((e.response!.statusCode == 401 ||
          e.response!.statusCode == 403 ||
          e.response!.statusCode == 409)) {
        print('api url 401 ${e.requestOptions.path}');
        if (e.requestOptions.path == '/auth/local') {
        } else {
          if (Get.routing.current != '/login' &&
              e.response!.statusCode == 401) {
            if (CommonService.instance.jwtToken != '') {
              CommonService.confirmLogout();
              // SharedPreferences prefs = await SharedPreferences.getInstance();
            }
            //
          }
        }
      }
      return handler.next(e); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: return `dio.resolve(response) `.
    }));
    return dio;
  }
}
