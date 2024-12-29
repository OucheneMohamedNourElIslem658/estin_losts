import 'dart:math';

class Utils {
  static String getRandomImageURL(){
    final randomIndex = Random().nextInt(100);
    final imagesWebsite = "https://picsum.photos/200/300?random=$randomIndex";
    return imagesWebsite;
  }
}