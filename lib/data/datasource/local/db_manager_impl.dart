import 'package:hive/hive.dart';
import 'package:music_player/data/datasource/local/db_boxes.dart';
import 'package:music_player/data/datasource/local/db_manager.dart';

class DbManagerImpl extends DbManager {
  @override
  Future<List<String>> getFavourites() async {
    final box = Hive.box(Boxes.hiveBoxUserFavourites);
    return await box.get('favourites', defaultValue: []);
  }

  @override
  Future<void> saveFavourites(List<String> favourites) async {
    final box = Hive.box(Boxes.hiveBoxUserFavourites);
    box.put('favourites', favourites);
  }

}
