import 'package:flutter/material.dart';
import 'package:makan_bang/preference/models/preference_models.dart';
import 'package:makan_bang/catalog/models/product_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:makan_bang/catalog/screens/productdetail.dart';

class PreferencePage extends StatefulWidget {
  const PreferencePage({super.key});

  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  List<Product> _matchingProducts = [];
  Set<String> _selectedPreferences = {};
  final TextEditingController _preferenceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPreferences().then((_) {
      if (_selectedPreferences.isNotEmpty) {
        _fetchMatchingProducts();
      }
    });
  }

  @override
  void dispose() {
    _preferenceController.dispose();
    super.dispose();
  }

  Future<void> _fetchPreferences() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
        'http://127.0.0.1:8000/preferences/get-user-preferences-json/',
      );

      if (response != null && 
          response['status'] == 'success' && 
          response['preferences'] != null) {
        setState(() {
          _selectedPreferences = Set<String>.from(
            (response['preferences'] as List).map((item) {
              return item['preference']?.toString() ?? '';
            }).where((pref) => pref.isNotEmpty),
          );
        });
        await _fetchMatchingProducts();
      } else {
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching preferences: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _fetchMatchingProducts() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
        'http://127.0.0.1:8000/preferences/get-matching-products/',
      );

      if (response != null && response is List) {
        setState(() {
          _matchingProducts = response.map((item) {
            try {
              return Product(
                model: "katalog.product",
                pk: "0",
                fields: Fields(
                  item: item['name']?.toString() ?? '',
                  pictureLink: item['picture_link']?.toString() ?? '',
                  restaurant: item['restaurant']?.toString() ?? '',
                  kategori: item['kategori']?.toString() ?? '',
                  lokasi: item['lokasi']?.toString() ?? '',
                  price: int.tryParse(
                    (item['price']?.toString() ?? '0')
                        .replaceAll(RegExp(r'[^0-9]'), '')
                  ) ?? 0,
                  nutrition: item['nutrition']?.toString() ?? '',
                  description: item['description']?.toString() ?? '',
                  linkGofood: item['link_gofood']?.toString() ?? '',
                  isDatasetProduct: true,
                ),
              );
            } catch (e) {
              return null;
            }
          }).whereType<Product>().toList(); // Filter out null values
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching products: $e')),
        );
      }
    }
  }

  Future<void> _addPreference(String preference) async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.post(
        'http://127.0.0.1:8000/preferences/create-ajax/',
        {'preference_name': preference},
      );
      
      
      if (response['status'] == 'success') {
        await _fetchPreferences(); // Refresh preferences after adding
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Preference added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Failed to add preference'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding preference: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deletePreference(String preference) async {
    final request = context.read<CookieRequest>();
    try {
      // Get the HTML first to find the preference ID
      final getResponse = await request.get(
        'http://127.0.0.1:8000/preferences/get-user-preferences-json/',
      );
      
      
      if (getResponse['status'] == 'success' && 
          getResponse['preferences'] != null) {
        // Cari preference ID dari response JSON
        final preferenceList = getResponse['preferences'] as List;
        final prefItem = preferenceList.firstWhere(
          (item) => item['preference'] == preference,
          orElse: () => null,
        );
        
        if (prefItem == null) {
          throw Exception('Preference not found');
        }
        
        int preferenceId = prefItem['id'];
        
        // Gunakan URL yang sesuai dengan Django URL pattern dan POST method
        final response = await request.post(
          'http://127.0.0.1:8000/preferences/delete-ajax/$preferenceId/',
          {},
        );

        if (response['status'] == 'success') {
          setState(() {
            _selectedPreferences.remove(preference);
          });
          await _fetchMatchingProducts(); // Refresh products after deletion
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Preference deleted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          throw Exception(response['message'] ?? 'Failed to delete preference');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting preference: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildPreferenceChip(String label) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: () => _deletePreference(label),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }

  void _showAddPreferenceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Preference'),
          content: TextField(
            controller: _preferenceController,
            decoration: const InputDecoration(
              hintText: 'Enter your preference',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            textCapitalization: TextCapitalization.words,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _preferenceController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (_preferenceController.text.isNotEmpty) {
                  _addPreference(_preferenceController.text);
                  _preferenceController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPreferenceDialog,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Preferences',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (_selectedPreferences.isEmpty)
                  const Center(
                    child: Text(
                      'No preferences added yet. Click + to add your preferences!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedPreferences
                        .map((pref) => _buildPreferenceChip(pref))
                        .toList(),
                  ),
                const SizedBox(height: 32),
                if (_selectedPreferences.isNotEmpty) ...[
                  const Text(
                    'Matching Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_matchingProducts.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _matchingProducts.length,
                      itemBuilder: (context, index) {
                        final product = _matchingProducts[index];
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailPage(product: product),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16)
                                  ),
                                  child: product.fields.pictureLink.isNotEmpty
                                      ? Image.network(
                                          product.fields.pictureLink,
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/placeholder.jpg',
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.fields.item,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Rp ${product.fields.price}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.restaurant,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              product.fields.restaurant,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
} 