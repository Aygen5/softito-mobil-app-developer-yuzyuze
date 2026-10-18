import 'package:flutter/material.dart';

typedef LayoutStylingScreen = LayoutScreen;

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  bool _isBalanceVisible = true;
  String _lastAction = 'Hazır - Kartlara ve butonlara tıklayabilirsiniz';
  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> _quickServices = [
    {'title': 'Tümü', 'icon': Icons.apps},
    {'title': 'Faturalar', 'icon': Icons.receipt_long},
    {'title': 'Yatırım', 'icon': Icons.trending_up},
    {'title': 'Döviz', 'icon': Icons.currency_exchange},
    {'title': 'Altın', 'icon': Icons.savings_outlined},
    {'title': 'Kredi', 'icon': Icons.credit_score},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          _buildPremiumWalletCard(),
          _buildQuickActions(),
          _buildSafeNotificationBanner(),
          _buildFlexStatistics(),
          _buildBudgetGoalCard(),
          _buildServiceChips(),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.touch_app,
                        size: 16, color: Color(0xFF6366F1)),
                    const SizedBox(width: 8),
                    Text(
                      'Son İşlem: $_lastAction',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF475569),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x1F6366F1),
                  border: Border.all(color: const Color(0xFF6366F1), width: 2),
                ),
                child: const Icon(Icons.person,
                    color: Color(0xFF6366F1), size: 32),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hoş Geldin, Selahaddin',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'SoftITO Mobile Developer - Grup 3',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            icon: const Icon(Icons.notifications_outlined,
                color: Color(0xFF1E293B)),
            onPressed: () {
              setState(() => _lastAction = 'Bildirimler kontrol edildi');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Yeni bir sistem bildirimi bulunmuyor.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumWalletCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFF9333EA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x597C3AED),
            offset: Offset(0, 12),
            blurRadius: 24,
            spreadRadius: -4,
          ),
        ],
        border: Border.all(color: const Color(0x33FFFFFF), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.credit_card, color: Colors.white70, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Kodvance Platinum',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                    _lastAction =
                        _isBalanceVisible ? 'Bakiye açıldı' : 'Bakiye gizlendi';
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Kullanılabilir Toplam Bakiye',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            _isBalanceVisible ? '₺148.950,50' : '••••••••••',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '•••• •••• •••• 4289',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  letterSpacing: 2,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                '10/28',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(Icons.send_rounded, 'Para Gönder', () {
            setState(() => _lastAction = 'Para Gönder tıklandı');
          }),
          _buildActionButton(Icons.account_balance_wallet, 'Para Yükle', () {
            setState(() => _lastAction = 'Para Yükle tıklandı');
          }),
          _buildActionButton(Icons.qr_code_scanner, 'QR İşlem', () {
            setState(() => _lastAction = 'QR İşlem tıklandı');
          }),
          _buildActionButton(Icons.more_horiz, 'Diğer', () {
            setState(() => _lastAction = 'Diğer Menü tıklandı');
          }),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 76,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFF6366F1), size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafeNotificationBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFCD34D)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFFD97706), size: 24),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Bugün 14-15 Ekim dersleri birleştirilmiştir. Canlı Flutter UI geliştirmeleri yapılmaktadır.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF92400E),
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              setState(() => _lastAction = 'Bildirim onaylandı');
            },
            child: const Text(
              'Tamam',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlexStatistics() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x05000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Aylık Harcama',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  SizedBox(height: 4),
                  Text('₺24.450',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A))),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x05000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Puan',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  SizedBox(height: 4),
                  Text('4.850',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6366F1))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetGoalCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.flag_outlined, color: Color(0xFF6366F1), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Aylık Tasarruf Hedefi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '%68 Tamamlandı',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: 0.68,
              minHeight: 8,
              backgroundColor: Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Biriken: ₺34.000',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              Text('Hedef: ₺50.000',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hızlı Servisler & Kısayollar',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_quickServices.length, (index) {
                final service = _quickServices[index];
                final isSelected = _selectedCategoryIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    avatar: Icon(
                      service['icon'] as IconData,
                      size: 16,
                      color:
                          isSelected ? Colors.white : const Color(0xFF64748B),
                    ),
                    label: Text(service['title'] as String),
                    selected: isSelected,
                    selectedColor: const Color(0xFF6366F1),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected ? Colors.white : const Color(0xFF1E293B),
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF6366F1)
                          : const Color(0xFFE2E8F0),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (val) {
                      setState(() {
                        _selectedCategoryIndex = index;
                        _lastAction = '${service['title']} kategorisi seçildi';
                      });
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
