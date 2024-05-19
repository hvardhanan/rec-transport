import 'dart:convert';

class BusRoute {
  final String routeNumber;
  final String routeName;
  final String via;
  final String collegeArrivalTime;
  final List<Map<String, String>> stops;

  BusRoute({
    required this.routeNumber,
    required this.routeName,
    required this.via,
    required this.collegeArrivalTime,
    required this.stops,
  });

}

Future<List<BusRoute>> loadBusRoutes() async {
  
  List<BusRoute> busRoutes = await jsonDecode('assets/json/bus_routes.json') as List<BusRoute>;

  return busRoutes;

}
