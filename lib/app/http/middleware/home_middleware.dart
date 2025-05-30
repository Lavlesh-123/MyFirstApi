import 'package:vania/vania.dart';

class HomeMiddleware extends Middleware {
  @override
  Future<bool> handle(Request req) async {
    if (req.headers['lavlesh'] == 'agrahari') {
      print('correct headers found');
      return true; // Allow request to continue
    }
    
    print('incorrect or missing header');
    return false; // Stop the request
    // Alternatively, you could throw an exception:
    // throw UnauthorizedException('Invalid header');
  }
}