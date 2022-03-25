import 'screens/account.dart';
import 'screens/home.dart';

//named lower case and also needs to be defined in beginning of class as: static String routeID = ''
var routes = {
  'home': (context) => MyHomePage(title: 'Home'),
  'account': (context) => Account(),
};