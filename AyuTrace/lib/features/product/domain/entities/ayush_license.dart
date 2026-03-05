import 'package:equatable/equatable.dart';

class AyushLicense extends Equatable {
  final String licenseNumber;
  final String companyName;
  final String externalUrl;
  final bool isVerified;

  const AyushLicense({
    required this.licenseNumber,
    required this.companyName,
    required this.externalUrl,
    required this.isVerified,
  });

  @override
  List<Object?> get props => [
    licenseNumber,
    companyName,
    externalUrl,
    isVerified,
  ];
}
