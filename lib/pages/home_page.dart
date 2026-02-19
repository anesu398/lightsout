import 'package:flutter/material.dart';
import 'package:lightsout/navigation/custom_tab_bar.dart';
import 'package:lightsout/pages/details.dart';
import 'package:lightsout/pages/fault_report.dart';
import 'package:lightsout/pages/theme.dart';
import 'package:lightsout/utils/area_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFEAF3FF),
                    RiveAppTheme.background,
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),
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
                        const Row(
                          children: [
                            Text(
                              'Lights',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.8,
                                color: Color(0xFF1D1D1F),
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Out',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.8,
                                color: Color(0xFF6E6E73),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _IconContainer(
                              icon: _isSidebarOpen ? Icons.close : Icons.menu,
                              onTap: _toggleSidebar,
                            ),
                            const SizedBox(width: 10),
                            const GoogleUserIcon(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // My Areas
                  Expanded(
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
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              child: Text(
                                'My Area(s)',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                  color: Color(0xFF1D1D1F),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
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
                                      const LinearGradient(
                                        colors: [
                                          Color(0xFF99B8FF),
                                          Color(0xFF4477ED),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.3, 1.0],
                                      ),
                                      [1, 2, 3, 4, 5],
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const MyArea(
                                        area: 'Khumalo',
                                        feeder: 'Ilanda Feeder',
                                        stage: 2,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF99B8FF),
                                            Color(0xFF4477ED),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.3, 1.0],
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
                                      const LinearGradient(
                                        colors: [
                                          Color(0xFF8DE4B4),
                                          Color(0xFF1C8ADB),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.2, 1.0],
                                      ),
                                      [3, 4, 5, 6],
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const MyArea(
                                        area: 'Bulawayo PolyTechnic',
                                        feeder: 'Park Road Feeder',
                                        stage: 1,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF8DE4B4),
                                            Color(0xFF1C8ADB),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.2, 1.0],
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
                                      const LinearGradient(
                                        colors: [
                                          Color(0xFFFB9A9F),
                                          Color(0xFF3556C9),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.1, 1.0],
                                      ),
                                      [8, 9, 10, 11, 14, 15],
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const MyArea(
                                        area: 'Ascot',
                                        feeder: 'Khumalo Feeder',
                                        stage: 3,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFFB9A9F),
                                            Color(0xFF3556C9),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.1, 1.0],
                                        ),
                                        powerOffTimes: [8, 9, 10, 11, 14, 15],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: SmoothPageIndicator(
                                controller: _tabPageController,
                                count: 3,
                                effect: const ExpandingDotsEffect(
                                  dotHeight: 7.0,
                                  dotWidth: 7.0,
                                  activeDotColor: Color(0xFF1D1D1F),
                                  dotColor: Color(0xFFB8BEC8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Nearby Areas with AnimatedSwitcher
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          'Nearby Areas',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            color: Color(0xFF1D1D1F),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: Tween<double>(begin: 0.98, end: 1)
                                  .animate(animation),
                              child: child,
                            ),
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
              color: Colors.white.withOpacity(0.96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      setState(() {
                        _isSidebarOpen = false;
                        _homePageController.jumpToPage(0);
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      setState(() {
                        _isSidebarOpen = false;
                        _homePageController.jumpToPage(0);
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
      ),
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
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: RiveAppTheme.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE3E3E8)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 64,
              width: 64,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Image.asset(iconPath),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    areaName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        size: 16,
                        color: Color(0xFF6E6E73),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          feederName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6E6E73),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF8E8E93),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _IconContainer extends StatelessWidget {
  const _IconContainer({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withOpacity(0.95),
          border: Border.all(color: const Color(0xFFE5E5EA)),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF1D1D1F)),
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
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.95),
        border: Border.all(color: const Color(0xFFE5E5EA)),
      ),
      child: const Icon(
        Icons.settings,
        color: Color(0xFF2C2C2E),
        size: 20,
      ),
    );
  }
}
