import 'package:vania/vania.dart';

class CreateUserTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('users', () {
      id();
      char("name", length: 255);
      bigInt("avatar", length: 100);
      char('password', length: 200);
      char('email', length: 191);
      char('phone', length: 191);
      longText('description');
      char('birthday', length: 200);
      mediumInt('gender');
      dateTime("created_at");
      dateTime("updated_at");
      dateTime("deleted_at");
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('users');
  }
}
