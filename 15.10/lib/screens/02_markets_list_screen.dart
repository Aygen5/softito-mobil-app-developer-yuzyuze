import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../models/transition_model.dart';

typedef MarketsGridListScreen = MarketsListScreen;

class MarketsListScreen extends StatefulWidget {
  const MarketsListScreen({super.key});

  @override
  State<MarketsListScreen> createState() => _MarketsListScreenState();
}

class _MarketsListScreenState extends State<MarketsListScreen> {
  String _selectedCategory = 'Tümü';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _categories = [
    'Tümü',
    'Kripto',
    'Hisse',
    'Emtia',
    'Döviz',
  ];

  static const List<Asset> _allAssets = [
    Asset(
      symbol: 'BTC',
      name: 'Bitcoin',
      price: 67420.00,
      change24h: 4.20,
      balance: 0.45,
    ),
    Asset(
      symbol: 'ETH',
      name: 'Ethereum',
      price: 3520.50,
      change24h: -1.80,
      balance: 3.20,
    ),
    Asset(
      symbol: 'SOL',
      name: 'Solana',
      price: 182.40,
      change24h: 8.65,
      balance: 45.00,
    ),
    Asset(
      symbol: 'AVAX',
      name: 'Avalanche',
      price: 28.90,
      change24h: 2.15,
      balance: 120.00,
    ),
    Asset(
      symbol: 'BNB',
      name: 'BNB Chain',
      price: 595.00,
      change24h: -0.45,
      balance: 5.50,
    ),
    Asset(
      symbol: 'XRP',
      name: 'Ripple',
      price: 0.58,
      change24h: 1.20,
      balance: 1250.00,
    ),
    Asset(
      symbol: 'ADA',
      name: 'Cardano',
      price: 0.46,
      change24h: -2.10,
      balance: 850.00,
    ),
    Asset(
      symbol: 'DOT',
      name: 'Polkadot',
      price: 7.25,
      change24h: 3.40,
      balance: 150.00,
    ),
  ];

  static const List<TransactionItem> _transactions = [
    TransactionItem(
      id: 'tx_1',
      title: 'Apple Store',
      category: 'Teknoloji',
      date: 'Bugün 14:20',
      amount: 64500.00,
      isExpense: true,
      icon: Icons.laptop_mac,
    ),
    TransactionItem(
      id: 'tx_2',
      title: 'Kodusta Danışmanlık Hakediş',
      category: 'Kurumsal Gelir',
      date: 'Dün 09:00',
      amount: 125000.00,
      isExpense: false,
      icon: Icons.account_balance,
    ),
    TransactionItem(
      id: 'tx_3',
      title: 'Binance TR Kripto Alım',
      category: 'Kripto Yatırım',
      date: '13 Ekim 18:30',
      amount: 15000.00,
      isExpense: true,
      icon: Icons.currency_bitcoin,
    ),
    TransactionItem(
      id: 'tx_4',
      title: 'Borsa İstanbul Temettü',
      category: 'Yatırım Getirisi',
      date: '12 Ekim 11:15',
      amount: 8750.50,
      isExpense: false,
      icon: Icons.trending_up,
    ),
    TransactionItem(
      id: 'tx_5',
      title: 'Starbucks Coffee',
      category: 'Yeme & İçme',
      date: '11 Ekim 16:45',
      amount: 185.00,
      isExpense: true,
      icon: Icons.coffee,
    ),
    TransactionItem(
      id: 'tx_6',
      title: 'AWS Cloud Hizmetleri',
      category: 'Yazılım Altyapı',
      date: '10 Ekim 10:00',
      amount: 3450.00,
      isExpense: true,
      icon: Icons.cloud_queue,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Asset> get _filteredAssets {
    return _allAssets.where((asset) {
      final matchesSearch = asset.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          asset.symbol.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  void _showAssetDetailModal(Asset asset) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFFEEF2FF),
                    child: Text(
                      asset.symbol.substring(0, 1),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        asset.symbol,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: asset.isPositive
                          ? const Color(0xFFECFDF5)
                          : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${asset.isPositive ? '+' : ''}${asset.change24h}%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: asset.isPositive
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Birim Fiyat',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF64748B))),
                        const SizedBox(height: 4),
                        Text(
                          '\$${asset.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    Container(
                        width: 1, height: 36, color: const Color(0xFFE2E8F0)),
                    Column(
                      children: [
                        const Text('Bakiyeniz',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF64748B))),
                        const SizedBox(height: 4),
                        Text(
                          '${asset.balance} ${asset.symbol}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    Container(
                        width: 1, height: 36, color: const Color(0xFFE2E8F0)),
                    Column(
                      children: [
                        const Text('Toplam Değer',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF64748B))),
                        const SizedBox(height: 4),
                        Text(
                          '\$${asset.totalValue.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFEF4444)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${asset.symbol} Satış emri verildi.'),
                            backgroundColor: const Color(0xFFEF4444),
                          ),
                        );
                      },
                      child: const Text('Sat',
                          style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${asset.symbol} Alış emri verildi.'),
                            backgroundColor: const Color(0xFF10B981),
                          ),
                        );
                      },
                      child: const Text('Satın Al',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredAssets;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Arama Çubuğu
          _buildSearchBar(),
          const SizedBox(height: 16),

          // Kategori Filtre Butonları
          _buildCategoryFilters(),
          const SizedBox(height: 20),

          // Bölüm 1: GridView.builder Başlığı
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Piyasa Varlıkları (GridView.builder)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${filtered.length} Varlık',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6366F1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // GridView.builder
          if (filtered.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              child: const Text('Aradığınız kriterde varlık bulunamadı.'),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.35,
              ),
              itemBuilder: (context, index) {
                final asset = filtered[index];
                return _buildAssetCard(asset);
              },
            ),

