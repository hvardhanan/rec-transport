import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transport_app/components/bus_component.dart';
import 'package:transport_app/pages/about_page.dart';

class AllTransportPage extends StatefulWidget {
  const AllTransportPage({super.key});

  @override
  State<AllTransportPage> createState() => _AllTransportPageState();
}

class _AllTransportPageState extends State<AllTransportPage> {
  int currentIndex = 0;
  List<Map<String, dynamic>> _busRoutes = [];
  List<Map<String, dynamic>> _filteredBusRoutes = [];
  late Future<void> _busRoutesFuture;
  String _searchQuery = ''; 
  bool _isSearching = false; 

  @override
  void initState() {
    super.initState();
    _busRoutesFuture = loadBusRoutes();
  }

  Future<void> loadBusRoutes() async {
    try {
      final String busRoutesJson = await rootBundle.loadString('assets/json/bus_routes.json');
      final data = jsonDecode(busRoutesJson);
      setState(() {
        _busRoutes = List<Map<String, dynamic>>.from(data['bus_route_names']);
        _filteredBusRoutes = _busRoutes;
      });
    } catch (e) {
      print("Error loading bus routes: $e");
    }
  }

  void _filterBusRoutes(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredBusRoutes = _busRoutes.where((route) {
        final routeName = route['route_name'].toLowerCase();
        final routeNumber = route['route_number'].toLowerCase();

        final stops = List<Map<String, dynamic>>.from(route['stops']);
        final stopNames = stops.map((stop) => stop['name'].toString().toLowerCase()).toList();

        return routeName.contains(_searchQuery) ||
            routeNumber.contains(_searchQuery) ||
            stopNames.any((stop) => stop.contains(_searchQuery));
      }).toList();
    });
  }

  // Function to build the search bar inside the AppBar
  PreferredSizeWidget _buildSearchBar() {
    return AppBar(
      title: TextField(
        onChanged: (query) => _filterBusRoutes(query),
        decoration: const InputDecoration(
          hintText: 'Search Bus Routes or Stops...',
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          fillColor: Color(0x808080),
        ),
        style: const TextStyle(color: Colors.black),
        autofocus: true,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              _isSearching = false; 
              _filteredBusRoutes = _busRoutes; 
            });
          },
        ),
      ],
    );
  }

  PreferredSizeWidget _buildRegularAppBar() {
    return AppBar(
      title: const Text('REC TRANSPORT'),
      centerTitle: true,
      actions: currentIndex == 2
          ? [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true; 
            });
          },
        ),
      ]
          : [], 
    );
  }

  
  PreferredSizeWidget _buildAppBar() {
    if (currentIndex == 2 && _isSearching) {
 
      return _buildSearchBar();
    } else {
      return _buildRegularAppBar();
    }
  }

  Widget allTransport() {
    return FutureBuilder(
      future: _busRoutesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return ListView.builder(
            itemCount: _filteredBusRoutes.length,
            itemBuilder: (context, index) {
              return BusWidget(
                routeNumber: _filteredBusRoutes[index]['route_number'],
                routeName: _filteredBusRoutes[index]['route_name'],
                via: _filteredBusRoutes[index]['via'],
                stops: List.from(_filteredBusRoutes[index]['stops']),
              );
            },
          );
        }
      },
    );
  }

  Widget bodyFunction() {
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
        return aboutPage();
      default:
        return const Center();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(), 
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.date_range), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.date_range_sharp), label: 'Tomorrow'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'All'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Select Date'),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/allies.png')),
            label: 'About',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            _isSearching = false; 
            _filteredBusRoutes = _busRoutes;
          });
        },
      ),
      body: bodyFunction(),
    );
  }
}
