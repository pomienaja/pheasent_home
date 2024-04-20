//import 'dart:ffi';

//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//import 'package:pheasant_house/screen/mqtt/mqtt.dart';
//import 'package:flutter/material.dart';
//import 'package:pheasant_house/constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

//อ้างอิงถึง collection User
CollectionReference users = firestore.collection('User');

//อ้างอิงถึง Document ภายในของ collection user โดยใช้ชื่อ farm_1
DocumentReference users_doc = users.doc('O9OyAbjizgupwiP87XXf');

//อ้างอิงถึง collection ภายใน Document รหัส O9OyAbjizgupwiP87XXf ของ collection users
//CollectionReference smart_farm = users_doc.collection('smart_farm');
CollectionReference farm = users_doc.collection('farm');
CollectionReference role = users_doc.collection('role');

//อ้างอิงถึง doc ของfarm
DocumentReference farm_doc1 = farm.doc('aUXxaWWPtxhGEGs5mqn0');

//อ้างอิง collection ต่างใน document_id ที่1  ของ collection farm
CollectionReference cleaning_day = farm_doc1.collection('cleaning_day');
DocumentReference cleaning_day_doc = cleaning_day.doc('fzJPvNw0zfpD2tcyEfZe');
CollectionReference control = farm_doc1.collection('control');
CollectionReference environment = farm_doc1.collection('evironment');
CollectionReference notification = farm_doc1.collection('notification');
CollectionReference sensor = farm_doc1.collection('sensor');
CollectionReference time = farm_doc1.collection('time');

//อ้างอิง document ต่างๆ ของcollection control
DocumentReference control_fan_doc = control.doc('0GGK5FRsJOzOIbnj2vIF');
DocumentReference control_sprinkler_roof_doc =
    control.doc('0oPVWf38aSbbgXCX6Rxi');
DocumentReference control_sprinkler_trees_doc =
    control.doc('9KPI33ZWxxS5WGl292qn');
DocumentReference control_light_doc = control.doc('aaYqGFgNZyog9f8lmJfB');

//อ้างอิง document ต่างๆของ collection notification
DocumentReference notification_temp_doc =
    notification.doc('8NFHciYUDQ8uErFLpYu2');
DocumentReference notification_ammonia_doc =
    notification.doc('ZD4esrSq3ffAepIQ7C35');

//อ้างอิง document ต่างๆของ collection sensor
DocumentReference sensor_light_indensity_doc =
    sensor.doc('4MrC6M7pXCitFMf32Xbw');
DocumentReference sensor_temp_doc = sensor.doc('SW7ccNbFQnhDh96HKdZd');
DocumentReference sensor_ammonia_doc = sensor.doc('mr58mWH4qrmndiyEhwn3');
DocumentReference sensor_soil_moisture_doc = sensor.doc('wmR8udl32piXSAdzNSZa');

//
DocumentReference time_sprinkler_roof_doc = time.doc('lsdXJVK75DNdHIR07LpP');
DocumentReference time_light_doc = time.doc('rdcM3d8AP6oR8kQ4xGbI');
DocumentReference time_fan_doc = time.doc('s52XDdcxGNVscV0fhmZ2');
DocumentReference time_sprinkler_trees_doc = time.doc('us1uNTyRTi8G9p7D1EEo');

Future<void> updateCleaningDay(
  int daysAhead,
  int hour, 
  int minute,
) async {
  // กำหนดวันด้วยตัวแปร daysAhead กำหนดชั่วโมงด้วย hour นาทีด้วย minute โยนค่าเข้ามาซะ

  // สร้างวันที่ล่วงหน้าโดยใช้ DateTime เริ่มจากวันปัจจุบัน
  DateTime futureDate = DateTime.now().add(Duration(days: daysAhead));

  //กำหนดวันที่เเละเวลาที่ต้องการเเจ้งเตือน
  DateTime customDateTime = DateTime(
    futureDate.year,
    futureDate.month,
    futureDate.day,
    hour,
    minute,
  );

  // สร้าง Timestamp จากวันที่ล่วงหน้า
  Timestamp cleaningday = Timestamp.fromDate(customDateTime);
  Map<String, dynamic> updatecleaning_day = {
    'cleaning_day': cleaningday,
  };
  try {
    await cleaning_day_doc.update(updatecleaning_day);
    print("update successfully to cleaning_day ");
  } catch (error) {
    print("Failed to update to cleaning_day: $error");
  }
}

