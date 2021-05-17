import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/models/request.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_request/request_tile.dart';
import 'package:quick_service_clone/screens/authenticated/service_provider_mode/sp_request_tile.dart';
import 'package:quick_service_clone/shared/constants.dart';
import 'package:quick_service_clone/shared/widgets/no_result_widget.dart';

class SpRequest extends StatefulWidget {
  @override
  _SpRequestState createState() => _SpRequestState();
}

class _SpRequestState extends State<SpRequest> {
  List _categoryList = ['Choose category', 'All'];
  List _listForDisplay;

  @override
  void initState() {
    super.initState();
    setState(() {
      Constants.serviceCategories.forEach((element) {
        _categoryList.add(element.name);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _list = Provider.of<List<Request>>(context);

    return LoaderOverlay(
      child: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: <Widget>[
            _buildSelection(_list),
            Expanded(child: _buildList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSelection(List<Request> list) {
    return DropdownButtonFormField(
      decoration: textInputDecoration,
      value: _categoryList[0],
      items: _categoryList.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text('$category'),
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          if (val != 'Choose category') {
            _categoryList.remove('Choose category');
            if (val == 'All') {
              _listForDisplay = list;
            } else {
              _listForDisplay =
                  list.where((element) => element.category == val).toList();
            }
          } else {
            Get.snackbar("Invalid", "Please select a category.");
          }
        });
      },
    );
  }

  Widget _buildList(BuildContext context) {
    return _listForDisplay == null
        ? NoResultWidget(
            imagePath: 'assets/search_now.png',
            text: 'Please select a category.',
          )
        : (_listForDisplay.length == 0
            ? NoResultWidget(
                imagePath: 'assets/no_result_brocolli.png',
                text: 'No request found for this category.',
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: _listForDisplay.length,
                itemBuilder: (context, index) {
                  return SpRequestTile(
                    function: () {
                      context.loaderOverlay.show();
                    },
                    functionStop: () {
                      context.loaderOverlay.hide();
                    },
                    request: _listForDisplay[index],
                  );
                },
              ));
  }
}
