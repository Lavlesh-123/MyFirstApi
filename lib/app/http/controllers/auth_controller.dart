import 'package:furniture_api/app/models/user.dart';
import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';

class AuthController extends Controller {
  Future<Response> register(Request request) async {
    try {
      await request.validate({
        'name': 'required|string|alpha',
        'email': 'required|email',
        'password': 'required|string',
      }, {
        'name.required': 'Name is required',
        'name.string': 'Name must be a string',
        'name.alpha': 'Name must contain only alphabetic characters',
        'email.required': 'Email is required',
        'email.email': 'Email must be a valid email address',
        'password.required': 'Password is required',
        'password.string': 'Password must be a string',
      });
    } catch (e) {
      if (e is ValidationException) {
        var errorMessage = e.message;
        var errorMessageList = errorMessage.values.toList();
        return Response.json({
          "msg": errorMessageList.isNotEmpty
              ? errorMessageList[0]
              : "Validation error",
          "code": 401,
          "data": ""
        }, 401);
      } else {
        print('Validation error: $e');
        return Response.json(
            {"msg": "An unexpected error occurred", "code": 500, "data": ""},
            500);
      }
    }

    try {
      final name = request.input('name');
      final email = request.input('email');
      var password = request.input('password');
      print('Name: $name, Email: $email, Password: $password');

      var user = await User().query().where('email', '=', email).first();
      if (user != null) {
        return Response.json(
            {"msg": "Email already exists", "code": 409, "data": ""}, 409);
      }
      password = Hash().make(password);
      await User().query().insert({
        "name": name,
        "email": email,
        "password": password,
        "avatar": null,
        "description": "No user content found",
        "phone": request.input('phone', 'null'),
        "birthday": request.input('birthday', null),
        "gender": request.input('gender', null),
        "created_at": DateTime.now().toIso8601String(),
        "updated_at": DateTime.now().toIso8601String(),
      });
      return Response.json(
          {"code": 200, "msg": "Register successful", "data": ""}, 200);
    } catch (e) {
      print('Error during register: $e');
      return Response.json({
        "msg": "An unexpected error during insert: $e",
        "code": 500,
        "data": ""
      }, 500);
    }
  }

  Future<Response> login(Request request) async {
    try {
      await request.validate({
        'email': 'required|email',
        'password': 'required|string',
      }, {
        'email.required': 'Email is required',
        'email.email': 'Email must be a valid email address',
        'password.required': 'Password is required',
        'password.string': 'Password must be a string',
      });
    } catch (e) {
      if (e is ValidationException) {
        var errorMessage = e.message;
        var errorMessageList = errorMessage.values.toList();
        return Response.json({
          "msg": errorMessageList.isNotEmpty
              ? errorMessageList[0]
              : "Validation error",
          "code": 401,
          "data": ""
        }, 401);
      } else {
        print('Validation error: $e');
        return Response.json(
            {"msg": "An unexpected error occurred", "code": 500, "data": ""},
            500);
      }
    }

    try {
      final email = request.input('email');
      var password = request.input('password');
      print('Email: $email, Password: $password');

      var user = await User().query().where('email', '=', email).first();
      if (user == null) {
        return Response.json(
            {"msg": "User not found", "code": 404, "data": ""}, 404);
      }
      print('User: $user (Type: ${user.runtimeType})');

      // Verify password
      if (!Hash().verify(password, user['password'])) {
        return Response.json(
            {"msg": "Your email or password is wrong", "code": 401, "data": ""},
            401);
      }

      return Response.json(
          {"code": 200, "msg": "Login successful", "data": 'tokenData'}, 200);
    } catch (e) {
      print('Error during login: $e');
      return Response.json(
          {"msg": "An unexpected error during login", "code": 500, "data": ""},
          500);
    }
  }
}

final AuthController authController = AuthController();
