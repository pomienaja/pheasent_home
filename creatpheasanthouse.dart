import 'package:mqtt_client/mqtt_client.dart';

// สร้าง enum สำหรับสถานะของการเชื่อมต่อ MQTT
enum MqttConnectionStatus {
  connecting,
  connected,
  disconnected,
}

// ฟังก์ชันสำหรับเชื่อมต่อ MQTT และตรวจสอบสถานะการเชื่อมต่อ
Future<MqttConnectionStatus> connectAndSubscribeToMQTT(String server, String clientId) async {
  // เชื่อมต่อ MQTT client
  MqttClient mqttClient = MqttClient(server, clientId);
  try {
    await mqttClient.connect();
   
    return MqttConnectionStatus.connected;
  } catch (e) {
    print('Failed to connect to MQTT broker: $e');
    return MqttConnectionStatus.disconnected;
  }
}

void main() async {
  // ใช้ฟังก์ชันเพื่อเชื่อมต่อ MQTT broker และตรวจสอบสถานะการเชื่อมต่อ
  MqttConnectionStatus status = await connectAndSubscribeToMQTT('mqtt.example.com', 'client-id');

  // ตรวจสอบสถานะและแสดงผลลัพธ์
  if (status == MqttConnectionStatus.connected) {
    print('Connected to MQTT broker and subscribed to topic.');
  } else {
    print('Failed to connect to MQTT broker.');
  }
}
