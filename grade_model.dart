class Grade {
  int? id;
  String? subject;
  int? marks;
  int? creditHours;
  String? semester;

  Grade({this.id, this.subject, this.marks, this.creditHours, this.semester});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'marks': marks,
      'creditHours': creditHours,
      'semester': semester,
    };
  }

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      id: map['id'],
      subject: map['subject'],
      marks: map['marks'],
      creditHours: map['creditHours'],
      semester: map['semester'],
    );
  }
}