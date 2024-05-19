import 'package:flutter/material.dart';

class BusWidget extends StatefulWidget {
  final String routeNumber;
  final String routeName;
  final String via;
  final String collegeArrivalTime;
  // final List<Map<String, String>> stops;

  const BusWidget({
    Key? key,
    required this.routeNumber,
    required this.routeName,
    required this.via,
    required this.collegeArrivalTime,
    // required this.stops,
    
  }) : super(key: key);

  @override
  _BusWidgetState createState() => _BusWidgetState();
}

class _BusWidgetState extends State<BusWidget> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.directions_bus_filled),
        title: Text('${widget.routeNumber} - ${widget.routeName}'),
        subtitle: AnimatedCrossFade(
          firstChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('Stops: Yet to be implemented'),
              Text('Via: ${widget.via}'),
            ],
          ),
          secondChild: const Text('Tap to view details'),
          crossFadeState: !isPressed
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 100),
        ),
        trailing: isPressed ? const Icon(Icons.arrow_drop_up_rounded) : const Icon(Icons.arrow_drop_down_rounded),
        onTap: () {
          setState(() {
            isPressed = !isPressed;
          });
        },
      ),
    );
  }
}
