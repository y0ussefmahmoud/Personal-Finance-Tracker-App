import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/tip.dart';

class TipsProvider extends ChangeNotifier {
  List<Tip> tips = [];
  bool isLoading = false;

  List<Tip> get unreadTips {
    return tips.where((t) => !t.isRead).toList();
  }

  List<Tip> get savingTips {
    return tips.where((t) => t.category == 'saving').toList();
  }

  List<Tip> get investmentTips {
    return tips.where((t) => t.category == 'investment').toList();
  }

  List<Tip> get budgetingTips {
    return tips.where((t) => t.category == 'budgeting').toList();
  }

  Future<void> fetchTips() async {
    isLoading = true;
    notifyListeners();
    final db = DatabaseHelper();
    tips = await db.getTips();
    isLoading = false;
    notifyListeners();
  }

  Future<void> getTips() async {
    final tipsList = await DatabaseHelper().getTips();
    tips = tipsList;
    notifyListeners();
  }

  Future<void> addTip(Tip tip) async {
    final db = DatabaseHelper();
    await db.insertTip(tip);
    await fetchTips();
  }

  Future<void> updateTip(Tip tip) async {
    final db = DatabaseHelper();
    await db.updateTip(tip);
    await fetchTips();
  }

  Future<void> deleteTip(int id) async {
    final db = DatabaseHelper();
    await db.deleteTip(id);
    await fetchTips();
  }

  Future<void> markAsRead(int id) async {
    final tip = tips.firstWhere((t) => t.id == id);
    if (tip != null) {
      final updated = Tip(
        id: tip.id,
        title: tip.title,
        content: tip.content,
        category: tip.category,
        isRead: true,
        date: tip.date,
      );
      await updateTip(updated);
    }
  }

  static Future<void> seedDefaultTips() async {
    final db = DatabaseHelper();
    final seeded = await db.getSetting('tips_seeded');
    if (seeded == 'true') return;

    final defaultTips = [
      Tip(
        title: 'قاعدة 50/30/20',
        content: 'خصص 50% للاحتياجات، 30% للرغبات، 20% للادخار',
        category: 'budgeting',
        isRead: false,
        date: DateTime.now(),
      ),
      Tip(
        title: 'الذهب كملاذ آمن',
        content: 'الذهب يحافظ على قيمته في أوقات التضخم',
        category: 'investment',
        isRead: false,
        date: DateTime.now(),
      ),
      Tip(
        title: 'صندوق الطوارئ',
        content: 'احتفظ بمدخرات تكفي 3-6 أشهر من نفقاتك',
        category: 'saving',
        isRead: false,
        date: DateTime.now(),
      ),
      Tip(
        title: 'تجنب الديون الاستهلاكية',
        content: 'لا تقترض لشراء أشياء تفقد قيمتها',
        category: 'budgeting',
        isRead: false,
        date: DateTime.now(),
      ),
      Tip(
        title: 'استثمر مبكراً',
        content: 'كلما بدأت الاستثمار مبكراً، كلما استفدت من الفائدة المركبة',
        category: 'investment',
        isRead: false,
        date: DateTime.now(),
      ),
      Tip(
        title: 'تتبع مصروفاتك',
        content: 'سجّل كل مصروف مهما كان صغيراً',
        category: 'saving',
        isRead: false,
        date: DateTime.now(),
      ),
    ];

    for (final tip in defaultTips) {
      await db.insertTip(tip);
    }

    await db.setSetting('tips_seeded', 'true');
  }
}
