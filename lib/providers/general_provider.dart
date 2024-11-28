import 'package:flutter/cupertino.dart';

class GeneralProvider with ChangeNotifier {
  static final GeneralProvider _instance = GeneralProvider._internal();
  factory GeneralProvider() => _instance;

  GeneralProvider._internal();


}