import 'package:flutter/material.dart';
import 'package:makan_bang/widgets/left_drawer.dart';
import 'package:makan_bang/widgets/mood_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ItemHomepage> items = [
    ItemHomepage("Catalogue", Icons.menu_book, Colors.blue[900]!),
    ItemHomepage("Rate and Review ", Icons.rate_review_outlined, Colors.red),
    ItemHomepage("Forum", Icons.emoji_people_sharp, Colors.pink[300]!),
    ItemHomepage("Preference", Icons.fastfood_outlined, Colors.green[400]!),
    ItemHomepage("Meal Plan", Icons.list_alt, Colors.yellow[800]!),
    ItemHomepage("Bookmark", Icons.bookmark_add, Colors.blue[900]!),
  ];

  bool isAuthenticated = false;
  String? username;

  @override
  void initState() {
    super.initState();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get("http://127.0.0.1:8000/auth/status/");
      setState(() {
        isAuthenticated = response['is_authenticated'];
        username = response['username'];
      });
    } catch (e) {
      setState(() {
        isAuthenticated = false;
        username = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MAKAN BANG',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/heropic.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Card(
                  elevation: 2,
                  color: const Color.fromARGB(255, 251, 250, 246),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      isAuthenticated && username != null
                          ? 'Hello $username, looking for something?'
                          : 'Hello there, looking for something?',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: items.map((ItemHomepage item) {
                  return ItemCard(item);
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            // Why MAKAN BANG? Section with modified ExpansionTiles
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Why MAKAN BANG?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  CustomExpansionTile(
                    title: 'Explore Jakarta\'s Food Scene',
                    content: "Makan Bang connects you to Jakarta's bustling food scene, offering a vast selection of popular and hidden culinary gems. Filter through options to discover new flavors, from local favorites to must-try eateries. With GoFood integration, you can even order your picks directly for delivery.",
                  ),
                  CustomExpansionTile(
                    title: 'Personalized Recommendations',
                    content: "With Makan Bang's preference feature, get personalized meal recommendations that match your taste. Choose your food preferences, and the app will tailor suggestions to ensure you're exploring dishes that suit your palate.",
                  ),
                  CustomExpansionTile(
                    title: 'Comprehensive Food Information',
                    content: "Makan Bang provides nutritional insights into each menu item, so you know exactly what you're eating. Plan meals with an eye on health, making informed choices that align with your dietary needs and lifestyle goals.",
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  'In Collaboration With',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Image Carousel
            const SizedBox(
              height: 100, // Adjust height as needed
              child: ImageCarousel(),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  'A project by group PBP B07',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController(
    viewportFraction: 0.8,
  );
  int _currentPage = 0;

  final List<String> _imageAssets = [
    'assets/images/enjoyjkt.png',
    'assets/images/gofood.png',
    'assets/images/traveloka.png',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final nextPage = (_currentPage + 1) % _imageAssets.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          itemCount: _imageAssets.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(
                _imageAssets[index],
                fit: BoxFit.contain,
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _imageAssets.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == entry.key
                      ? Colors.black
                      : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final String content;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: _isExpanded ? const Color.fromARGB(255, 251, 250, 246) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}