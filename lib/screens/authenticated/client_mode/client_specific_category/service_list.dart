import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/models/service.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_specific_category/service_tile.dart';
import 'package:quick_service_clone/shared/widgets/no_result_widget.dart';

class ServiceList extends StatefulWidget {
  final String category;

  ServiceList({this.category});

  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  @override
  Widget build(BuildContext context) {
    final List<Service> _list = Provider.of<List<Service>>(context) ?? [];
    final _listCreated =
        _list.where((element) => element.category == widget.category).toList();

    return _listCreated.length == 0
        ? NoResultWidget(
            imagePath: 'assets/no_results.png',
            text: 'No services found...',
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: _listCreated.length,
            itemBuilder: (context, index) {
              return ServiceTile(
                service: _listCreated[index],
              );
            },
          );
  }
}
