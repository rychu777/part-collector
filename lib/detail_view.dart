import 'package:flutter/material.dart';

// Przykładowe kolory (możesz je dostosować do własnych potrzeb):
const Color kPrimaryDark = Color(0xFF1D1B20);
const Color kSurfaceLight = Color(0xFFE8DEF8);
const Color kSurfaceLighter = Color(0xFFFEF7FF);
const Color kWhite = Color(0xFFFFFFFF);
const Color kDarkGrey = Color(0xFF1D1B20);
const Color kPurple = Color(0xFF4F378A);
const Color kPurple2 = Color(0xFF65558F);
const Color kRedError = Color(0xFF9C3732);
const Color kLightPurple = Color(0xFFD1C4E9);
const Color kMainBackground = Color(0xFF333333);

class DetailView extends StatefulWidget {
  final Map<String, dynamic> productData;

  const DetailView({Key? key, required this.productData}) : super(key: key);

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Pobieramy dane z przekazanego JSON-a:
    final images = widget.productData['images'] as List<dynamic>? ?? [];
    final name = widget.productData['name'] as String? ?? 'Brak nazwy';
    final price = widget.productData['price'] as String? ?? 'Brak ceny';
    final specs = widget.productData['specs'] as Map<String, dynamic>? ?? {};
    final description = widget.productData['description'] as String? ?? 'Brak opisu';
    final offers = widget.productData['offers'] as List<dynamic>? ?? [];

    return Scaffold(
      body: Container(
        color: kMainBackground,
        child: SafeArea(
          child: Column(
            children: [
              // Sekcja karuzeli + przycisk powrotu
              _buildImageCarousel(images),
              // Reszta treści (scrollowalna)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Nazwa i cena
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                color: kWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Od $price',
                              style: const TextStyle(
                                color: kLightPurple,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: kWhite, thickness: 1),
                      // Lista parametrów
                      _buildSpecsList(specs),
                      const Divider(color: kWhite, thickness: 1),
                      // Opis
                      _buildDescription(description),
                      const Divider(color: kWhite, thickness: 1),
                      // Oferty
                      _buildOffersSection(offers),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              // Stopka
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // Karuzela zdjęć
  Widget _buildImageCarousel(List<dynamic> images) {
    if (images.isEmpty) {
      return Stack(
        children: [
          Container(
            color: kDarkGrey,
            height: 200,
            child: const Center(
              child: Text(
                'Brak zdjęć',
                style: TextStyle(color: kWhite),
              ),
            ),
          ),
          _buildBackButton(),
        ],
      );
    }

    return Stack(
      children: [
        // Możemy użyć PageView jako prostej karuzeli
        SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final imageUrl = images[index] as String;
              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        // Strzałka wstecz
        _buildBackButton(),
        Positioned(
          bottom: 8,
          right: 0,
          left: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentImageIndex == index ? kPurple : kWhite,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // Przycisk powrotu w lewym górnym rogu (transparentny)
  Widget _buildBackButton() {
    return Positioned(
      top: 8,
      left: 8,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(4),
          child: const Icon(
            Icons.arrow_back,
            color: kWhite,
          ),
        ),
      ),
    );
  }

  // Lista parametrów
  Widget _buildSpecsList(Map<String, dynamic> specs) {
    // specs to np. {"Pojemność": "32 GB", "Taktowanie": "6000 MHz", ...}
    if (specs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Brak specyfikacji',
          style: TextStyle(color: kWhite),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: specs.entries.map((entry) {
          final paramName = entry.key;
          final paramValue = entry.value.toString();
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    paramName,
                    style: const TextStyle(
                      color: kWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 5,
                  child: Text(
                    paramValue,
                    style: const TextStyle(color: kLightPurple),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Opis produktu
  Widget _buildDescription(String description) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        description,
        style: const TextStyle(color: kWhite),
      ),
    );
  }

  // Sekcja ofert
  Widget _buildOffersSection(List<dynamic> offers) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Text(
            'Oferty',
            style: TextStyle(
              color: kWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: offers.map((offer) {
              final storeName = offer['store'] ?? 'Sklep';
              final storePrice = offer['price'] ?? '0.00 zł';
              final storeUrl = offer['url'] ?? '#';

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kSurfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        storeName,
                        style: const TextStyle(
                          color: kDarkGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        storePrice,
                        style: const TextStyle(
                          color: kDarkGrey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Przekierowanie do URL w przeglądarce
                        // (Docelowo można użyć url_launcher package)
                        debugPrint('Przekierowanie do: $storeUrl');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kRedError,
                      ),
                      child: const Text(
                        'Sprawdź',
                        style: TextStyle(color: kWhite),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Sto00opka
  Widget _buildBottomButtons() {
    return Container(
      color: kPrimaryDark,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkGrey,
              side: const BorderSide(color: kRedError, width: 3),
              textStyle: const TextStyle(color: kRedError),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Powrót',
              style: TextStyle(color: kRedError),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kRedError,
              textStyle: const TextStyle(color: kWhite),
            ),
            onPressed: () {
              debugPrint('Dodano do koszyka');
            },
            child: const Text(
              'Dodaj',
              style: TextStyle(color: kWhite),
            ),
          ),
        ],
      ),
    );
  }
}
