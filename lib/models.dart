class IsnadRecord {
  final int? id;
  final String costName;
  final String letterNumber;
  final String issuer;
  final String assignee;
  final String phone;
  final String status;
  final String statusDate;
  IsnadRecord({
    this.id,
    required this.costName,
    required this.letterNumber,
    required this.issuer,
    required this.assignee,
    required this.phone,
    required this.status,
    required this.statusDate,
  });
  Map<String, dynamic> toMap() => {
        'id': id,
        'costName': costName,
        'letterNumber': letterNumber,
        'issuer': issuer,
        'assignee': assignee,
        'phone': phone,
        'status': status,
        'statusDate': statusDate,
      };
  factory IsnadRecord.fromMap(Map<String, dynamic> m) => IsnadRecord(
        id: m['id'],
        costName: m['costName'] ?? '',
        letterNumber: m['letterNumber'] ?? '',
        issuer: m['issuer'] ?? '',
        assignee: m['assignee'] ?? '',
        phone: m['phone'] ?? '',
        status: m['status'] ?? '',
        statusDate: m['statusDate'] ?? '',
      );
}
