import 'package:flutter/material.dart';

import '../components/app_bar.dart';
import '../components/AppButton.dart';
import '../../../../core/theme/app_color.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  String? selectedActivity;
  final TextEditingController _descController = TextEditingController();
  bool hasImage = false; // Toggle for demo
  String? selectedTime;

  bool get isFormValid => selectedActivity != null && selectedTime != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildSimpleAppBar(context, "Add Activity"),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Selector
                  Row(
                    children: [
                      if (hasImage)
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  "https://placedog.net/100/100",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white.withOpacity(
                                    0.8,
                                  ),
                                  radius: 12,
                                  child: const Icon(
                                    Icons.edit,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      GestureDetector(
                        onTap: () => setState(() => hasImage = true),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade50,
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Color(0xFF0070D2),
                              ),
                              Text(
                                "Add Media",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Activity Type",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration("Select activity type"),
                    items: ["Vet Visit", "Walking", "Feeding"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() {
                      selectedActivity = val;
                    }),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Description (Optional)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descController,
                    maxLines: 4,
                    onChanged: (v) => setState(() {}),
                    decoration: _inputDecoration(
                      "Add notes about this activity...",
                    ),
                  ),
                  const Text(
                    "0/300 Characters",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Time",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    readOnly: true,
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedTime = picked.format(context);
                        });
                      }
                    },
                    decoration: _inputDecoration(
                      selectedTime ?? "Select time",
                    ).copyWith(suffixIcon: const Icon(Icons.access_time)),
                  ),
                ],
              ),
            ),
          ),

          // Save Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: AppButton(
              text: "Save Activity",
              textColor: isFormValid ? Colors.white : Colors.grey,
              color: isFormValid ? AppColors.primary : Colors.grey.shade300,
              onPressed: () => {
                if (isFormValid)
                  {
                    // Save activity logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Activity saved successfully!")),
                    ),
                    Navigator.pop(context),
                  },
              },
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    );
  }
}
