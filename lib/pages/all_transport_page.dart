import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transport_app/components/bus_component.dart';

class AllTransportPage extends StatefulWidget {
  const AllTransportPage({super.key});

  @override
  State<AllTransportPage> createState() => _AllTransportPageState();
}

class _AllTransportPageState extends State<AllTransportPage> {
  int currentIndex = 0;

  List _busRoutes = [];

  late Future _busRoutesFuture;

  initState() {
    super.initState();
    _busRoutesFuture = loadBusRoutes();
  }

  Future<void> loadBusRoutes() async {
    final String busRoutes = await rootBundle.loadString('assets/json/bus_routes.json');
    final data = await jsonDecode(busRoutes);
    setState(() {
      _busRoutes = data['bus_route_names'];
      print('Number of items in busRoutes: ${_busRoutes.length}');
    });
  }

  Center allTransport() {
    return Center(
      child: FutureBuilder(
        future: _busRoutesFuture, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          else
            return ListView.builder(
              itemCount: _busRoutes.length,
              itemBuilder: (context, index) {
                return BusWidget(
                  routeNumber: _busRoutes[index]['route_number'],
                  routeName: _busRoutes[index]['route_name'],
                  via: _busRoutes[index]['via'],
                  collegeArrivalTime: _busRoutes[index]['college_arrival_time'],
                  stops: List.from(_busRoutes[index]['stops']),
                );
              },
            );
        
        },
      )
    );
}

  Center bodyFunction() {
    switch (currentIndex) {
      case 0:
        return const Center(child: Text('Today Transport'));
      case 1:
        return const Center(child: Text('Tomorrow Transport'));
      case 2:
        return allTransport();
      case 3:
        return const Center(child: Text('Select Date Transport'));
      case 4:
        return const Center(child: Text('About'));
    }

    return const Center();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REC TRANSPORT'),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.date_range), label: 'Today',),
          BottomNavigationBarItem(
              icon: Icon(Icons.date_range_sharp), label: 'Tomorrow',),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'All',),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time), label: 'Select Date',),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/allies.png'),),
            label: 'About',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: bodyFunction(),
    );
  }
}
