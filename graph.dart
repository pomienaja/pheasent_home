import 'firesbaseMQTT.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

class FirestoreChart extends StatefulWidget {
  @override
  _FirestoreChartState createState() => _FirestoreChartState();
}

class _FirestoreChartState extends State<FirestoreChart> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Set the start date to the maximum possible value (e.g., very far in the past)
                  _startDate = DateTime(1900);
                  // Set the end date to the current date
                  _endDate = DateTime.now();
                });
              },
              child: Text("Select Maximum Date Range"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Set the start date to the current date
                  _startDate = DateTime.now();
                  // Set the end date to the minimum possible value (e.g., very far in the future)
                  _endDate = DateTime(2100);
                });
              },
              child: Text("Select Minimum Date Range"),
            ),
          ],
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('your_collection')
              .where('timestamp', isGreaterThanOrEqualTo: _startDate)
              .where('timestamp', isLessThanOrEqualTo: _endDate)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text('No data available');
            }

            List<DocumentSnapshot> documents = snapshot.data!
                .docs; // ใช้ ! สำหรับการแน่ใจว่า snapshot.data ไม่เป็น null

            if (documents.isEmpty) {
              return Text('No documents available');
            }

            // ตรวจสอบ DocumentReference ของเอกสารแรกใน List
            DocumentReference? docRef = documents[0].reference;
            if (docRef == null) {
              return Text('Invalid document reference');
            }

            // แสดงข้อมูลใน BarChart หรือทำอย่างอื่นต่อไป
            return BarChart(
              BarChartData(
                  // Other configurations...
                  ),
            );
          },
        ),
      ],
    );
  }
}
