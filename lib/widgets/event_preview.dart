import 'package:assignment/models/event_model.dart';
import 'package:assignment/theme/fonts.dart';
import 'package:assignment/widgets/components/custom_buttons.dart';
import 'package:assignment/widgets/components/empty_space.dart';
import 'package:flutter/material.dart';

class EventPreview extends StatelessWidget {
  const EventPreview({super.key, required this.event});

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 288,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          shadowColor: Colors.black,
          elevation: 5,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: eventStatusColor[event.status]!, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        image: NetworkImage(event.imageLink),
                        width: 88,
                        height: 88,
                      ),
                    ),
                    const HorizontalEmptySpace(),
                    Flexible(
                      child: Text(
                        event.title,
                        style: mediumTextStyle,
                      ),
                    )
                  ],
                ),
                const VerticalEmptySpace(),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 90,
                      child: Text(
                        event.description,
                        style: smallTextStyle,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomActionButton(
                            displayText: "View",
                            actionOnPressed: () {
                              Navigator.of(context).pushNamed('/event_details', arguments: event);
                            },
                            width: 70,
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
