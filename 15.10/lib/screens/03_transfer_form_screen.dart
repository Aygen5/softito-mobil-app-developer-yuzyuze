import 'package:flutter/material.dart';
import '../models/transition_model.dart';

class TransferFormScreen extends StatefulWidget {
  const TransferFormScreen({super.key});

  @override
  State<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends State<TransferFormScreen> {
  double _balance = 148950.50;

  final List<TransactionItem> _history = [
    const TransactionItem(
      id: 'tx_init_1',
      title: 'Ahmet Yılmaz',
      category: 'Hızlı Transfer',
      date: 'Bugün, 11:30',
      amount: 1500.00,
      isExpense: true,
      icon: Icons.send_rounded,
    ),
    const TransactionItem(
      id: 'tx_init_2',
      title: 'Merve Demir',
      category: 'Hızlı Transfer',
      date: 'Dün, 15:45',
      amount: 2400.00,
      isExpense: true,
      icon: Icons.send_rounded,
    ),
    const TransactionItem(
      id: 'tx_init_3',
      title: 'Hesaba Bakiye Yükleme',
      category: 'Havale / EFT',
      date: '13 Ekim, 09:20',
      amount: 10000.00,
      isExpense: false,
      icon: Icons.add_circle_outline,
    ),
  ];

  static const List<Map<String, String>> _quickContacts = [
    {'name': 'Ahmet Yılmaz', 'initials': 'AY'},
    {'name': 'Merve Demir', 'initials': 'MD'},
    {'name': 'Ali Kaya', 'initials': 'AK'},
    {'name': 'Ayşe Çelik', 'initials': 'AÇ'},
    {'name': 'Burak Şen', 'initials': 'BŞ'},
  ];

  void _openTransferModal({String initialRecipient = ''}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return _TransferBottomSheet(
          currentBalance: _balance,
          initialRecipient: initialRecipient,
          onTransferConfirmed: (amount, recipient, category) {
            setState(() {
              _balance -= amount;
              _history.insert(
                0,
                TransactionItem(
                  id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
                  title: recipient,
                  category: category,
                  date: 'Şimdi',
                  amount: amount,
                  isExpense: true,
                  icon: Icons.send_rounded,
                ),
              );
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '₺${amount.toStringAsFixed(2)} tutarındaki transfer $recipient kişisine başarıyla gönderildi!',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openDepositModal() {
    final formKey = GlobalKey<FormState>();
    final depositController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
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
                const SizedBox(height: 16),
                const Text(
                  'Bakiye Yükle',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Kartınızdan veya hesabınızdan anında bakiye yükleyin.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: depositController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Yüklenecek Tutar (₺)',
                    hintText: 'Ör: 5000',
                    prefixIcon: const Icon(Icons.payments_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Lütfen tutar girin';
                    }
                    final val = double.tryParse(v.trim());
                    if (val == null || val <= 0) {
                      return 'Geçerli bir tutar girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final depositAmount =
                            double.parse(depositController.text.trim());
                        Navigator.pop(ctx);
                        setState(() {
                          _balance += depositAmount;
                          _history.insert(
                            0,
                            TransactionItem(
                              id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
                              title: 'Hesaba Bakiye Yükleme',
                              category: 'Para Yükleme',
                              date: 'Şimdi',
                              amount: depositAmount,
                              isExpense: false,
                              icon: Icons.add_circle_outline,
                            ),
                          );
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF10B981),
                            content: Text(
                              '₺${depositAmount.toStringAsFixed(2)} başarıyla hesabınıza yüklendi!',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Yüklemeyi Onayla',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bakiye Kartı
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x05000000),
                  offset: Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kullanılabilir Bakiye',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₺${_balance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      tooltip: 'Bakiye Yükle',
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFEEF2FF),
                      ),
                      icon: const Icon(Icons.add, color: Color(0xFF6366F1)),
                      onPressed: _openDepositModal,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _openTransferModal(),
                        icon: const Icon(Icons.send_rounded, size: 18),
                        label: const Text('Transfer Yap',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0F172A),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _openDepositModal,
                        icon: const Icon(Icons.account_balance_wallet_outlined,
                            size: 18),
                        label: const Text('Bakiye Ekle'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Hızlı Alıcılar (Kişiler)
          const Text(
            'Hızlı Alıcılar',
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
              children: [
                ..._quickContacts.map((contact) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () =>
                          _openTransferModal(initialRecipient: contact['name']!),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: const Color(0xFFEEF2FF),
                              child: Text(
                                contact['initials']!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6366F1),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              contact['name']!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Eğitim Bilgilendirme Kartı
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFC7D2FE)),
            ),
            child: const Row(
              children: [
                Icon(Icons.security, color: Color(0xFF4F46E5), size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Form girişlerinde GlobalKey<FormState> ve TextEditingController kullanılmıştır. Geçersiz tutar veya bakiye yetersizliğinde kırmızı uyarı verir. Geçmiş listesinde kaydırarak silebilirsiniz.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF3730A3),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Transfer Geçmişi Başlığı
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transfer Geçmişi (Dinamik Liste)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                '${_history.length} Kayıt',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Dinamik ListView & Dismissible
          if (_history.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: const Column(
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 48, color: Color(0xFF94A3B8)),
                  SizedBox(height: 8),
                  Text(
                    'Henüz transfer kaydı bulunmuyor.',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                ],
              ),
            )
          else
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
                itemCount: _history.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  indent: 64,
                  endIndent: 16,
                  color: Color(0xFFF1F5F9),
                ),
                itemBuilder: (context, index) {
                  final item = _history[index];
                  return Dismissible(
                    key: Key(item.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: const Color(0xFFEF4444),
                      child: const Icon(Icons.delete_outline,
                          color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      final removedItem = item;
                      final removedIndex = index;
                      setState(() {
                        _history.removeAt(index);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${removedItem.title} kaydı silindi.'),
                          action: SnackBarAction(
                            label: 'Geri Al',
                            textColor: Colors.amber,
                            onPressed: () {
                              setState(() {
                                _history.insert(removedIndex, removedItem);
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      leading: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: item.isExpense
                              ? const Color(0x1FEF4444)
                              : const Color(0x1F10B981),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item.icon,
                          color: item.isExpense
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF10B981),
                          size: 20,
                        ),
                      ),
                      title: Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        '${item.category} • ${item.date}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      trailing: Text(
                        '${item.isExpense ? '-' : '+'}₺${item.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: item.isExpense
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _TransferBottomSheet extends StatefulWidget {
  final double currentBalance;
  final String initialRecipient;
  final Function(double amount, String recipient, String category)
      onTransferConfirmed;

  const _TransferBottomSheet({
    required this.currentBalance,
    this.initialRecipient = '',
    required this.onTransferConfirmed,
  });

  @override
  State<_TransferBottomSheet> createState() => _TransferBottomSheetState();
}

class _TransferBottomSheetState extends State<_TransferBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _recipientController;
  late final TextEditingController _amountController;
  String _selectedCategory = 'Hızlı Transfer';

  static const List<String> _categories = [
    'Hızlı Transfer',
    'Kira Ödemesi',
    'Borç / Paylaşım',
    'Alışveriş',
    'Diğer',
  ];

  static const List<double> _quickAmounts = [250, 500, 1000, 5000];

  @override
  void initState() {
    super.initState();
    _recipientController =
        TextEditingController(text: widget.initialRecipient);
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text.trim());
      final recipient = _recipientController.text.trim();
      Navigator.pop(context);
      widget.onTransferConfirmed(amount, recipient, _selectedCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
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
            const SizedBox(height: 16),
            const Text(
              'Hızlı Para Transferi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Mevcut Bakiyeniz: ₺${widget.currentBalance.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),

            // Alıcı Alanı
            TextFormField(
              controller: _recipientController,
              decoration: InputDecoration(
                labelText: 'Alıcı Adı veya Cüzdan Adresi',
                hintText: 'Ör: Ahmet Yılmaz',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().length < 3) {
                  return 'En az 3 karakterli geçerli alıcı girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Tutar Alanı
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Gönderilecek Tutar (₺)',
                hintText: '0.00',
                prefixIcon: const Icon(Icons.payments_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Lütfen bir tutar girin';
                }
                final val = double.tryParse(v.trim());
                if (val == null || val <= 0) {
                  return 'Geçerli bir pozitif tutar girin';
                }
                if (val > widget.currentBalance) {
                  return 'Yetersiz bakiye!';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            // Hızlı Tutar Seçim Butonları
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ..._quickAmounts.map((amt) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text('+₺${amt.toInt()}'),
                        labelStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4F46E5),
                        ),
                        backgroundColor: const Color(0xFFEEF2FF),
                        side: const BorderSide(color: Color(0xFFC7D2FE)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () {
                          _amountController.text = amt.toStringAsFixed(0);
                        },
                      ),
                    );
                  }),
                  ActionChip(
                    label: const Text('Tümü'),
                    labelStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    backgroundColor: const Color(0xFFF1F5F9),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onPressed: () {
                      _amountController.text =
                          widget.currentBalance.toStringAsFixed(2);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Kategori Dropdown / Seçimi
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Transfer Kategorisi',
                prefixIcon: const Icon(Icons.category_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              items: _categories.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedCategory = val);
                }
              },
            ),
            const SizedBox(height: 20),

            // Gönder Butonu
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _submit,
                child: const Text(
                  'Transferi Gerçekleştir',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
