# Reaktif State Akışı (ValueNotifier & ListenableBuilder)

Bu belge `flutter-feature-scaffold` yeteneğindeki reaktif state akış prensiplerini belgeler.

```mermaid
flowchart TD
    User([Kullanıcı Etkileşimi / UI]) -->|Tıklandı / Form Gönderildi| Controller[Controller: Metot Çağrısı]
    Controller -->|State Güncellemesi| Notifier[ValueNotifier / ChangeNotifier]
    Notifier -->|Bildirim / notifyListeners| Builder[ListenableBuilder / ValueListenableBuilder]
    Builder -->|Yalnızca Etkilenen Parça Yeniden Çizilir| ReRender[Hedef Widget Render]
```

## Temel Avantajlar
1. **İzole Yeniden Çizim:** Tüm sayfa (`setState`) yeniden çizilmez, sadece `ListenableBuilder` altındaki ağaç render edilir.
2. **Performans:** Değişmeyen dış bileşenler `const` olarak kalır.
3. **Temiz Ayrım:** Arayüz katmanı sadece gösterim yapar; iş mantığı controller içinde yaşar.