Future<void> addDataToControl(
  //ต้องทำ method ที่ ใช้ update ค่าเเล้วเรียกดูประวัติด้วย
  bool status,
  String id,
  String name,
) async {
  Map<String, dynamic> addcontrol = {
    'control_id': id,
    'control_name': name,
    'status': status,
  };
  try {
    await FirebaseFirestore.instance.collection('control').add(addcontrol);
    print("Data added successfully to control ");
  } catch (error) {
    print("Failed to add data to control: $error");
  }
}
/*//ต้องเเเก้ให้ method ส่งค่าเก็บค่าเรียกดูประวัติเเละupdate ค่าreal time
Future<void> addDataToEvironment(
  double tempTopic,
  double humidityTopic,
  double ldrTopic,
  double mqTopic,
  double soilTopic,
) async {
  Map<String, dynamic> environment = {
    'Ammonia': mqTopic,
    'Humidity': humidityTopic,
    'LightIntensity': ldrTopic,
    'SoilMoisture': soilTopic,
    'Temperature': tempTopic,
  };

  try {
    await firestore.collection('environment').add(environment);
    print("Data added successfully to Firestore");
  } catch (error) {
    print("Failed to add data to Firestore: $error");
  }
} */

Future<void> updateNotification(
  String notification_name,
  double notification_max,
  double notification_min,
) async {
  try {
    // ดึงข้อมูลเดิมออกมาก่อน
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('notification')
        .doc(notification_name)
        .get();
    // สร้าง Map ของข้อมูลก่อนหน้า
    Map<String, dynamic> previousData = snapshot.data() as Map<String, dynamic>;
    // อัปเดตข้อมูลใหม่
    Map<String, dynamic> updated_notification = {
      'notification_max': notification_max,
      'notification_min': notification_min,
    };
    // ทำการอัปเดตข้อมูล
    await FirebaseFirestore.instance
        .collection('notification')
        .doc(notification_name)
        .update(updated_notification);

    print("Data updated successfully in control");

    // เก็บข้อมูลก่อนหน้าไว้ในตัวแปรหรือทำอย่างอื่นตามต้องการ
    print("Previous data: $previousData");
  } catch (error) {
    print("Failed to update data in control: $error");
  }
}

Future<void> updateDataToSensor(
  String sensor_name,
  double sensor_max,
  double sensor_min,
) async {
  try {
// ดึงข้อมูลเดิมออกมาก่อน
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('sensor')
        .doc(sensor_name)
        .get();
    // สร้าง Map ของข้อมูลก่อนหน้า
    Map<String, dynamic> previousData = snapshot.data() as Map<String, dynamic>;
    // อัปเดตข้อมูลใหม่
    Map<String, dynamic> updated_sensor = {
      'sensor_max': sensor_max,
      'sensor_min': sensor_min,
    };
    // ทำการอัปเดตข้อมูล
    await FirebaseFirestore.instance
        .collection('sensor')
        .doc(sensor_name)
        .update(updated_sensor);

    print("Data updated successfully in sensor");

    // เก็บข้อมูลก่อนหน้าไว้ในตัวแปรหรือทำอย่างอื่นตามต้องการ
    print("Previous data: $previousData");
  } catch (error) {
    print("Failed to update data in sensor: $error");
  }
}

Future<void> updatetime_on(
  String doc_time_id,
  int hour_on,
  int minute_on,
) async {
  DateTime now = DateTime.now();
  DateTime customTime = DateTime(
    now.year,
    now.month,
    now.day,
    hour_on,
    minute_on,
  );
  
  Timestamp time_on = Timestamp.fromDate(customTime);
   Map<String, dynamic> update_time_on = {
    'time_on': time_on
   };
  try{
    
    DocumentReference time_doc = FirebaseFirestore.instance.collection('time').doc(doc_time_id);
     
     await time_doc.update(update_time_on);
    print("update successfully to time_on ");
  }catch(error){
    print("Failed to update to time_on: $error");
  }
}
Future<void> updatetime_off(
  String doc_time_id,
  int hour_off,
  int minute_off,
) async {
  DateTime now = DateTime.now();
  DateTime customTime = DateTime(
    now.year,
    now.month,
    now.day,
    hour_off,
    minute_off,
  );
  
  Timestamp time_off = Timestamp.fromDate(customTime);
   Map<String, dynamic> update_time_off = {
    'time_off': time_off
   };
  try{
    
    DocumentReference time_doc = FirebaseFirestore.instance.collection('time').doc(doc_time_id);
     
     await time_doc.update(update_time_off);
    print("update successfully to time_off ");
  }catch(error){
    print("Failed to update to time_off: $error");
  }
}