          const SizedBox(height: 28),

          // Bölüm 2: ListView.separated Başlığı
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Piyasa & Hesap Hareketleri (ListView.separated)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                '${_transactions.length} İşlem',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ListView.separated
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x05000000),
                  offset: Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                indent: 68,
                endIndent: 16,
                color: Color(0xFFF1F5F9),
              ),
              itemBuilder: (context, index) {
                final tx = _transactions[index];
                return _buildTransactionTile(tx);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Varlık ara (BTC, Ethereum, SOL...)',
          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              selectedColor: const Color(0xFF6366F1),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF1E293B),
              ),
              side: BorderSide(
                color: isSelected
                    ? const Color(0xFF6366F1)
                    : const Color(0xFFE2E8F0),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onSelected: (val) {
                setState(() {
                  _selectedCategory = cat;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAssetCard(Asset asset) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => _showAssetDetailModal(asset),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x04000000),
                offset: Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: const Color(0xFFEEF2FF),
                        child: Text(
                          asset.symbol.substring(0, 1),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        asset.symbol,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: asset.isPositive
                          ? const Color(0xFFECFDF5)
                          : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          asset.isPositive
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          size: 14,
                          color: asset.isPositive
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                        Text(
                          '${asset.change24h.abs()}%',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: asset.isPositive
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.name,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${asset.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Text(
                'Bakiye: ${asset.balance}',
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionTile(TransactionItem tx) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: tx.isExpense
              ? const Color(0x14EF4444)
              : const Color(0x1410B981),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          tx.icon,
          color:
              tx.isExpense ? const Color(0xFFEF4444) : const Color(0xFF10B981),
          size: 20,
        ),
      ),
      title: Text(
        tx.title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Color(0xFF0F172A),
        ),
      ),
      subtitle: Text(
        '${tx.category} • ${tx.date}',
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF64748B),
        ),
      ),
      trailing: Text(
        '${tx.isExpense ? '-' : '+'}₺${tx.amount.toStringAsFixed(2)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color:
              tx.isExpense ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        ),
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${tx.title} işlemi detayları açıldı.'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
