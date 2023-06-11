import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleService {
  Future<Response> getRoutes(
    LatLng origin,
    LatLng destination,
  ) async {
    try {
      final Dio _dio = Dio();
      final String _url =
          'https://routes.googleapis.com/directions/v2:computeRoutes?\$key=${dotenv.env['GOOGLE_MAPS_KEY']}';

      final _data = {
        "origin": {
          "location": {
            "latLng": {
              "latitude": origin.latitude,
              "longitude": origin.longitude,
            },
          },
        },
        "destination": {
          "location": {
            "latLng": {
              "latitude": destination.latitude,
              "longitude": destination.longitude,
            },
          },
        },
        "travelMode": "DRIVE",
        "routingPreference": "TRAFFIC_AWARE_OPTIMAL",
        "computeAlternativeRoutes": true,
        "routeModifiers": {
          "avoidTolls": false,
          "avoidHighways": false,
          "avoidFerries": false
        },
        "languageCode": "en-US",
        "units": "IMPERIAL",
      };

      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            print('Sending request to ${options.uri}');
            handler.next(options);
          },
          onError: (e, handler) {
            print('Error ${e.response?.statusCode}: ${e.message}');
            handler.next(e);
          },
          onResponse: (response, handler) {
            print('Received response from ${response.requestOptions.uri}');
            handler.next(response);
          },
        ),
      );

      final Response response = await _dio.post(
        _url,
        data: _data,
        options: Options(
          headers: {'X-Goog-FieldMask': '*'},
        ),
      );

      return response;
    } on DioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
