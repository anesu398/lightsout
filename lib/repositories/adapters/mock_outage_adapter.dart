import 'package:lightsout/models/outage_models.dart';
import 'package:lightsout/repositories/outage_repository.dart';

class MockOutageAdapter implements OutageDataSource {
  @override
  Future<List<OutageArea>> fetchAreas() async {
    final now = DateTime.now();

    return [
      OutageArea(
        id: 'khumalo-ilanda',
        name: 'Khumalo',
        feeder: 'Ilanda Feeder',
        stage: 2,
        powerOffTimes: const [1, 2, 3, 4, 5],
        themeKey: 'oceanBlue',
        status: AreaStatus(
          currentState: AreaPowerState.on,
          nextChangeHour: 1,
          lastUpdated: now,
          source: 'Mock Utility Feed',
          sourceHealth: SourceHealth.healthy,
        ),
      ),
      OutageArea(
        id: 'polytechnic-park-road',
        name: 'Bulawayo PolyTechnic',
        feeder: 'Park Road Feeder',
        stage: 1,
        powerOffTimes: const [3, 4, 5, 6],
        themeKey: 'mintBlue',
        status: AreaStatus(
          currentState: AreaPowerState.on,
          nextChangeHour: 3,
          lastUpdated: now,
          source: 'Mock Utility Feed',
          sourceHealth: SourceHealth.healthy,
        ),
      ),
      OutageArea(
        id: 'ascot-khumalo-feeder',
        name: 'Ascot',
        feeder: 'Khumalo Feeder',
        stage: 3,
        powerOffTimes: const [8, 9, 10, 11, 14, 15],
        themeKey: 'roseIndigo',
        status: AreaStatus(
          currentState: AreaPowerState.off,
          nextChangeHour: 8,
          lastUpdated: now,
          source: 'Mock Utility Feed',
          sourceHealth: SourceHealth.stale,
        ),
      ),
    ];
  }
}
