import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/sizes.dart';
import '../../domain/entities/country.dart';

typedef OnCountrySelected = void Function(String country);

void showCountryPickerSheet({
  required BuildContext context,
  required OnCountrySelected onSelected,
}) {
  final List<Country> countries = [
    Country(code: '+91', name: 'India'),
    Country(code: '+1', name: 'United States'),
    Country(code: '+11', name: 'Canada'),
    Country(code: '+2', name: 'Australia'),
    Country(code: '+3', name: 'United Kingdom Kingdomlia'),
    Country(code: '+4', name: 'Germany'),
    Country(code: '+5', name: 'France'),
    Country(code: '+6', name: 'Brazil'),
  ];

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    useSafeArea: true,
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    isScrollControlled: true,
    builder: (_) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.s16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Country',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.s10),

              /// Country List
              Expanded(
                child: ListView.separated(
                  itemCount: countries.length,
                  separatorBuilder: (_, __) =>
                  const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    return ListTile(
                      title: Text(
                        country.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppColors.textGray,
                      ),
                      onTap: () {
                        onSelected(country.code);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
