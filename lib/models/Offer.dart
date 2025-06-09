class Offer {
  final String store;
  final String price;
  final String url;

  Offer({
    required this.store,
    required this.price,
    required this.url,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      store: json['store']?.toString() ?? 'Sklep',
      price: json['price']?.toString() ?? '0.00 zł',
      url: json['url']?.toString() ?? '#',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store': store,
      'price': price,
      'url': url,
    };
  }
}