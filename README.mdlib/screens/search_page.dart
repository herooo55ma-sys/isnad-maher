import 'package:flutter/material.dart';
import '../models.dart';
import '../services/database_helper.dart';
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State createState() => _SearchPageState();
}
class _SearchPageState extends State {
  final _kw = TextEditingController();
  final _status = TextEditingController();
  List _results = [];
  bool _loading = false;
  Future _doSearch() async {
    setState(() => _loading = true);
    final r = await DatabaseHelper.instance.search(
      keyword: _kw.text.trim(),
      status: _status.text.trim(),
    );
    setState(() {
      _results = r;
      _loading = false;
    });
  }
  Future editStatus(IsnadRecord r) async {
    final statusCtrl = TextEditingController(text: r.status);
    final dateCtrl = TextEditingController(text: r.statusDate);
    final ok = await showDialog(
      context: context,
      builder: () => AlertDialog(
        title: Text('تحديث موقف ${r.letterNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: statusCtrl, decoration: const InputDecoration(labelText: 'الموقف')),
            TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: 'التاريخ (YYYY-MM-DD)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('تحديث')),
        ],
      ),
    );
    if (ok == true) {
      await DatabaseHelper.instance.updateStatus(r.letterNumber, statusCtrl.text, dateCtrl.text);
      await _doSearch();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                controller: _kw,
                decoration: const InputDecoration(
                  labelText: '🔎 بحث: رقم / اسم / مكلف / جهة / هاتف',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _status,
                decoration: const InputDecoration(
                  labelText: 'فلترة بالموقف (اختياري)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _doSearch,
                  icon: const Icon(Icons.search),
                  label: const Text('بحث'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text('النتائج: ${_results.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _results.isEmpty
                  ? const Center(child: Text('لا نتائج — اكتب كلمة واضغط بحث'))
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (, i) {
                        final r = _results[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: ListTile(
                            title: Text('${r.costName} — رقم ${r.letterNumber}'),
                            subtitle: Text(
                              '${r.assignee} | ${r.phone}\n'
                              'الموقف: ${r.status} | ${r.statusDate}',
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.teal),
                              onPressed: () => _editStatus(r),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
