import 'package:flutter/material.dart';
import 'package:lightsout/models/outage_models.dart';
import 'package:lightsout/navigation/custom_tab_bar.dart';
import 'package:lightsout/pages/details.dart';
import 'package:lightsout/pages/fault_report.dart';
import 'package:lightsout/pages/outage_map_page.dart';
import 'package:lightsout/pages/theme.dart';
import 'package:lightsout/repositories/adapters/mock_outage_adapter.dart';
import 'package:lightsout/repositories/outage_repository.dart';
import 'package:lightsout/services/user_preferences_service.dart';
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
  final _prefs = UserPreferencesService();
  final _outageRepository = OutageRepository(dataSource: MockOutageAdapter());

  int _currentTabIndex = 0;
  bool _isSidebarOpen = false;
  bool _alertsEnabled = true;
  bool _darkAppearance = false;
  Set<String> _favoriteAreas = <String>{};

  List<OutageArea> _areas = const [];
  bool _isLoadingAreas = true;
  String? _areasError;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadAreas();
  }

  Future<void> _loadAreas() async {
    setState(() {
      _isLoadingAreas = true;
      _areasError = null;
    });

    try {
      final areas = await _outageRepository.getAreas();
      if (!mounted) return;

      setState(() {
        _areas = areas;
        _isLoadingAreas = false;
        if (_currentTabIndex >= _areas.length) {
          _currentTabIndex = 0;
        }
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoadingAreas = false;
        _areasError = 'Unable to load schedule data.';
      });
    }
  }

  Future<void> _loadPreferences() async {
    final alerts = await _prefs.getAlertsEnabled();
    final dark = await _prefs.getDarkAppearance();
    final favorites = await _prefs.getFavoriteAreas();
    if (!mounted) return;
    setState(() {
      _alertsEnabled = alerts;
      _darkAppearance = dark;
      _favoriteAreas = favorites;
    });
  }

  @override
  void dispose() {
    _homePageController.dispose();
    _tabPageController.dispose();
    super.dispose();
  }

  void _navigateToDetails(OutageArea area) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          area: area.name,
          feeder: area.feeder,
          stage: area.stage,
          gradient: _gradientFor(area.themeKey),
          powerOffTimes: area.powerOffTimes,
        ),
      ),
    );
  }

  Future<void> _toggleFavorite(String areaName) async {
    final updated = Set<String>.from(_favoriteAreas);
    if (updated.contains(areaName)) {
      updated.remove(areaName);
    } else {
      updated.add(areaName);
    }
    setState(() => _favoriteAreas = updated);
    await _prefs.setFavoriteAreas(updated);
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

  LinearGradient _gradientFor(String themeKey) {
    switch (themeKey) {
      case 'mintBlue':
        return const LinearGradient(
          colors: [Color(0xFF8DE4B4), Color(0xFF1C8ADB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.2, 1.0],
        );
      case 'roseIndigo':
        return const LinearGradient(
          colors: [Color(0xFFFB9A9F), Color(0xFF3556C9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 1.0],
        );
      case 'oceanBlue':
      default:
        return const LinearGradient(
          colors: [Color(0xFF99B8FF), Color(0xFF4477ED)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.3, 1.0],
        );
    }
  }

  Widget _buildAreaContent() {
    if (_isLoadingAreas) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_areasError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_areasError!, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(onPressed: _loadAreas, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (_areas.isEmpty) {
      return const Center(child: Text('No areas available.'));
    }

    return PageView.builder(
      controller: _tabPageController,
      itemCount: _areas.length,
      onPageChanged: (int page) {
        setState(() => _currentTabIndex = page);
      },
      itemBuilder: (context, index) {
        final area = _areas[index];
        final isFavorite = _favoriteAreas.contains(area.name);
        return GestureDetector(
          onTap: () => _navigateToDetails(area),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: MyArea(
              area: area.name,
              feeder: area.feeder,
              stage: area.stage,
              gradient: _gradientFor(area.themeKey),
              powerOffTimes: area.powerOffTimes,
              isFavorite: isFavorite,
              onFavoriteToggle: () => _toggleFavorite(area.name),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = _darkAppearance ? const Color(0xFF111214) : RiveAppTheme.background;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _darkAppearance
                      ? [const Color(0xFF1B1D22), const Color(0xFF111214)]
                      : [const Color(0xFFEAF3FF), RiveAppTheme.background, Colors.white],
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
                    onMenuTap: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _SectionTitle('My Area(s) · ${_favoriteAreas.length} saved'),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: _buildAreaContent(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Align(
                    alignment: Alignment.center,
                    child: SmoothPageIndicator(
                      controller: _tabPageController,
                      count: _areas.isEmpty ? 1 : _areas.length,
                      effect: const ExpandingDotsEffect(
                        dotHeight: 7,
                        dotWidth: 7,
                        activeDotColor: RiveAppTheme.textPrimary,
                        dotColor: Color(0xFFB8BEC8),
                      ),
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
              alertsEnabled: _alertsEnabled,
              darkAppearance: _darkAppearance,
              favoriteCount: _favoriteAreas.length,
              onAlertsChanged: (value) async {
                setState(() => _alertsEnabled = value);
                await _prefs.setAlertsEnabled(value);
              },
              onDarkChanged: (value) async {
                setState(() => _darkAppearance = value);
                await _prefs.setDarkAppearance(value);
              },
              onOpenMap: () {
                setState(() => _isSidebarOpen = false);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OutageMapPage()),
                );
              },
              onHomeTap: () {
                setState(() {
                  _isSidebarOpen = false;
                  _homePageController.jumpToPage(0);
                });
              },
              onCloseTap: () => setState(() => _isSidebarOpen = false),
            ),
        ],
      ),
      bottomNavigationBar: CustomTabBar(onTabChange: _onTabChange),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.isSidebarOpen, required this.onMenuTap});

  final bool isSidebarOpen;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
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
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
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
    return Semantics(
      button: true,
      label: '$areaName on $feederName',
      child: Padding(
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
      ),
    );
  }
}

class _SidebarSheet extends StatelessWidget {
  const _SidebarSheet({
    required this.alertsEnabled,
    required this.darkAppearance,
    required this.favoriteCount,
    required this.onAlertsChanged,
    required this.onDarkChanged,
    required this.onOpenMap,
    required this.onHomeTap,
    required this.onCloseTap,
  });

  final bool alertsEnabled;
  final bool darkAppearance;
  final int favoriteCount;
  final ValueChanged<bool> onAlertsChanged;
  final ValueChanged<bool> onDarkChanged;
  final VoidCallback onOpenMap;
  final VoidCallback onHomeTap;
  final VoidCallback onCloseTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.84,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        border: Border.all(color: RiveAppTheme.borderSubtle),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        children: [
          Row(
            children: [
              const GoogleUserIcon(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('LightsOut User', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text('$favoriteCount saved areas', style: const TextStyle(color: RiveAppTheme.textSecondary)),
                  ],
                ),
              ),
              IconButton(onPressed: onCloseTap, icon: const Icon(Icons.close_rounded)),
            ],
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.home_rounded),
            title: const Text('Home'),
            onTap: onHomeTap,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.map_outlined),
            title: const Text('Outage utility map'),
            subtitle: const Text('View tracked areas on map'),
            onTap: onOpenMap,
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.notifications_active_outlined),
            value: alertsEnabled,
            title: const Text('Outage alerts'),
            subtitle: const Text('Get reminders before outage windows'),
            onChanged: onAlertsChanged,
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.dark_mode_outlined),
            value: darkAppearance,
            title: const Text('Dark appearance'),
            subtitle: const Text('Preview low-light interface mode'),
            onChanged: onDarkChanged,
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
