import 'package:assignment/providers/event_provider.dart';
import 'package:assignment/providers/profile_provider.dart';
import 'package:assignment/providers/request_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> providerConfig = [
  ChangeNotifierProvider(create: (_) => ProfileProvider()),
  ChangeNotifierProvider(create: (_) => EventProvider()),
  ChangeNotifierProvider(create: (_) => RequestProvider()),
];
