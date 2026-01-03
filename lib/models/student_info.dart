class StudentInfo {
  final int id;
  final String idNumber;
  final String? oldRegistrationNumber;
  final String? firstName;
  final String? lastName;
  final String? fatherName;
  final String? fatherJob;
  final String? grandfatherName;
  final String? motherName;
  final String? birthPlace;
  final String? birthDate;
  final String? registrationPlaceNumber;
  final String? nationality;
  final String? schoolJoinDate;
  final String? previousHighSchool;
  final String? admissionDocNumber;
  final String? admissionDocDate;
  final String? joinedGrade;
  final String? failedGradesBeforeJoining;
  final String? leavingDate;
  final String? leavingReason;
  final String? nextHighSchool;
  final String? leavingDocType;
  final String? leavingDocNumber;
  final String? leavingDocDate;
  final String? profileImageUrl;

  StudentInfo({
    required this.id,
    required this.idNumber,
    this.oldRegistrationNumber,
    this.firstName,
    this.lastName,
    this.fatherName,
    this.fatherJob,
    this.grandfatherName,
    this.motherName,
    this.birthPlace,
    this.birthDate,
    this.registrationPlaceNumber,
    this.nationality,
    this.schoolJoinDate,
    this.previousHighSchool,
    this.admissionDocNumber,
    this.admissionDocDate,
    this.joinedGrade,
    this.failedGradesBeforeJoining,
    this.leavingDate,
    this.leavingReason,
    this.nextHighSchool,
    this.leavingDocType,
    this.leavingDocNumber,
    this.leavingDocDate,
    this.profileImageUrl,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      id: json['id'] ?? 0,
      idNumber: json['id_number'] ?? '',
      oldRegistrationNumber: json['old_registration_number'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fatherName: json['father_name'],
      fatherJob: json['father_job'],
      grandfatherName: json['grandfather_name'],
      motherName: json['mother_name'],
      birthPlace: json['birth_place'],
      birthDate: json['birth_date'],
      registrationPlaceNumber: json['registration_place_number'],
      nationality: json['nationality'],
      schoolJoinDate: json['school_join_date'],
      previousHighSchool: json['previous_high_school'],
      admissionDocNumber: json['admission_doc_number'],
      admissionDocDate: json['admission_doc_date'],
      joinedGrade: json['joined_grade'],
      failedGradesBeforeJoining: json['failed_grades_before_joining'],
      leavingDate: json['leaving_date'],
      leavingReason: json['leaving_reason'],
      nextHighSchool: json['next_high_school'],
      leavingDocType: json['leaving_doc_type'],
      leavingDocNumber: json['leaving_doc_number'],
      leavingDocDate: json['leaving_doc_date'],
      profileImageUrl: json['profile_image_url'],
    );
  }
}
