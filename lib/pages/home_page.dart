import 'package:flutter/material.dart';
import 'package:lightsout/pages/details.dart';
import 'package:lightsout/pages/fault_report.dart'; // Import the reporting page
import 'package:lightsout/utils/area_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lightsout/pages/theme.dart';
import 'package:lightsout/navigation/custom_tab_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homePageController = PageController();
  final _tabPageController = PageController();
  int _currentTabIndex = 0;
  bool _isSidebarOpen = false;

  @override
  void dispose() {
    _homePageController.dispose();
    _tabPageController.dispose();
    super.dispose();
  }

  void _navigateToDetails(String area, String feeder, int stage,
      LinearGradient gradient, List<int> powerOffTimes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          area: area,
          feeder: feeder,
          stage: stage,
          gradient: gradient,
          powerOffTimes: powerOffTimes,
        ),
      ),
    );
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void _onTabChange(int newIndex) {
    setState(() {
      _currentTabIndex = newIndex;
      if (newIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FaultReportPage(),
          ),
        );
      } else {
        _tabPageController.animateToPage(
          newIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RiveAppTheme.background,
      body: Stack(
        children: [
          // Main content
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Lights',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                                width:
                                    5), // Adding some space between the two texts
                            Text(
                              'Out',
                              style: TextStyle(fontSize: 28),
                            ),
                          ],
                        ),
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.add),
                            ),
                            SizedBox(width: 10), // Adding space between icons
                            GoogleUserIcon(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // My Areas
                  Expanded(
                    // Ensures the PageView takes all available space
                    child: PageView(
                      controller: _homePageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentTabIndex = page;
                        });
                      },
                      children: [
                        // Home page content
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: const Text(
                                'My Area(s)',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: PageView(
                                controller: _tabPageController,
                                onPageChanged: (int page) {
                                  setState(() {
                                    _currentTabIndex = page;
                                  });
                                },
                                children: [
                                  GestureDetector(
                                    onTap: () => _navigateToDetails(
                                      'Khumalo',
                                      'Ilanda Feeder',
                                      2,
                                      LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 164, 137, 247),
                                          Color(0xFF7850F0),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.5, 1.0],
                                      ),
                                      [1, 2, 3, 4, 5],
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: MyArea(
                                        area: 'Khumalo',
                                        feeder: 'Ilanda Feeder',
                                        stage: 2,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(151, 103, 146, 255),
                                            Color(0xFF6792FF),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.5, 1.0],
                                        ),
                                        powerOffTimes: [1, 2, 3, 4, 5],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _navigateToDetails(
                                      'Bulawayo PolyTechnic',
                                      'Park Road Feeder',
                                      1,
                                      LinearGradient(
                                        colors: [
                                          Color.fromARGB(183, 73, 219, 92),
                                          Colors.blue,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.5, 1.0],
                                      ),
                                      [3, 4, 5, 6],
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: MyArea(
                                        area: 'Bulawayo PolyTechnic',
                                        feeder: 'Park Road Feeder',
                                        stage: 1,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(183, 73, 219, 92),
                                            Colors.blue,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.5, 1.0],
                                        ),
                                        powerOffTimes: [3, 4, 5, 6],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _navigateToDetails(
                                      'Ascot',
                                      'Khumalo Feeder',
                                      3,
                                      LinearGradient(
                                        colors: [
                                          Color.fromARGB(113, 185, 4, 13),
                                          Colors.indigo,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.5, 1.0],
                                      ),
                                      [8, 9, 10, 11, 14, 15],
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: MyArea(
                                        area: 'Ascot',
                                        feeder: 'Khumalo Feeder',
                                        stage: 3,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(113, 185, 4, 13),
                                            Colors.indigo,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.5, 1.0],
                                        ),
                                        powerOffTimes: [8, 9, 10, 11, 14, 15],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                            Align(
                              alignment: Alignment.center,
                              child: SmoothPageIndicator(
                                controller: _tabPageController,
                                count: 3,
                                effect: ExpandingDotsEffect(
                                  dotHeight: 8.0,
                                  dotWidth: 8.0,
                                  activeDotColor: Colors.grey[800]!,
                                  dotColor: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Nearby Areas with AnimatedSwitcher
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: const Text(
                          'Nearby Areas',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Column(
                          key: ValueKey<int>(_currentTabIndex),
                          children: [
                            Padding(
                              key: ValueKey<int>(_currentTabIndex),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: _buildNearbyArea(
                                'lib/icons/byo.png',
                                _getNearbyAreaName(_currentTabIndex),
                                _getNearbyFeederName(_currentTabIndex),
                              ),
                            ),
                            if (_currentTabIndex + 1 < 3)
                              Padding(
                                key: ValueKey<int>(_currentTabIndex + 1),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: _buildNearbyArea(
                                  'lib/icons/byo.png',
                                  _getNearbyAreaName(_currentTabIndex + 1),
                                  _getNearbyFeederName(_currentTabIndex + 1),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Custom sidebar
          if (_isSidebarOpen)
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: () {
                      // Implement action
                      setState(() {
                        _isSidebarOpen = false;
                        _homePageController.jumpToPage(0); // Jump to home page
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {
                      // Implement action
                      setState(() {
                        _isSidebarOpen = false;
                        _homePageController
                            .jumpToPage(1); // Jump to settings page
                      });
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomTabBar(
        onTabChange: _onTabChange,
      ), // External custom bottom navigation bar
    );
  }

  String _getNearbyAreaName(int index) {
    switch (index % 3) {
      case 0:
        return 'Woodlands';
      case 1:
        return 'Parklands';
      case 2:
        return 'ZITF';
      default:
        return '';
    }
  }

  String _getNearbyFeederName(int index) {
    switch (index % 3) {
      case 0:
        return 'City of Bulawayo Main Feeder';
      case 1:
        return 'Khumalo Main Feeder';
      case 2:
        return '33Kv feeder';
      default:
        return '';
    }
  }

  Widget _buildNearbyArea(String iconPath, String areaName, String feederName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(iconPath),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                areaName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    Icons.transform,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    feederName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_rounded),
        ],
      ),
    );
  }
}

class GoogleUserIcon extends StatelessWidget {
  const GoogleUserIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.settings,
          color: Color.fromARGB(255, 36, 34, 34), size: 20),
    );
  }
}
