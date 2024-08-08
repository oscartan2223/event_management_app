import 'package:assignment/models/event_model.dart';
import 'package:assignment/models/profile_model.dart';
import 'package:assignment/providers/event_provider.dart';
import 'package:assignment/providers/profile_provider.dart';
import 'package:assignment/screens/event_calendar.dart';
import 'package:assignment/screens/manage_request_screen.dart';
import 'package:assignment/screens/profile_screen.dart';
import 'package:assignment/services/auth_service.dart';
import 'package:assignment/theme/colors.dart';
import 'package:assignment/theme/fonts.dart';
import 'package:assignment/widgets/components/custom_buttons.dart';
import 'package:assignment/widgets/components/empty_space.dart';
import 'package:assignment/widgets/event_preview.dart';
import 'package:assignment/widgets/header_bar.dart';
import 'package:assignment/widgets/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Future<void> _profileFuture;

  late int _selectedIndex;

  void _onSelected(int index) { 
    Provider.of<ProfileProvider>(context, listen: false).changeIndex(index);
    setState(() {
        _selectedIndex = index;
      });
  }

  @override
  void initState() {
    _selectedIndex = context.read<ProfileProvider>().index;
    _profileFuture = context.read<ProfileProvider>().initializeProfile(AuthService().currentUser!.email!);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading profile'));
        } else {
          ProfileModel userProfile = Provider.of<ProfileProvider>(context).userProfile!;

          final List<Widget> widgetList = <Widget>[
            HomeBody(userType: userProfile.type),
            userProfile.type != UserType.administrator
                ? const EventCalendarScreen()
                : const ManageRequestScreen(),
            // const ManageRequestScreen(),
            ProfileScreen(userProfile: userProfile),
          ];
    return Scaffold(
      appBar: const HeaderBar(
        customAction: null,
        headerTitle: 'GesT EMS',
        menuRequired: true,
      ),
      endDrawer: CustomSideBar(
        accountName: userProfile.username,
        imageUrl: userProfile.imageLink,
        userType: userProfile.type,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 28,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              userProfile.type != UserType.administrator ? Icons.calendar_month : Icons.edit_document,
              // Icons.calendar_month,
              size: 28,
            ),
            label: userProfile.type != UserType.administrator ? 'Event Calendar' : 'Manage Request',
            // label: '111',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 28,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: CustomizedColors.selectedColor,
        unselectedItemColor: CustomizedColors.unselectedColor,
        onTap: _onSelected,
      ),
      body: widgetList[_selectedIndex],
    );
  }});
}}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key, required this.userType});

  final UserType userType;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {

  late EventProvider _eventProvider;

  List<EventModel> _searchResults = [];
  String _searchQuery = '';
  final Map<EventStatus, bool> _eventStatusFilter = {
    EventStatus.cancelled: true,
    EventStatus.completed: true,
    EventStatus.ongoing: true,
    EventStatus.rescheduled: true,
    EventStatus.scheduled: true,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _eventProvider = Provider.of<EventProvider>(context);
    _eventProvider.getEvents();
  }

    void onQueryChanged(String query) {
      _searchQuery = query;
      setState(() {
        _searchResults = _eventProvider.events.where((item) {
          // _searchResults = sampleEvents.where((item) {
          bool matchesTitle =
              item.title.toLowerCase().contains(query.toLowerCase());
          bool matchesDescription =
              item.description.toLowerCase().contains(query.toLowerCase());
          bool matchesEventStatus = _eventStatusFilter[item.status] ?? false;
          // return matchesTitle || matchesDescription;
          return (matchesTitle || matchesDescription) && matchesEventStatus;
        }).toList();
      });
    }

  @override
  Widget build(BuildContext context) {
    Widget eventsPreview;
    if (_searchResults.isNotEmpty) {
      if (widget.userType == UserType.organizer) {
        eventsPreview = ListView.builder(
            itemCount: _searchResults.length + 1,
            itemBuilder: (ctx, index) {
              if (index == _searchResults.length) {
                return const VerticalEmptySpace(
                  height: 100,
                );
              }
              return EventPreview(event: _searchResults[index]);
            });
      } else {
        eventsPreview = ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (ctx, index) {
              return EventPreview(event: _searchResults[index]);
            });
      }
    } else {
      eventsPreview = const Text("No events found");
      onQueryChanged(_searchQuery);
    }
    return Column(
      children: [
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
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 16.0)),
                      textStyle: WidgetStateProperty.all(mediumTextStyle),
                      leading: const Icon(Icons.search),
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      onChanged: onQueryChanged,
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 12),
                        height: 50,
                        // width: 400,
                        child: GridView.count(
                          childAspectRatio: 5,
                          crossAxisCount: 3,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value:
                                      _eventStatusFilter[EventStatus.scheduled],
                                  onChanged: (val) {
                                    _eventStatusFilter[EventStatus.scheduled] =
                                        val!;
                                    onQueryChanged(_searchQuery);
                                  },
                                  fillColor: WidgetStateProperty.all(
                                      eventStatusColor[EventStatus.scheduled]),
                                ),
                                Text(
                                  'Scheduled',
                                  style: smallTextStyle.copyWith( 
                                      color: eventStatusColor[
                                          EventStatus.scheduled]),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value:
                                      _eventStatusFilter[EventStatus.ongoing],
                                  onChanged: (val) {
                                    _eventStatusFilter[EventStatus.ongoing] =
                                        val!;
                                    onQueryChanged(_searchQuery);
                                  },
                                  fillColor: WidgetStateProperty.all(
                                      eventStatusColor[EventStatus.ongoing]),
                                ),
                                Text('Ongoing',
                                    style: smallTextStyle.copyWith( 
                                      color:
                                          eventStatusColor[EventStatus.ongoing],
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value:
                                      _eventStatusFilter[EventStatus.completed],
                                  onChanged: (val) {
                                    _eventStatusFilter[EventStatus.completed] =
                                        val!;
                                    onQueryChanged(_searchQuery);
                                  },
                                  fillColor: WidgetStateProperty.all(
                                      eventStatusColor[EventStatus.completed]),
                                ),
                                Text('Completed',
                                    style: smallTextStyle.copyWith( 
                                      color: eventStatusColor[
                                          EventStatus.completed],
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value:
                                      _eventStatusFilter[EventStatus.cancelled],
                                  onChanged: (val) {
                                    _eventStatusFilter[EventStatus.cancelled] =
                                        val!;
                                    onQueryChanged(_searchQuery);
                                  },
                                  fillColor: WidgetStateProperty.all(
                                      eventStatusColor[EventStatus.cancelled]),
                                ),
                                Text(
                                  'Cancelled',
                                  style: smallTextStyle.copyWith( 
                                      color: eventStatusColor[
                                          EventStatus.cancelled]),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value:
                                      _eventStatusFilter[EventStatus.rescheduled],
                                  onChanged: (val) {
                                    _eventStatusFilter[EventStatus.rescheduled] =
                                        val!;
                                    onQueryChanged(_searchQuery);
                                  },
                                  fillColor: WidgetStateProperty.all(
                                      eventStatusColor[EventStatus.rescheduled]),
                                ),
                                Text(
                                  'Rescheduled',
                                  style: smallTextStyle.copyWith(fontSize: 13, 
                                      color: eventStatusColor[
                                          EventStatus.rescheduled]),
                                ),
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
        Flexible(
            // child: eventsPreview,
            child: widget.userType == UserType.organizer
                ? HomeBodyDisplay(eventsPreview: eventsPreview)
                : eventsPreview),
      ],
    );
  }
}

class HomeBodyDisplay extends StatelessWidget {
  const HomeBodyDisplay({super.key, required this.eventsPreview});

  final Widget eventsPreview;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        eventsPreview,
        Align(
          alignment: Alignment.bottomCenter,
          child: ColoredBox(
            color: const Color.fromARGB(255, 216, 216, 216).withOpacity(0.6),
            child: SizedBox(
              height: 90,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: CustomActionButton(
                  displayText: 'Organize Events',
                  actionOnPressed: () {
                    Navigator.of(context).pushNamed('/organize_event');
                  }),
            ))
      ],
    );
  }
}

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return const SearchBar();
  }
}

