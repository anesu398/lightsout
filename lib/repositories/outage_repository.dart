import 'package:lightsout/models/outage_models.dart';

abstract class OutageDataSource {
  Future<List<OutageArea>> fetchAreas();
}

class OutageRepository {
  const OutageRepository({required OutageDataSource dataSource})
    : _dataSource = dataSource;

  final OutageDataSource _dataSource;

  Future<List<OutageArea>> getAreas() {
    return _dataSource.fetchAreas();
  }
}
