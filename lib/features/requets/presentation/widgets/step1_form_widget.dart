import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/create_request_provider.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';

class Step1FormWidget extends StatefulWidget {
  final CreateRequestProvider provider;
  final GlobalKey<FormState> formKey;
  final TextEditingController vehicleYearController;
  final TextEditingController subCategoryController;
  final String selectedVehicleType;
  final String? selectedVehicleModel;
  final String? selectedProvince;
  final File? vehicleImage;
  final String? vehicleTypeError;
  final String? vehicleModelError;
  final String? provinceError;
  final List<String> vehicleTypes;
  final List<String> vehicleModels;
  final List<String> provinces;
  final Function(String) onVehicleTypeSelected;
  final Function(String) onVehicleModelSelected;
  final Function(String) onProvinceSelected;
  final VoidCallback onImagePickerTap;
  final VoidCallback onRemoveImage;
  final Function(CreateRequestProvider) onNext;

  const Step1FormWidget({
    super.key,
    required this.provider,
    required this.formKey,
    required this.vehicleYearController,
    required this.subCategoryController,
    required this.selectedVehicleType,
    this.selectedVehicleModel,
    this.selectedProvince,
    this.vehicleImage,
    this.vehicleTypeError,
    this.vehicleModelError,
    this.provinceError,
    required this.vehicleTypes,
    required this.vehicleModels,
    required this.provinces,
    required this.onVehicleTypeSelected,
    required this.onVehicleModelSelected,
    required this.onProvinceSelected,
    required this.onImagePickerTap,
    required this.onRemoveImage,
    required this.onNext,
  });

  @override
  State<Step1FormWidget> createState() => _Step1FormWidgetState();
}

