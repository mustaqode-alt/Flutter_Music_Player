

abstract class DbManager {
  Future<void> saveFavourites(List<String> favourites);
  Future<List<String>> getFavourites();
}