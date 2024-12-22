import 'package:flutter/material.dart';
import 'package:makan_bang/catalog/models/product_entry.dart';
import 'package:makan_bang/meal_planning/models/meal_plan_model.dart';
import 'package:makan_bang/meal_planning/screens/create_mealplan.dart';
import 'package:makan_bang/meal_planning/screens/first_page_meal_plan.dart';
import 'package:makan_bang/meal_planning/widgets/meal_plan_service.dart';
import 'package:makan_bang/catalog/models/product_entry.dart' as catalog;
import 'package:intl/intl.dart';

class MealPlanDetailScreen extends StatefulWidget {
  final MealPlan mealPlan;
  final Function refreshMealPlans;

  const MealPlanDetailScreen({
    super.key,
    required this.mealPlan,
    required this.refreshMealPlans,
  });

  @override
  State<MealPlanDetailScreen> createState() => _MealPlanDetailScreenState();
}

class _MealPlanDetailScreenState extends State<MealPlanDetailScreen> {
  final mealPlanService = MealPlanService(baseUrl: 'http://127.0.0.1:8000/meal-planning/');
  List<Product> foodItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  Future<void> _loadFoodItems() async {
    try {
      final service = MealPlanService(baseUrl: 'http://127.0.0.1:8000/meal-planning/');
      final items = await service.getFoodItems(widget.mealPlan.fields.foodItems);
      
      if (mounted) {
        setState(() {
          foodItems = items;
          isLoading = false;
        });
      }
    } catch (e) {
      // print("Error loading food items: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ... (delete and edit functions remain the same)

  Future<void> _deleteMealPlan() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text(
        'Are you sure to delete this meal plan?',
        style: TextStyle(color: Colors.red), // Warna teks merah
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'No',
            style: TextStyle(color: Colors.black), // Warna hitam untuk "No"
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Yes',
            style: TextStyle(color: Colors.black), // Warna hitam untuk "Yes"
          ),
        ),
      ],
    ),
  );

    if (confirm == true) {
      try {
        await MealPlanService(baseUrl: 'http://127.0.0.1:8000/meal-planning/')
            .deleteMealPlan(widget.mealPlan.pk);
        if (mounted) {
          widget.refreshMealPlans();
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Meal plan deleted successfully')),
          // );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MealPlanScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting meal plan: $e')),
          );
        }
      }
    }
  }

  void _editMealPlan() {
  // Siapkan data yang dibutuhkan
  String formattedDate = "${widget.mealPlan.fields.date.year}-${widget.mealPlan.fields.date.month.toString().padLeft(2, '0')}-${widget.mealPlan.fields.date.day.toString().padLeft(2, '0')}";
  
  TimeOfDay mealTime = TimeOfDay(
    hour: int.parse(widget.mealPlan.fields.time.split(':')[0]),
    minute: int.parse(widget.mealPlan.fields.time.split(':')[1]),
  );

  // Navigate ke CreateMealPlanScreen dengan data yang sudah disiapkan
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CreateMealPlanScreen(
        mealPlan: widget.mealPlan,
        initialTitle: widget.mealPlan.fields.title,
        initialDate: formattedDate,
        initialTime: mealTime,
        initialFoodItems: foodItems,  // foodItems yang sudah ada di detail page
      ),
    ),
  ).then((_) => widget.refreshMealPlans());
}

  @override
  @override
Widget build(BuildContext context) {
  final formattedDate = DateFormat('MMMM, dd yyyy').format(widget.mealPlan.fields.date);

  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'MAKAN BANG',
        style: TextStyle(color: Colors.black),
      ),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Action Buttons
            Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(  // Tambahkan InkWell disini
                        onTap: _deleteMealPlan,
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Icon(
                              Icons.delete_outline,
                              size: 24,
                              color: const Color.fromARGB(255, 243, 116, 116),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 243, 116, 116),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 64,
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: InkWell(  // Tambahkan InkWell disini
                        onTap: _editMealPlan,
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Icon(
                              Icons.edit_outlined,
                              size: 24,
                              color: const Color.fromARGB(255, 75, 110, 41),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 75, 110, 41),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Date and Time
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.calendar_today, color: Colors.grey[600], size: 22),
              title: Text(formattedDate),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.access_time, color: Colors.grey[600], size: 22),
              title: Text(widget.mealPlan.fields.time),
            ),
            const SizedBox(height: 24),

            // Your Meals Section
            const Text(
              'Your meal :',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Food Items List
            isLoading 
    ? const Center(child: CircularProgressIndicator()) 
    : foodItems.isEmpty 
        ? const Center(child: Text('No food items available')) 
        : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,  // Ubah jadi 3 kolom
              mainAxisSpacing: 8,  // Kurangi spacing
              crossAxisSpacing: 8,
              childAspectRatio: 0.8,  // Sesuaikan aspect ratio
            ),
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final foodName = foodItems[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Image Container
                    Expanded(
                      flex: 3,  // Mengatur proporsi gambar
                      child: Container(
                        width: 100,  // Set fixed width
                        height: 100,  // Set fixed height
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: Image.network(
                            foodName.fields.pictureLink,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey[100],
                                  child: const Icon(
                                    Icons.fastfood,
                                    size: 35,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                    // Name Container
                    Expanded(
                      flex: 2,  // Mengatur proporsi text
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: double.infinity,
                        child: Text(
                          foodName.fields.item,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,  // Ukuran text lebih kecil
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}
}