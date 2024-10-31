
import 'package:connectivity_plus/connectivity_plus.dart';


class NetworkUtils {
  static Future<List<ConnectivityResult>> checkInternetConnectivity() async {
    final List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    return result;
  }
}