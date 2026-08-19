import 'package:flutter/material.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';

import '../../../../core/theme/sizes.dart';
import '../../domain/entities/country.dart';

typedef OnCountrySelected = void Function(String code, String flag);

void showCountryPickerSheet({
  required BuildContext context,
  required OnCountrySelected onSelected,
}) {
  final List<Country> countries = [
    Country(code: '+91', name: 'India', flag: '🇮🇳'),
    Country(code: '+1', name: 'United States', flag: '🇺🇸'),
    Country(code: '+1', name: 'Canada', flag: '🇨🇦'),
    Country(code: '+61', name: 'Australia', flag: '🇦🇺'),
    Country(code: '+44', name: 'United Kingdom', flag: '🇬🇧'),
    Country(code: '+49', name: 'Germany', flag: '🇩🇪'),
    Country(code: '+33', name: 'France', flag: '🇫🇷'),
    Country(code: '+55', name: 'Brazil', flag: '🇧🇷'),
  ];

  showModalBottomSheet(
    context: context,
    backgroundColor: context.appSurface,
    useSafeArea: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.6,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (context) {
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
                  Text(
                    'Select Country',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: context.appText,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: context.appText),
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
                      Divider(height: 1, color: context.appBorder),
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    return ListTile(
                      title: Text(
                        country.name,
                        style: TextStyle(fontSize: 16, color: context.appText),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: context.appMutedText,
                      ),
                      onTap: () {
                        onSelected(country.code, country.flag);
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
