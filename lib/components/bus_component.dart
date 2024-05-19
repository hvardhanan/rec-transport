import 'package:flutter/material.dart';

class BusWidget extends StatefulWidget {
  final String routeNumber;
  final String routeName;
  final String via;
  final List<Map<String, dynamic>> stops;

  const BusWidget({
    super.key,
    required this.routeNumber,
    required this.routeName,
    required this.via,
    required this.stops,
  });

  @override
  _BusWidgetState createState() => _BusWidgetState();
}

class _BusWidgetState extends State<BusWidget> {
  bool isPressed = false;

  SingleChildScrollView buildBottomSheetView() {
    return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text('STOPS: '),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: widget.stops.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(widget.stops[index]['name']),
                            subtitle: Text(
                                'Time: ${widget.stops[index]['time']} AM'),
                          );
                        },
                      ),
                      const Divider(),
                      const Text('Via: '),
                      Text(
                        widget.via,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Divider(),
                      const Text('College Arrival Time:'),
                      const Text('7.40 AM'),
                    ],
                  ),
                );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.directions_bus_filled),
        title: Text('${widget.routeNumber} - ${widget.routeName}'),
        subtitle: const Text('Tap to view details'),
        trailing: isPressed
            ? const Icon(Icons.arrow_drop_up_rounded)
            : const Icon(Icons.arrow_drop_down_rounded),
        onTap: () {
          setState(() {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return buildBottomSheetView();
              },
            );
          });
        },
      ),
    );
  }
}


