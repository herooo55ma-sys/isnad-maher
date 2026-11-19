import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models.dart';
import '../services/database_helper.dart';

class AddRecordPage extends StatefulWidget {
  const AddRecordPage({super.key});
  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  final _formKey = GlobalKey<FormState>();
  final _costName = TextEditingController();
  final _letterNumber = TextEditingController();
  final _issuer = TextEditingController();
  final _assignee = TextEditingController();
  final _phone = TextEditingController();
  final _status = TextEditingController(text: 'جديد');
  DateTime _date = DateTime.now();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await DatabaseHelper.instance.insertRecord(IsnadRecord(
      costName: _costName.text.trim(),
      letterNumber: _letterNumber.text.trim(),
      issuer: _issuer.text.trim(),
      assignee: _assignee.text.trim(),
      phone: _phone.text.trim(),
      status: _status.text.trim(),
      statusDate: DateFormat('yyyy-MM-dd').format(_date),
    ));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ تم حفظ التكليف'), backgroundColor: Colors.green));
    _costName.clear();
    _letterNumber.clear();
    _issuer.clear();
    _assignee.clear();
    _phone.clear();
    _status.text = 'جديد';
    setState(() => _date = DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('➕ إضافة تكليف جديد',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _field(_costName, 'اسم التكلفة/المكاتبة', required: true),
          _field(_letterNumber, 'رقم المكاتبة', required: true),
          _field(_issuer, 'جهة الصدور'),
          _field(_assignee, 'اسم المكلف'),
          _field(_phone, 'رقم الهاتف', keyboard: TextInputType.phone),
          _field(_status, 'الموقف'),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.teal),
              title: Text('التاريخ: ${DateFormat('yyyy-MM-dd').format(_date)}'),
              trailing: const Icon(Icons.edit),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _date = picked);
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('حفظ التكليف', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String label,
      {bool required = false, TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: keyboard,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: required ? (v) => (v == null || v.trim().isEmpty) ? 'حقل مطلوب' : null : null,
      ),
    );
  }
}
