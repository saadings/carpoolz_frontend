import 'package:dio/dio.dart';
import './dio_client.dart';

class BaseService {
  Dio get dio => DioClient.dio;
}
