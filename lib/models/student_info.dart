class StudentInfo {
  final int id;
  final String registrationNumber;
  final String civilRegistryNumber;

  final String firstName;
  final String lastName;

  final String fatherName;
  final String fatherJob;

  final String motherName;

  final String grandFatherName;

  final String dateOfBirth;
  final String birthPlace;

  final String civilRegistryPlace;

  final String nationality;

  final String schoolEnrollmentDate;

  StudentInfo({
    required this.id,
    required this.registrationNumber,
    required this.civilRegistryNumber,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.fatherJob,
    required this.motherName,
    required this.grandFatherName,
    required this.dateOfBirth,
    required this.birthPlace,
    required this.civilRegistryPlace,
    required this.nationality,
    required this.schoolEnrollmentDate,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      id: json['id'] ?? 0,
      registrationNumber: json['registrationNumber'] ?? '',
      civilRegistryNumber: json['civilRegistryNumber'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fatherName: json['fatherName'] ?? '',
      fatherJob: json['fatherJob'] ?? '',
      motherName: json['motherName'] ?? '',
      grandFatherName: json['grandFatherName'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      birthPlace: json['birthPlace'] ?? '',
      civilRegistryPlace: json['civilRegistryPlace'] ?? '',
      nationality: json['nationality'] ?? '',
      schoolEnrollmentDate: json['schoolEnrollmentDate'] ?? '',
    );
  }
}
