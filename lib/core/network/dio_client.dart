import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:buddymentor/features/auth/data/services/storage_service.dart';
import 'package:buddymentor/features/auth/data/models/auth_models.dart';

class DioClient {
  static late Dio _dio;
  
  static Dio get dio => _dio;
  
  static void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "http://192.168.86.5:4001/user/",
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    
    // Add logging interceptor for all API calls
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 120,
      ),
    );
    
    print('🔧 Dio Client initialized with logging interceptor');
    
    _dio.interceptors.add(AuthInterceptor());
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await StorageService.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      print('🔑 Adding Bearer token to request: ${options.uri}');
    } else {
      print('⚠️ No token found for request: ${options.uri}');
    }
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await StorageService.getRefreshToken();
      if (refreshToken != null) {
        try {
          final refreshResponse = await Dio().post(
            'http://192.168.86.5:4001/user/auth/refresh-token',
            data: {'refresh_token': refreshToken},
          );
          
          if (refreshResponse.statusCode == 200) {
            final newToken = refreshResponse.data['data']['auth_token']['token'];
            final tokens = await StorageService.getTokens();
            if (tokens != null) {
              await StorageService.saveTokens(
                AuthTokens(accessToken: newToken, refreshToken: tokens.refreshToken)
              );
              
              final opts = err.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newToken';
              final cloneReq = await DioClient.dio.fetch(opts);
              return handler.resolve(cloneReq);
            }
          }
        } catch (e) {
          await StorageService.clearAuthData();
        }
      }
    }
    handler.next(err);
  }
}