import 'dart:io';

class AdHelper{
  static String get bannerAdUnitId{
    if(Platform.isAndroid){
      return 'ca-app-pub-7138105762873542/6905886365';

    }else 
      throw UnsupportedError('Unsupported platform');
  }
}