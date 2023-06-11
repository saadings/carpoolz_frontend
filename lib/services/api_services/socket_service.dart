import 'package:dio/dio.dart';

import './base_service.dart';

class SocketService extends BaseService {
  Future<Response> emit(String event, dynamic data) async {
    try {
      // print(data);
      final response = await dio.post('/socket/emit', data: {
        'event': event,
        'data': data,
      });

      return response;
    } on DioError catch (_) {
      print(_.toString());
      rethrow;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
