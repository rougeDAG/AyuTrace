import 'package:equatable/equatable.dart';

class TrackingStage extends Equatable {
  final String stageName;
  final String dateRange;
  final String description;
  final String dataSource;

  const TrackingStage({
    required this.stageName,
    required this.dateRange,
    required this.description,
    required this.dataSource,
  });

  @override
  List<Object?> get props => [stageName, dateRange, description, dataSource];
}
