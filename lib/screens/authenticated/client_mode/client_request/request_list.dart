import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/models/request.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_request/request_tile.dart';
import 'package:quick_service_clone/shared/widgets/loading_widget.dart';
import 'package:quick_service_clone/shared/widgets/no_result_widget.dart';

class RequestList extends StatefulWidget {
  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  @override
  Widget build(BuildContext context) {
    final _list = Provider.of<List<Request>>(context);
    print(_list);

    return _list == null
        ? Loading(
            text: 'Fetching your requests...',
          )
        : (_list.length == 0
            ? NoResultWidget(
                imagePath: 'assets/no_result_brocolli.png',
                text: "You don't have any requests.",
              )
            : _buildTiles(_list));
  }

  _buildTiles(List<Request> _list) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _list.length,
      itemBuilder: (context, index) {
        return RequestTile(
          request: _list[index],
        );
      },
    );


  }
}
