import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class MultiSelectField extends StatefulWidget {
  final String title;
  final List<String> items;
  final List<String> selectedItems;
  final Function(List<String>) onSelectionChanged;

  const MultiSelectField({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
  });

  @override
  State<MultiSelectField> createState() => _MultiSelectFieldState();
}

class _MultiSelectFieldState extends State<MultiSelectField> {
  late List<String> tempSelection;

  @override
  void initState() {
    super.initState();
    tempSelection = List.from(widget.selectedItems);
  }

  void _showSelectionSheet() {
    tempSelection = List.from(widget.selectedItems);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setBottomState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 350,
                      child: ListView.builder(
                        itemCount: widget.items.length,
                        itemBuilder: (_, index) {
                          final item = widget.items[index];

                          return CheckboxListTile(
                            value: tempSelection.contains(item),
                            title: Text(item),
                            activeColor: AppColors.primary,
                            onChanged: (value) {
  setBottomState(() {
    if (value == true) {
      if (item == "ALL") {
        // Selecting ALL clears every other selection
        tempSelection.clear();
        tempSelection.add("ALL");
      } else {
        // Selecting any individual item removes ALL
        tempSelection.remove("ALL");

        if (!tempSelection.contains(item)) {
          tempSelection.add(item);
        }
      }
    } else {
      tempSelection.remove(item);
    }
  });
},
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {
                          widget.onSelectionChanged(tempSelection);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Done",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: _showSelectionSheet,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          widget.selectedItems.isEmpty
              ? "Select ${widget.title}"
              : widget.selectedItems.join(", "),
          style: TextStyle(
            color: widget.selectedItems.isEmpty
                ? AppColors.textLight
                : AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}