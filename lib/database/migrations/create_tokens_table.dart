import 'package:vania/vania.dart';

class CreateTokensTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('tokens', () {
      id();
      char("name", length: 255);
      bigInt("tokenable_id");
      char('tokennn', length: 64);
      timeStamps();
      dateTime("deleted_at");
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('tokens');
  }
}
