import 'package:assignment/models/request_model.dart';
import 'package:assignment/providers/request_provider.dart';
import 'package:assignment/theme/fonts.dart';
import 'package:assignment/utils/formatter.dart';
import 'package:assignment/widgets/components/custom_buttons.dart';
import 'package:assignment/widgets/components/empty_space.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageRequestScreen extends StatefulWidget {
  const ManageRequestScreen({super.key});

  @override
  State<ManageRequestScreen> createState() => _ManageRequestScreenState();
}

class _ManageRequestScreenState extends State<ManageRequestScreen> {
  late RequestProvider _requestProvider;

  List<BaseRequestModel> _searchResults = [];
  String _searchQuery = '';
  final Map<String, bool> _requestTypeFilter = {
    'Feedback': true,
    'Report User': true,
    'Organizer Role Request': true,
  };
  final Map<String, Color> _requestTypeColor = {
    'Feedback': Colors.amber,
    'Report User': Colors.red,
    'Organizer Role Request': Colors.blue,
  };
  final Map<String, bool> _requestStatusFilter = {
    'Pending Review': true,
    'Reviewed': false,
    'Approved': false,
    'Rejected': false,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _requestProvider = Provider.of<RequestProvider>(context);
    _requestProvider.getRequests();
  }

  void onQueryChanged(String query) {
    _searchQuery = query;
    setState(() {
      _searchResults = _requestProvider.requests.where((item) {
        bool matchesTitle =
            item.id!.toLowerCase().contains(query.toLowerCase());
        bool matchesDescription =
            item.description.toLowerCase().contains(query.toLowerCase());
        bool matchesType = _requestTypeFilter[item.type] ?? false;
        bool matchesStatus = _requestStatusFilter[item.status] ?? false;
        return (matchesTitle || matchesDescription) &&
            matchesType &&
            matchesStatus;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget requestPreview;
    onQueryChanged(_searchQuery);
    if (_searchResults.isNotEmpty) {
      requestPreview = ListView.builder(
          itemCount: _searchResults.length,
          itemBuilder: (ctx, index) {
            return RequestPreview(
              request: _searchResults[index],
              color: _requestTypeColor[_searchResults[index].type] ?? Colors.grey,
            );
          });
    } else {
      requestPreview = const Text("No requests found");
    }
    return Column(children: [
      IntrinsicHeight(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 28, 10, 18),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              decoration: const BoxDecoration(
                // color: Color.fromARGB(255, 234, 234, 234),
                border: Border(bottom: BorderSide(width: 2)),
              ),
              child: Column(
                children: [
                  SearchBar(
                    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 16.0)),
                    textStyle: WidgetStateProperty.all(mediumTextStyle),
                    leading: const Icon(Icons.search),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    onChanged: onQueryChanged,
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 12),
                      height: 70,
                      // width: 400,
                      child: GridView.count(
                        childAspectRatio: 5,
                        crossAxisCount: 2,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _requestTypeFilter['Feedback'],
                                onChanged: (val) {
                                  _requestTypeFilter['Feedback'] = val!;
                                  onQueryChanged(_searchQuery);
                                },
                                fillColor: WidgetStateProperty.all(
                                    _requestTypeColor['Feedback']),
                              ),
                              Text(
                                'Feedback',
                                style: smallTextStyle.copyWith(
                                    color: _requestTypeColor['Feedback']),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _requestTypeFilter['Report User'],
                                onChanged: (val) {
                                  _requestTypeFilter['Report User'] = val!;
                                  onQueryChanged(_searchQuery);
                                },
                                fillColor: WidgetStateProperty.all(
                                    _requestTypeColor['Report User']),
                              ),
                              Text('User Report',
                                  style: smallTextStyle.copyWith(
                                    color: _requestTypeColor['Report User'],
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _requestTypeFilter[
                                    'Organizer Role Request'],
                                onChanged: (val) {
                                  _requestTypeFilter['Organizer Role Request'] =
                                      val!;
                                  onQueryChanged(_searchQuery);
                                },
                                fillColor: WidgetStateProperty.all(
                                    _requestTypeColor[
                                        'Organizer Role Request']),
                              ),
                              Text('Organizer Request',
                                  style: smallTextStyle.copyWith(
                                    color: _requestTypeColor[
                                        'Organizer Role Request'],
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _requestStatusFilter['Reviewed'],
                                onChanged: (val) {
                                  _requestStatusFilter['Pending Review'] = !val!;
                                  _requestStatusFilter['Reviewed'] = val;
                                  _requestStatusFilter['Approved'] = val;
                                  _requestStatusFilter['Rejected'] = val;
                                  onQueryChanged(_searchQuery);
                                },
                                fillColor:
                                    WidgetStateProperty.all(Colors.grey),
                              ),
                              Text('Reviewed',
                                  style: smallTextStyle.copyWith(
                                    color: Colors.grey,
                                  )),
                            ],
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
      Flexible(child: requestPreview),
    ]);
  }
}

class RequestPreview extends StatelessWidget {
  const RequestPreview({
    super.key,
    required this.request,
    required this.color,
  });

  final BaseRequestModel request;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        // color: const Color.fromARGB(255, 221, 221, 221),
        gradient: LinearGradient(colors: [
          color.withOpacity(0.4),
          color,
        ]),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Request ID: ',
                style: smallTextStyle,
              ),
              Text(request.id!, style: linkTextStyle.copyWith(decoration: TextDecoration.none, color: Colors.white),)
            ],
          ),
          const VerticalEmptySpace(),
          Row(
            children: [
              const Text(
                'Request Date: ',
                style: smallTextStyle,
              ),
              Text(formatDateTimeToString(request.date), style: linkTextStyle.copyWith(decoration: TextDecoration.none, color: Colors.white),)
            ],
          ),
          const VerticalEmptySpace(),
          Row(
            children: [
              const Text(
                'Request Status: ',
                style: smallTextStyle,
              ),
              Text(request.status, style: linkTextStyle.copyWith(decoration: TextDecoration.none, color: Colors.white),)
            ],
          ),
          const VerticalEmptySpace(),
          Row(
            children: [
              const Text(
                'Request Type: ',
                style: smallTextStyle,
              ),
              Text(request.type, style: linkTextStyle.copyWith(decoration: TextDecoration.none, color: Colors.white),)
            ],
          ),
          const VerticalEmptySpace(),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomActionButton(
              displayText: "View",
              actionOnPressed: () {
                Navigator.of(context)
                    .pushNamed('/view_request', arguments: request);
              },
              width: 70,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}
