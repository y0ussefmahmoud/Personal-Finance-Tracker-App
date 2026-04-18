import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import '../database/database_helper.dart';
import '../models/tip.dart';
import '../repositories/tip_repository.dart';

class TipsProvider extends ChangeNotifier {
  List<Tip> tips = [];
  bool isLoading = false;
  final TipRepository _tipRepository;

  TipsProvider() : _tipRepository = TipRepository(DatabaseHelper());

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
    tips = await _tipRepository.getAllTips();
    isLoading = false;
    notifyListeners();
  }

  Future<void> getTips() async {
    tips = await _tipRepository.getAllTips();
    notifyListeners();
  }

  Future<void> addTip(Tip tip) async {
    await _tipRepository.addTipLegacy(tip);
    await fetchTips();
  }

  Future<void> updateTip(Tip tip) async {
    await _tipRepository.updateTipLegacy(tip);
    await fetchTips();
  }

  Future<void> deleteTip(int id) async {
    await _tipRepository.deleteTip(id);
    await fetchTips();
  }

  Future<void> markAsRead(int id) async {
    final tip = tips.firstWhere((t) => t.id == id);
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

    final tipRepository = TipRepository(db);
    for (final tip in defaultTips) {
      await tipRepository.addTipLegacy(tip);
    }

    await db.setSetting('tips_seeded', 'true');
  }
}
