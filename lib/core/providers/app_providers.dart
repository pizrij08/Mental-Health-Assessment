import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../../data/mindwell_repository.dart';

final mindWellRepositoryProvider = ChangeNotifierProvider<MindWellRepository>((ref) {
  final repository = MindWellRepository.instance;
  repository.seed();
  return repository;
});

final appConfigProvider = Provider<AppConfig>((ref) => AppConfig.fromEnvironment());
