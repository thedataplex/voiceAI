import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  final Map<String, String> data;

  SummaryPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Summary of Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1.0),
            1: FlexColumnWidth(2.0),
          },
          border: TableBorder.all(color: Colors.black),
          children: data.entries.map((entry) => TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(entry.key),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(entry.value),
              ),
            ],
          )).toList(),
        ),
      ),
    );
  }
}
