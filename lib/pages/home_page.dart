import 'package:flutter/material.dart';
import 'package:lightsout/navigation/custom_tab_bar.dart';
import 'package:lightsout/pages/details.dart';
import 'package:lightsout/pages/fault_report.dart';
import 'package:lightsout/pages/theme.dart';
import 'package:lightsout/utils/area_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homePageController = PageController();
  final _tabPageController = PageController();

  int _currentTabIndex = 0;
  bool _isSidebarOpen = false;

  final List<_AreaCardData> _areas = const [
    _AreaCardData(
      area: 'Khumalo',
      feeder: 'Ilanda Feeder',
      stage: 2,
      powerOffTimes: [1, 2, 3, 4, 5],
      gradient: LinearGradient(
        colors: [Color(0xFF99B8FF), Color(0xFF4477ED)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.3, 1.0],
      ),
    ),
    _AreaCardData(
      area: 'Bulawayo PolyTechnic',
      feeder: 'Park Road Feeder',
      stage: 1,
      powerOffTimes: [3, 4, 5, 6],
      gradient: LinearGradient(
        colors: [Color(0xFF8DE4B4), Color(0xFF1C8ADB)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.2, 1.0],
      ),
    ),
    _AreaCardData(
      area: 'Ascot',
      feeder: 'Khumalo Feeder',
      stage: 3,
      powerOffTimes: [8, 9, 10, 11, 14, 15],
      gradient: LinearGradient(
        colors: [Color(0xFFFB9A9F), Color(0xFF3556C9)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.1, 1.0],
      ),
    ),
  ];

  @override
  void dispose() {
    _homePageController.dispose();
    _tabPageController.dispose();
    super.dispose();
  }

  void _navigateToDetails(_AreaCardData area) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          area: area.area,
          feeder: area.feeder,
          stage: area.stage,
          gradient: area.gradient,
          powerOffTimes: area.powerOffTimes,
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
          MaterialPageRoute(builder: (context) => FaultReportPage()),
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
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HomeHeader(
                    isSidebarOpen: _isSidebarOpen,
                    onMenuTap: _toggleSidebar,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: PageView(
                      controller: _homePageController,
                      onPageChanged: (int page) {
                        setState(() => _currentTabIndex = page);
                      },
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _SectionTitle('My Area(s)'),
                            const SizedBox(height: AppSpacing.md),
                            Expanded(
                              child: PageView.builder(
                                controller: _tabPageController,
                                itemCount: _areas.length,
                                onPageChanged: (int page) {
                                  setState(() => _currentTabIndex = page);
                                },
                                itemBuilder: (context, index) {
                                  final area = _areas[index];
                                  return GestureDetector(
                                    onTap: () => _navigateToDetails(area),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: MyArea(
                                        area: area.area,
                                        feeder: area.feeder,
                                        stage: area.stage,
                                        gradient: area.gradient,
                                        powerOffTimes: area.powerOffTimes,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Align(
                              alignment: Alignment.center,
                              child: SmoothPageIndicator(
                                controller: _tabPageController,
                                count: _areas.length,
                                effect: const ExpandingDotsEffect(
                                  dotHeight: 7,
                                  dotWidth: 7,
                                  activeDotColor: RiveAppTheme.textPrimary,
                                  dotColor: Color(0xFFB8BEC8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _NearbyAreasSection(currentTabIndex: _currentTabIndex),
                ],
              ),
            ),
          ),
          if (_isSidebarOpen)
            _SidebarSheet(
              onHomeTap: () {
                setState(() {
                  _isSidebarOpen = false;
                  _homePageController.jumpToPage(0);
                });
              },
              onSettingsTap: () {
                setState(() => _isSidebarOpen = false);
              },
            ),
        ],
      ),
      bottomNavigationBar: CustomTabBar(onTabChange: _onTabChange),
    );
  }
}

class _AreaCardData {
  const _AreaCardData({
    required this.area,
    required this.feeder,
    required this.stage,
    required this.powerOffTimes,
    required this.gradient,
  });

  final String area;
  final String feeder;
  final int stage;
  final List<int> powerOffTimes;
  final LinearGradient gradient;
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.isSidebarOpen,
    required this.onMenuTap,
  });

  final bool isSidebarOpen;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
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
                  color: RiveAppTheme.textPrimary,
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                'Out',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.8,
                  color: RiveAppTheme.textSecondary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _IconContainer(
                icon: isSidebarOpen ? Icons.close : Icons.menu,
                onTap: onMenuTap,
              ),
              const SizedBox(width: AppSpacing.sm),
              const GoogleUserIcon(),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class _NearbyAreasSection extends StatelessWidget {
  const _NearbyAreasSection({required this.currentTabIndex});

  final int currentTabIndex;

  String _getNearbyAreaName(int index) {
    switch (index % 3) {
      case 0:
        return 'Woodlands';
      case 1:
        return 'Parklands';
      default:
        return 'ZITF';
    }
  }

  String _getNearbyFeederName(int index) {
    switch (index % 3) {
      case 0:
        return 'City of Bulawayo Main Feeder';
      case 1:
        return 'Khumalo Main Feeder';
      default:
        return '33Kv feeder';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Nearby Areas'),
        const SizedBox(height: AppSpacing.md),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.98, end: 1).animate(animation),
                child: child,
              ),
            );
          },
          child: Column(
            key: ValueKey<int>(currentTabIndex),
            children: [
              Padding(
                key: ValueKey<int>(currentTabIndex),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: _NearbyAreaTile(
                  iconPath: 'lib/icons/byo.png',
                  areaName: _getNearbyAreaName(currentTabIndex),
                  feederName: _getNearbyFeederName(currentTabIndex),
                ),
              ),
              if (currentTabIndex + 1 < 3)
                Padding(
                  key: ValueKey<int>(currentTabIndex + 1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: _NearbyAreaTile(
                    iconPath: 'lib/icons/byo.png',
                    areaName: _getNearbyAreaName(currentTabIndex + 1),
                    feederName: _getNearbyFeederName(currentTabIndex + 1),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NearbyAreaTile extends StatelessWidget {
  const _NearbyAreaTile({
    required this.iconPath,
    required this.areaName,
    required this.feederName,
  });

  final String iconPath;
  final String areaName;
  final String feederName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: RiveAppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(color: RiveAppTheme.borderSubtle),
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
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              child: Image.asset(iconPath),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(areaName, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        size: 16,
                        color: RiveAppTheme.textSecondary,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          feederName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                color: RiveAppTheme.surfaceMuted,
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: RiveAppTheme.textSecondary,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarSheet extends StatelessWidget {
  const _SidebarSheet({required this.onHomeTap, required this.onSettingsTap});

  final VoidCallback onHomeTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.82,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        border: Border.all(color: RiveAppTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Menu',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.8,
                color: RiveAppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ListTile(
            leading: const Icon(Icons.home_rounded),
            title: const Text('Home'),
            onTap: onHomeTap,
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text('Settings'),
            onTap: onSettingsTap,
          ),
        ],
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
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: Ink(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.md),
          color: Colors.white.withOpacity(0.95),
          border: Border.all(color: RiveAppTheme.borderSubtle),
        ),
        child: Icon(icon, size: 20, color: RiveAppTheme.textPrimary),
      ),
    );
  }
}

class GoogleUserIcon extends StatelessWidget {
  const GoogleUserIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFEEF4FF), Color(0xFFDCEBFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: RiveAppTheme.borderSubtle),
      ),
      child: const Center(
        child: Text(
          'LO',
          style: TextStyle(
            color: Color(0xFF2C2C2E),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}
