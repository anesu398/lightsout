import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class FaultReportPage extends StatefulWidget {
  @override
  _FaultReportPageState createState() => _FaultReportPageState();
}

class _FaultReportPageState extends State<FaultReportPage> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<FaultReport> _faultReports = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _loadReportsFromPrefs();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _showNotification(String title, String body) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void _submitReport() {
    if (_locationController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      return;
    }

    final report = FaultReport(
      location: _locationController.text,
      description: _descriptionController.text,
      images: [],
      videos: [],
      attended: false,
    );

    setState(() {
      _faultReports.add(report);
    });

    _locationController.clear();
    _descriptionController.clear();

    _showNotification('New Fault Reported', 'Location: ${report.location}');

    _saveReportsToPrefs();
  }

  Future<void> _pickImage(FaultReport report) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        report.images.add(File(pickedFile.path));
      });
      _saveReportsToPrefs();
    }
  }

  Future<void> _pickVideo(FaultReport report) async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        report.videos.add(File(pickedFile.path));
      });
      _saveReportsToPrefs();
    }
  }

  Future<void> _saveReportsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final reports = _faultReports.map((report) => report.toJson()).toList();
    await prefs.setString('faultReports', jsonEncode(reports));
  }

  Future<void> _loadReportsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final reportsString = prefs.getString('faultReports');
    if (reportsString != null) {
      final List<dynamic> reports = jsonDecode(reportsString);
      setState(() {
        _faultReports =
            reports.map((json) => FaultReport.fromJson(json)).toList();
      });
    }
  }

  void _markAsAttended(FaultReport report) {
    setState(() {
      report.attended = true;
    });
    _saveReportsToPrefs();
  }

  void _deleteReport(FaultReport report) {
    setState(() {
      _faultReports.remove(report);
    });
    _saveReportsToPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Electrical Faults'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReport,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text('Submit Report'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _faultReports.length,
                itemBuilder: (context, index) {
                  final report = _faultReports[index];
                  return Dismissible(
                    key: Key(report.location),
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.check, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        _markAsAttended(report);
                        return false;
                      } else if (direction == DismissDirection.endToStart) {
                        _deleteReport(report);
                        return true;
                      }
                      return false;
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text(report.location),
                        subtitle: Text(report.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.photo),
                              onPressed: () => _pickImage(report),
                            ),
                            IconButton(
                              icon: Icon(Icons.videocam),
                              onPressed: () => _pickVideo(report),
                            ),
                            Icon(
                              report.attended
                                  ? Icons.check_circle
                                  : Icons.error,
                              color:
                                  report.attended ? Colors.green : Colors.red,
                            ),
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FaultReportDetailPage(report: report),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaultReportDetailPage extends StatelessWidget {
  final FaultReport report;

  const FaultReportDetailPage({Key? key, required this.report})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fault Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location: ${report.location}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Description: ${report.description}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Images:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: report.images.length,
                itemBuilder: (context, index) {
                  return Image.file(report.images[index]);
                },
              ),
            ),
            SizedBox(height: 20),
            Text('Videos:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: report.videos.length,
                itemBuilder: (context, index) {
                  return Text(report.videos[index]
                      .path); // Replace with a video player widget
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaultReport {
  final String location;
  final String description;
  final List<File> images;
  final List<File> videos;
  bool attended;

  FaultReport({
    required this.location,
    required this.description,
    required this.images,
    required this.videos,
    this.attended = false,
  });

  Map<String, dynamic> toJson() => {
        'location': location,
        'description': description,
        'images': images.map((image) => image.path).toList(),
        'videos': videos.map((video) => video.path).toList(),
        'attended': attended,
      };

  static FaultReport fromJson(Map<String, dynamic> json) {
    return FaultReport(
      location: json['location'],
      description: json['description'],
      images: (json['images'] as List).map((path) => File(path)).toList(),
      videos: (json['videos'] as List).map((path) => File(path)).toList(),
      attended: json['attended'] ?? false,
    );
  }
}
