import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'firesbaseMQTT.dart';

Future<void> creatNewPheasantHouse(pheasant_house_name) async {
  DocumentReference farm_id = farm.doc(pheasant_house_name);
  double count = 0;
  await farm_id.set({
    'farm_id': ++count,
    'farm_name': pheasant_house_name,
  });
  CollectionReference subcollection_1 = farm_id.collection('cleaning_day');
  DocumentReference cleaning_id = subcollection_1.doc('cleaningday_id:1');
  await subcollection_1.add({
    await cleaning_id.set({
      'cleaning_day': DateTime.now(),
      'cleaning_id': "1",
    })
  });
  CollectionReference subcollection_2 = farm_id.collection('control');
  DocumentReference control_id1 = subcollection_2.doc('light');
  DocumentReference control_id2 = subcollection_2.doc('sprinkler_roof');
  DocumentReference control_id3 = subcollection_2.doc('sprinkler_trees');
  DocumentReference control_id4 = subcollection_2.doc('fan');
  await subcollection_2.add({
    await control_id1.set({
      'control_id': "01",
      'control_name': "light",
      'status': true,
    }),
    await control_id2.set({
      'control_id': "02",
      'control_name': "sprinkler_roof",
      'status': true,
    }),
    await control_id3.set({
      'control_id': "03",
      'control_name': "sprinkler_trees",
      'status': true,
    }),
    await control_id4.set({
      'control_id': "04",
      'control_name': "fan",
      'status': true,
    }),
  });
  CollectionReference subcollection_3 = farm_id.collection('notification');
  DocumentReference notification_id1 = subcollection_3.doc('temperature');
  DocumentReference notification_id2 = subcollection_3.doc('ammonia');
  await subcollection_3.add({
    await notification_id1.set({
      'notification_id': "01",
      'notification_max': 32,
      'notification_min': 22,
      'notification_name': "temperature",
    }),
    await notification_id2.set({
      'notification_id': "02",
      'notification_max': 20,
      'notification_min': 10,
      'notification_name': "ammonia",
    })
  });
  CollectionReference subcollection_4 = farm_id.collection('sensor');
  DocumentReference sensor_id1 = subcollection_4.doc('temperature');
  DocumentReference sensor_id2 = subcollection_4.doc('soil_moisture');
  DocumentReference sensor_id3 = subcollection_4.doc('light_indensity');
  DocumentReference sensor_id4 = subcollection_4.doc('ammonia');
  await subcollection_4.add({
    await sensor_id1.set({
      'sensor_id':"01",
      'sensor_max':32,
      'sensor_min':20,
      'sensor_name':"temperature",
    }), 
    await sensor_id2.set({
      'sensor_id':"02",
      'sensor_max':70,
      'sensor_min':30,
      'sensor_name':"soil_moisture",
    }), 
    await sensor_id3.set({
      'sensor_id':"03",
      'sensor_max':500,
      'sensor_min':100,
      'sensor_name':"light_indensity",
    }), 
    await sensor_id4.set({
      'sensor_id':"01",
      'sensor_max':20,
      'sensor_min':10,
      'sensor_name':"ammonia",
    }), 
    
  });
  CollectionReference subcollection_5 = farm_id.collection('time');
  DocumentReference time_id1 = subcollection_5.doc('fan');
  DocumentReference time_id2 = subcollection_5.doc('light');
  DocumentReference time_id3 = subcollection_5.doc('sprinkler_roof');
  DocumentReference time_id4 = subcollection_5.doc('sprinkler_trees');
  await subcollection_5.add({
    await time_id1.set({
      'time_id':"1",
      'time_name':"fan",
      'time_on': DateTime.now(),
      'time_off': DateTime.now(),
    }),
    await time_id2.set({
      'time_id':"2",
      'time_name':"light",
      'time_on': DateTime.now(),
      'time_off': DateTime.now(),
    }),await time_id3.set({
      'time_id':"3",
      'time_name':"sprinkler_roof",
      'time_on': DateTime.now(),
      'time_off': DateTime.now(),
    }),await time_id4.set({
      'time_id':"4",
      'time_name':"sprinkler_trees",
      'time_on': DateTime.now(),
      'time_off': DateTime.now(),
    }),
  });
}
