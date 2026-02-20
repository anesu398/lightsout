enum AreaPowerState { on, off, unknown }

enum SourceHealth { healthy, stale, unavailable }

class AreaStatus {
  const AreaStatus({
    required this.currentState,
    required this.nextChangeHour,
    required this.lastUpdated,
    required this.source,
    required this.sourceHealth,
  });

  final AreaPowerState currentState;
  final int? nextChangeHour;
  final DateTime lastUpdated;
  final String source;
  final SourceHealth sourceHealth;
}

class OutageArea {
  const OutageArea({
    required this.id,
    required this.name,
    required this.feeder,
    required this.stage,
    required this.powerOffTimes,
    required this.themeKey,
    required this.status,
  });

  final String id;
  final String name;
  final String feeder;
  final int stage;
  final List<int> powerOffTimes;
  final String themeKey;
  final AreaStatus status;
}
