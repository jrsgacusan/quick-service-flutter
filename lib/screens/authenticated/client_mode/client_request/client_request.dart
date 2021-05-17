import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:quick_service_clone/models/request.dart';
import 'package:quick_service_clone/services/auth_service.dart';
import 'package:quick_service_clone/services/database_service.dart';
import 'package:quick_service_clone/shared/constants.dart';
import 'package:quick_service_clone/shared/widgets/button_widget.dart';
import 'package:quick_service_clone/shared/widgets/hint_widget.dart';
import 'package:quick_service_clone/shared/widgets/snackbar_widget.dart';

class ClientRequest extends StatefulWidget {
  @override
  _ClientRequestState createState() => _ClientRequestState();
}

class _ClientRequestState extends State<ClientRequest> {
  bool isHintShown = true;
  final _formKey = GlobalKey<FormState>();
  static final List<String> _list =
      Constants.serviceCategories.map((e) => e.name).toList();

  //states
  String _title;

  String _description;

  double _price;
  String _currentCategory;

  @override
  Widget build(BuildContext context) {
    Request request = ModalRoute.of(context).settings.arguments;

    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(
              '${request.uid == null ? "Create request" : "Edit request"}'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildHintPart(),
                  _buildForm(request),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(Request request) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'REQUEST DETAILS',
              style: TextStyle(fontSize: 24),
            ),
            Divider(
              height: 24,
            ),
            TextFormField(
              validator: (val) {
                return val.length == 0 || val.length > 20
                    ? 'Invalid title'
                    : null;
              },
              initialValue: request.uid == null ? "" : request.title,
              onChanged: (val) {
                setState(() {
                  _title = val;
                });
              },
              decoration: textInputDecoration.copyWith(
                prefixIcon: Icon(Icons.title),
                hintText: 'Request title',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[200], width: 1.0),
                ),
                counterText: _title == null
                    ? (request.uid == null
                        ? "0/20"
                        : "${request.title.length}/20")
                    : "${_title.length}/20",
                counterStyle: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            TextFormField(
              validator: (val) {
                return val.length == 0 || val.length > 300
                    ? "Invalid description."
                    : null;
              },
              maxLines: 5,
              minLines: 1,
              initialValue: request.uid == null ? "" : request.description,
              onChanged: (val) {
                setState(() {
                  _description = val;
                });
              },
              decoration: textInputDecoration.copyWith(
                prefixIcon: Icon(Icons.description),
                hintText: 'Description',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[200], width: 1.0),
                ),
                counterText: _description == null
                    ? (request.uid == null
                        ? "0/300"
                        : "${request.description.length}/300")
                    : "${_description.length}/300",
                counterStyle: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            TextFormField(
              validator: (val) {
                return double.parse(val) < 300
                    ? "Price must not be less than 300."
                    : null;
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              initialValue:
                  request.uid == null ? "0.0" : request.price.toString(),
              onChanged: (val) {
                setState(() {
                  _price = double.parse(val);
                });
              },
              decoration: textInputDecoration.copyWith(
                prefixIcon: Icon(Icons.money),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[200], width: 1.0),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            DropdownButtonFormField(
              decoration: textInputDecoration.copyWith(
                prefixIcon: Icon(Icons.category),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[200], width: 1.0),
                ),
              ),
              value: request.uid == null ? _list[0] : request.category,
              items: _list.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text('${category}'),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _currentCategory = val;
                });
              },
            ),
            SizedBox(
              height: 16,
            ),
            RaisedGradientButton(
                child: Text(
                  request.uid == null ? 'Create' : 'Save',
                  style: TextStyle(color: Colors.white),
                ),
                gradient: LinearGradient(
                  colors: <Color>[Colors.tealAccent[400], Colors.teal],
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    context.loaderOverlay.show();
                    Request requestToBePosted;
                    if (request.uid == null) {
                      requestToBePosted = Request.New(
                          title: _title,
                          category: _currentCategory ??
                              Constants.serviceCategories[0].name,
                          //todo
                          description: _description,
                          price: _price,
                          requestedBy: AuthService().currentUserUid);
                    } else {
                      requestToBePosted = Request.Complete(
                          title: _title ?? request.title,
                          description: _description ?? request.description,
                          price: _price ?? request.price,
                          requestedBy: request.requestedBy,
                          uid: request.uid,
                          category: _currentCategory ?? request.category);
                    }
                    bool result =
                        await DatabaseService(uid: AuthService().currentUserUid)
                            .updateRequest(requestToBePosted);
                    if (result) {
                      SnackbarWidget(
                              context: context,
                              text: "Request saved.",
                              label: "",
                              onPressed: () {})
                          .showSnackbar();
                      Navigator.pop(context);
                      context.loaderOverlay.hide();
                    } else {
                      context.loaderOverlay.hide();
                      SnackbarWidget(
                              context: context,
                              text: "Failed. Try again.",
                              label: "",
                              onPressed: () {})
                          .showSnackbar();
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }

  _buildHintPart() {
    return isHintShown
        ? Column(
            children: [
              HintWidget(
                  callback: () {
                    setState(() {
                      isHintShown = false;
                    });
                  },
                  text:
                      "She nervously peered over the edge. She understood in her mind that the view was supposed to be beautiful, but all she felt was fear. ",
                  title: "How does requests work?"),
              SizedBox(
                height: 12,
              )
            ],
          )
        : SizedBox(
            height: 0,
          );
  }
}
