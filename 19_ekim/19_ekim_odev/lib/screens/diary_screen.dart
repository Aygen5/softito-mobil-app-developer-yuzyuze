import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../theme/app_colors.dart';
import '../widgets/diary_editor.dart';

/// Seçilen güne ait günlüğün okunduğu, yazıldığı ve kaydedildiği ekran.
class DiaryScreen extends StatefulWidget {
  final DateTime date;  // Günlüğün yazılacağı günün tarihi
  final DiaryEntry? initialEntry;  // Eğer o güne daha önce yazılmış bir günlük varsa buraya gelir

  const DiaryScreen({
    super.key,
    required this.date,
    this.initialEntry,
  });

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  late final TextEditingController _textController;  // Yazı alanını kontrol eder
  late String _selectedMood; // Seçilen ruh halini tutar ('Huzurlu', 'Yorgun' vb.)
  bool _isSaving = false;  // Kaydet butonuna basıldığında yüklenme animasyonu göstermek için
  bool _hasSaved = false; // Günlüğün başarıyla kaydedilip kaydedilmediğini anlamak için

  //_textController: Kullanıcının ekrana yazdığı metni hafızada tutan ve yöneten nesnedir.

  static const List<String> _months = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık'
  ];

  static const List<String> _weekdays = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar'
  ];

  @override
  void initState() {
    super.initState();
    _textController =
        TextEditingController(text: widget.initialEntry?.content ?? '');
    _selectedMood = widget.initialEntry?.mood ?? 'Huzurlu';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String _formatTurkishDate(DateTime date) {
    final day = date.day;
    final month = _months[date.month - 1];
    final weekday = _weekdays[date.weekday - 1];
    return '$day $month $weekday';
  }

  Future<void> _handleSave() async {   //Kaydetme Fonksiyonu
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen günlüğünüz için bir şeyler yazın.'),
          backgroundColor: AppColors.tertiary,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Kaydetme görsel geri bildirimi (kısa gecikme)
    await Future.delayed(const Duration(milliseconds: 350));

    if (!mounted) return;

    final entry = DiaryEntry(  //yeni bir günlük nesnesi oluşturuyoruz
      date: DateTime(widget.date.year, widget.date.month, widget.date.day),
      content: text,
      mood: _selectedMood,
      updatedAt: DateTime.now(),
    );

    setState(() {
      _isSaving = false;
      _hasSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Günlüğünüz başarıyla mühürlendi ve kaydedildi.'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );

    // Kaydedilen günlüğü önceki sayfaya döndür
    Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatTurkishDate(widget.date);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Yazı Düzenleyici',
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_hasSaved || widget.initialEntry != null)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle,
                      size: 14, color: AppColors.onSecondaryContainer),
                  SizedBox(width: 4),
                  Text(
                    'Kaydedildi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Tarih ve İlham Başlığı
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'GÜNLÜK NOTLARIM',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                formattedDate,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Bugün senin için nasıldı?',
                style: TextStyle(
                  color: AppColors.tertiary,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 20),

              // Günlük Düzenleyici ve Mood Seçici
              DiaryEditor(
                controller: _textController,
                selectedMood: _selectedMood,
                onMoodChanged: (mood) {
                  setState(() {
                    _selectedMood = mood;
                  });
                },
                onSave: _handleSave,
                isSaving: _isSaving,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
