import 'package:flutter/material.dart';
import 'package:lightsout/utils/my_button.dart';
import 'package:fl_chart/fl_chart.dart';

class DetailPage extends StatelessWidget {
  final String area;
  final String feeder;
  final int stage;
  final LinearGradient gradient;
  final List<int> powerOffTimes;

  const DetailPage({
    Key? key,
    required this.area,
    required this.feeder,
    required this.stage,
    required this.gradient,
    required this.powerOffTimes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(area),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Area Alerts':
                  // Handle Area Alerts action
                  break;
                case '15 Minute Alert':
                  // Handle 15 Minute Alert action
                  break;
                case '55 Minute Alert':
                  // Handle 55 Minute Alert action
                  break;
                case 'Calendar Export':
                  // Handle Calendar Export action
                  break;
                case 'Ask My Hood':
                  // Handle Ask My Hood action
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Area Alerts',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Area Alerts'),
                      Switch(
                        value: true,
                        onChanged: (bool value) {
                          // Handle switch toggle
                        },
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: '15 Minute Alert',
                  child: Text('15 Minute Alert'),
                ),
                const PopupMenuItem<String>(
                  value: '55 Minute Alert',
                  child: Text('55 Minute Alert'),
                ),
                const PopupMenuItem<String>(
                  value: 'Calendar Export',
                  child: Text('Calendar Export'),
                ),
                const PopupMenuItem<String>(
                  value: 'Ask My Hood',
                  child: Text('Ask My Hood'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weekly Power Outages',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Historical Power Outages Graph
              SizedBox(
                height: 353,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    borderData: FlBorderData(
                      show: false,
                    ),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return Text('Sun');
                              case 1:
                                return Text('Mon');
                              case 2:
                                return Text('Tue');
                              case 3:
                                return Text('Wed');
                              case 4:
                                return Text('Thur');
                              case 5:
                                return Text('Frid');
                              case 6:
                                return Text('Sat');
                              default:
                                return Text('');
                            }
                          },
                        ),
                      ),
                    ),
                    barGroups: _buildBarGroups(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                      icon: 'lib/icons/trash-can.png',
                      buttonText: 'Remove',
                    ),
                    MyButton(
                      icon: 'lib/icons/calendar.png',
                      buttonText: 'Schedule',
                    ),
                    MyButton(
                      icon: 'lib/icons/urgent.png',
                      buttonText: 'Alerts',
                    ),
                    MyButton(
                      icon: 'lib/icons/send.png',
                      buttonText: 'Share',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    DateTime date = DateTime.now().add(Duration(days: index));
                    return Card(
                      child: ListTile(
                        title: Text(
                          '${_weekdayToString(date.weekday)} ${_monthToString(date.month)} ${date.day}',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(12, (i) {
                                int hour = i * 2;
                                bool isPowerOff =
                                    powerOffTimes.contains(hour) ||
                                        powerOffTimes.contains(hour + 1);
                                return Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color:
                                        isPowerOff ? Colors.red : Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                );
                              }),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(12, (i) {
                                return Text('${i * 2}');
                              }),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    // Example data for the bar chart
    // Replace with actual data as needed
    final List<double> historicalData = [3, 2, 5, 3, 4, 2, 1];

    return List.generate(historicalData.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: historicalData[index],
            color: const Color.fromARGB(255, 12, 18, 22),
            width: 15,
          ),
        ],
      );
    });
  }

  String _weekdayToString(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  String _monthToString(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
