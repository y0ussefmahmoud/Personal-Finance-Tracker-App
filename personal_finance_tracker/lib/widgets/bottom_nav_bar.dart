import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'التقارير'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'الميزانية'),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'الأقساط'),
        BottomNavigationBarItem(icon: Icon(Icons.tips_and_updates), label: 'النصائح'),
      ],
      onTap: (index) {
        if (index == currentIndex) return;
        if (index == 0) {
          // Navigate to home/dashboard
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        } else if (index == 1) {
          // Navigate to analytics
          Navigator.pushNamedAndRemoveUntil(context, '/analytics', (route) => false);
        } else if (index == 2) {
          // Navigate to budgets
          Navigator.pushNamedAndRemoveUntil(context, '/budgets', (route) => false);
        } else if (index == 3) {
          Navigator.pushNamedAndRemoveUntil(context, '/installments', (route) => false);
        } else if (index == 4) {
          Navigator.pushNamedAndRemoveUntil(context, '/tips', (route) => false);
        }
      },
    );
  }
}
