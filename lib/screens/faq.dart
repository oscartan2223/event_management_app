import 'package:assignment/widgets/header_bar.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do you answer my second question?',
      'answer': 'This is the answer to your second question.',
    },
    {
      'question': 'How do I organize an event using GesT?',
      'answer': 'Here is the guide to organize an event using GesT.',
    },
    {
      'question': 'How can I become an event organizer?',
      'answer': 'To become an event organizer, follow these steps...',
    },
  ];

  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(headerTitle: 'FAQs', menuRequired: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(_faqs.length, (index) {
                final faq = _faqs[index];
                return Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text(
                      faq['question'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _expandedIndex == index
                            ? Colors.blue
                            : Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      _expandedIndex == index
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.blue,
                    ),
                    children: [
                      const Divider(color: Colors.blue, thickness: 1),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          faq['answer'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _expandedIndex = expanded ? index : -1;
                      });
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
