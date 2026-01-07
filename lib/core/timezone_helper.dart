import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

Future<void> initializeTimeZone() async {
  tzdata.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Mexico_City'));
}
