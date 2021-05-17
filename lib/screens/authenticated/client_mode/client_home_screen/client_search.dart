import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/models/service.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_specific_category/service_tile.dart';
import 'package:quick_service_clone/shared/constants.dart';
import 'package:quick_service_clone/shared/widgets/no_result_widget.dart';

class ClientSearch extends StatefulWidget {
  @override
  _ClientSearchState createState() => _ClientSearchState();
}

class _ClientSearchState extends State<ClientSearch> {
  var _serviceListForDisplay = [];
  String queryText = "";

  @override
  Widget build(BuildContext context) {
    final _serviceList = Provider.of<List<Service>>(context) ?? [];

    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              onChanged: (val) {
                String query = val.toLowerCase();

                setState(() {
                  queryText = query;
                  _serviceListForDisplay = _serviceList
                      .where((element) =>
                          element.title.toLowerCase().contains(query))
                      .toList();
                });

                if (val == "" || val == null) {
                  setState(() {
                    _serviceListForDisplay.clear();
                  });
                }
              },
              decoration: textInputDecoration.copyWith(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search service title here'),
            ),
          ),
          _serviceListForDisplay.length == 0
              ? Expanded(
                  flex: 1,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: NoResultWidget(
                      imagePath: queryText == ""? 'assets/search_now.png':'assets/no_results.png',
                      text: queryText == ""
                          ? 'Search for the service title'
                          : 'No $queryText found',
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _serviceListForDisplay.length,
                  itemBuilder: (context, index) {
                    return ServiceTile(
                      service: _serviceListForDisplay[index],
                    );
                  },
                ),
        ],
      ),
    );
  }
}