class _Step1FormWidgetState extends State<Step1FormWidget> {
  IconData _getVehicleIcon(String type) {
    switch (type.toLowerCase()) {
      case 'car':
        return Icons.directions_car;
      case 'truck':
        return Icons.local_shipping;
      case 'motorcycle':
        return Icons.two_wheeler;
      case 'bus':
        return Icons.directions_bus;
      case 'van':
        return Icons.airport_shuttle;
      default:
        return Icons.directions_car;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        8,
        20,
        MediaQuery.of(context).padding.bottom + 70,
      ),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryUltraLight,
                    AppColors.backgroundSecondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.directions_car,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.vehicleInformation,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.tellUsAboutYourVehicle,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Vehicle Type
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.vehicleTypeError != null
                      ? AppColors.error
                      : AppColors.border,
                  width: widget.vehicleTypeError != null ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.category, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        '${l10n.vehicleTypeLabel} *',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: widget.vehicleTypes.map((type) {
                      final isSelected = widget.selectedVehicleType == type;
                      return GestureDetector(
                        onTap: () => widget.onVehicleTypeSelected(type),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [
                                      AppColors.primary,
                                      AppColors.primaryLight,
                                    ],
                                  )
                                : null,
                            color: isSelected
                                ? null
                                : AppColors.backgroundSecondary,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: isSelected ? 0 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getVehicleIcon(type),
                                size: 18,
                                color: isSelected
                                    ? AppColors.textWhite
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                type.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? AppColors.textWhite
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            if (widget.vehicleTypeError != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.vehicleTypeError!,
                style: TextStyle(fontSize: 12, color: AppColors.error),
              ),
            ],
            const SizedBox(height: 24),

            // Vehicle Model Dropdown
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.vehicleModelError != null
                      ? AppColors.error
                      : AppColors.border,
                  width: widget.vehicleModelError != null ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.directions_car, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        '${l10n.vehicleModelLabel} *',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: widget.vehicleModels.isEmpty
                        ? null
                        : () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Container(
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                                      width: 40,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: AppColors.border,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.directions_car,
                                            color: AppColors.primary,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            l10n.vehicleModelLabel,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 1),
                                    Flexible(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: widget.vehicleModels.length,
                                        itemBuilder: (context, index) {
                                          final model = widget.vehicleModels[index];
                                          final isSelected =
                                              widget.selectedVehicleModel == model;
                                          return ListTile(
                                            title: Text(
                                              model,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                                color: isSelected
                                                    ? AppColors.primary
                                                    : AppColors.textPrimary,
                                              ),
                                            ),
                                            trailing: isSelected
                                                ? Icon(
                                                    Icons.check_circle,
                                                    color: AppColors.primary,
                                                    size: 24,
                                                  )
                                                : null,
                                            onTap: () {
                                              widget.onVehicleModelSelected(model);
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).padding.bottom,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.vehicleModelError != null
                              ? AppColors.error
                              : AppColors.border,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.selectedVehicleModel ?? l10n.vehicleModelHint,
                              style: TextStyle(
                                fontSize: 16,
                                color: widget.selectedVehicleModel == null
                                    ? AppColors.textLight
                                    : AppColors.textPrimary,
                                fontWeight: widget.selectedVehicleModel == null
                                    ? FontWeight.normal
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.textSecondary,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.vehicleModelError != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.vehicleModelError!,
                style: TextStyle(fontSize: 12, color: AppColors.error),
              ),
            ],
            const SizedBox(height: 16),

            // Sub-Category Text Field (only show if model is selected)
            if (widget.selectedVehicleModel != null)
              AppTextField(
                controller: widget.subCategoryController,
                label: 'Sub Category',
                hint: 'e.g., Corolla, Civic, etc.',
                type: AppTextFieldType.text,
              ),
            if (widget.selectedVehicleModel != null)
              const SizedBox(height: 16),

            // Vehicle Year
            AppTextField(
              controller: widget.vehicleYearController,
              label: '${l10n.vehicleYearLabel} *',
              hint: l10n.vehicleYearHint,
              type: AppTextFieldType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.pleaseEnterVehicleYear;
                }
                final year = int.tryParse(value.trim());
                if (year == null ||
                    year < 1900 ||
                    year > DateTime.now().year + 1) {
                  return l10n.pleaseEnterValidVehicleYear;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Country
            // GestureDetector(
            //   onTap: widget.onCountryTap,
            //   child: Container(
            //     padding: const EdgeInsets.all(20),
            //     decoration: BoxDecoration(
            //       color: AppColors.background,
            //       borderRadius: BorderRadius.circular(16),
            //       border: Border.all(
            //         color: widget.countryError != null
            //             ? AppColors.error
            //             : AppColors.border,
            //         width: widget.countryError != null ? 2 : 1,
            //       ),
            //       boxShadow: [
            //         BoxShadow(
            //           color: AppColors.shadowLight,
            //           blurRadius: 4,
            //           offset: const Offset(0, 1),
            //         ),
            //       ],
            //     ),
            //     child: Row(
            //       children: [
            //         Container(
            //           padding: const EdgeInsets.all(10),
            //           decoration: BoxDecoration(
            //             color: AppColors.primaryUltraLight,
            //             borderRadius: BorderRadius.circular(10),
            //           ),
            //           child: Icon(
            //             Icons.public,
            //             color: AppColors.primary,
            //             size: 20,
            //           ),
            //         ),
            //         const SizedBox(width: 16),
            //         Expanded(
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 'Country *',
            //                 style: TextStyle(
            //                   fontSize: 12,
            //                   color: AppColors.textSecondary,
            //                   fontWeight: FontWeight.w500,
            //                 ),
            //               ),
            //               const SizedBox(height: 4),
            //               Text(
            //                 widget.selectedCountry.isEmpty
            //                     ? 'Select Country'
            //                     : widget.countries[widget.selectedCountry] ?? 'Select Country',
            //                 style: TextStyle(
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w600,
            //                   color: widget.selectedCountry.isEmpty
            //                       ? AppColors.textLight
            //                       : AppColors.textPrimary,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //         Icon(
            //           Icons.arrow_forward_ios,
            //           size: 16,
            //           color: AppColors.textSecondary,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // if (widget.countryError != null) ...[
            //   const SizedBox(height: 8),
            //   Text(
            //     widget.countryError!,
            //     style: TextStyle(fontSize: 12, color: AppColors.error),
            //   ),
            // ],
            // const SizedBox(height: 16),

            // Province/State Dropdown
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.provinceError != null
                      ? AppColors.error
                      : AppColors.border,
                  width: widget.provinceError != null ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        '${l10n.provinceStateLabel} *',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 12, bottom: 8),
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.border,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.provinceStateLabel,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              Flexible(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.provinces.length,
                                  itemBuilder: (context, index) {
                                    final province = widget.provinces[index];
                                    final isSelected =
                                        widget.selectedProvince == province;
                                    return ListTile(
                                      title: Text(
                                        province,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                      trailing: isSelected
                                          ? Icon(
                                              Icons.check_circle,
                                              color: AppColors.primary,
                                              size: 24,
                                            )
                                          : null,
                                      onTap: () {
                                        widget.onProvinceSelected(province);
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).padding.bottom,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.provinceError != null
                              ? AppColors.error
                              : AppColors.border,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.selectedProvince ?? l10n.provinceStateHint,
                              style: TextStyle(
                                fontSize: 16,
                                color: widget.selectedProvince == null
                                    ? AppColors.textLight
                                    : AppColors.textPrimary,
                                fontWeight: widget.selectedProvince == null
                                    ? FontWeight.normal
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.textSecondary,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.provinceError != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.provinceError!,
                style: TextStyle(fontSize: 12, color: AppColors.error),
              ),
            ],
            const SizedBox(height: 24),

            // Vehicle Image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: widget.onImagePickerTap,
                child: Container(
                  height: 180,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.backgroundSecondary,
                        AppColors.primaryUltraLight,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: widget.vehicleImage != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                widget.vehicleImage!,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: GestureDetector(
                                onTap: widget.onRemoveImage,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.error.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: AppColors.textWhite,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.tapToAddVehicleImage,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.optional,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Navigation Buttons
            Container(
              margin: const EdgeInsets.only(top: 24, bottom: 24),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.provider.isLoading
                        ? null
                        : () => widget.onNext(widget.provider),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.provider.isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.textWhite,
                                ),
                              ),
                            )
                          else ...[
                            Text(
                              l10n.continueButton,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textWhite,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: AppColors.textWhite,
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
