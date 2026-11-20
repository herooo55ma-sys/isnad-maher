import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'add_record_page.dart';
import 'search_page.dart';
import 'reports_page.dart';
import '../services/auth_service.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State createState() => _HomeScreenState();
}
class _HomeScreenState extends State {
  int _index = 0;
  Future changePassword() async {
    final oldPwd = TextEditingController();
    final newPwd = TextEditingController();
    await showDialog(
      context: context,
      builder: () => AlertDialog(
        title: const Text('تغيير كلمة المرور'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: oldPwd, obscureText: true, decoration: const InputDecoration(labelText: 'كلمة المرور الحالية')),
            TextField(controller: newPwd, obscureText: true, decoration: const InputDecoration(labelText: 'كلمة المرور الجديدة')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              if (!await AuthService.verify(oldPwd.text)) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('كلمة المرور الحالية خاطئة'), backgroundColor: Colors.red));
                return;
              }
              if (newPwd.text.length < 4) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('كلمة المرور الجديدة قصيرة'), backgroundColor: Colors.red));
                return;
              }
              await AuthService.changePassword(newPwd.text);
              if (!mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تغيير كلمة المرور'), backgroundColor: Colors.green));
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إسناد ماهر'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.key), tooltip: 'تغيير كلمة المرور', onPressed: changePassword),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'خروج',
            onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: () => const LoginScreen())),
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: const [AddRecordPage(), SearchPage(), ReportsPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.add_circle), label: 'إضافة'),
          NavigationDestination(icon: Icon(Icons.search), label: 'بحث'),
          NavigationDestination(icon: Icon(Icons.picture_as_pdf), label: 'تقارير'),
        ],
      ),
    );
  }
}
