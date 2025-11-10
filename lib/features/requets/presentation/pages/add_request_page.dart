import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_part_app/core/di/service_locator.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';
import 'package:vehicle_part_app/shared/widgets/app_text_field.dart';
import 'package:vehicle_part_app/shared/widgets/app_button.dart';
import '../providers/create_request_provider.dart';
import '../../data/models/create_request_data.dart';

class AddRequestPage extends StatefulWidget {
  const AddRequestPage({super.key});

  @override
  State<AddRequestPage> createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage> {
  final _pageController = PageController();
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  int _currentStep = 0;
  final int _totalSteps = 2;

  // Step 1 Controllers
  final _vehicleModelController = TextEditingController();
  final _vehicleYearController = TextEditingController();
  final _provinceController = TextEditingController();

  // Step 2 Controllers
  final _partNameController = TextEditingController();
  final _partNumberController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Form values
  String _selectedVehicleType = 'car';
  String _selectedCountry = '';
  File? _vehicleImage;
  File? _partImage;
  File? _partVideo;

  // Validation error messages
  String? _vehicleTypeError;
  String? _countryError;

  final ImagePicker _imagePicker = ImagePicker();

  final List<String> _vehicleTypes = [
    'car',
    'truck',
    'motorcycle',
    'bus',
    'van',
  ];
  final Map<String, String> _countries = {
    'US': 'United States',
    'CA': 'Canada',
    'GB': 'United Kingdom',
    'AU': 'Australia',
    'NZ': 'New Zealand',
    'LK': 'Sri Lanka',
  };

  @override
  void dispose() {
    _pageController.dispose();
    _vehicleModelController.dispose();
    _vehicleYearController.dispose();
    _provinceController.dispose();
    _partNameController.dispose();
    _partNumberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(
    ImageSource source, {
    required bool isVehicleImage,
  }) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          if (isVehicleImage) {
            _vehicleImage = File(image.path);
          } else {
            _partImage = File(image.path);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorPickingImage(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
      );

      if (video != null) {
        setState(() {
          _partVideo = File(video.path);
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorPickingVideo(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showImagePickerOptions(bool isVehicleImage) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(AppLocalizations.of(context)!.takePhoto),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, isVehicleImage: isVehicleImage);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(AppLocalizations.of(context)!.chooseFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, isVehicleImage: isVehicleImage);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCountrySelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          children: _countries.entries.map((entry) {
            return ListTile(
              title: Text(entry.value),
              trailing: _selectedCountry == entry.key
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _selectedCountry = entry.key;
                  _countryError = null;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  bool _validateStep1() {
    // Clear previous errors
    setState(() {
      _vehicleTypeError = null;
      _countryError = null;
    });

    final l10n = AppLocalizations.of(context)!;
    // Validate vehicle type
    if (_selectedVehicleType.isEmpty) {
      setState(() {
        _vehicleTypeError = l10n.pleaseSelectVehicleType;
      });
    }

    // Validate country
    if (_selectedCountry.isEmpty) {
      setState(() {
        _countryError = l10n.pleaseSelectCountry;
      });
    }

    // Validate form fields
    final isValid = _formKeyStep1.currentState?.validate() ?? false;

    // Return true only if all validations pass
    return isValid && _vehicleTypeError == null && _countryError == null;
  }

  bool _validateStep2() {
    // Validate form fields
    return _formKeyStep2.currentState?.validate() ?? false;
  }

  void _handleNext(CreateRequestProvider provider) {
    if (_currentStep == 0) {
      if (_validateStep1()) {
        setState(() {
          _currentStep = 1;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      if (_validateStep2()) {
        _submitRequest(provider);
      }
    }
  }

  void _handleCancel() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cancelRequest),
        content: Text(l10n.cancelRequestMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.keepEditing),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/orders');
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  Future<void> _submitRequest(CreateRequestProvider provider) async {
    final data = CreateRequestData(
      vehicleType: _selectedVehicleType,
      vehicleModel: _vehicleModelController.text.trim(),
      vehicleYear: int.parse(_vehicleYearController.text.trim()),
      partName: _partNameController.text.trim(),
      partNumber: _partNumberController.text.trim().isEmpty
          ? null
          : _partNumberController.text.trim(),
      description: _descriptionController.text.trim(),
      vehicleImagePath: _vehicleImage?.path,
      partImagePath: _partImage?.path,
      partVideoPath: _partVideo?.path,
    );

    await provider.createRequest(data);

    if (provider.isSuccess) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(l10n.requestSubmitted),
            content: Text(l10n.requestSubmittedMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetForm();
                },
                child: Text(l10n.submitAnother),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/orders');
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
                child: Text(l10n.viewRequests),
              ),
            ],
          ),
        );
      }
    } else if (provider.hasError) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.errorMessage ?? 'Failed to submit request',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _resetForm() {
    setState(() {
      _currentStep = 0;
      _selectedVehicleType = 'car';
      _selectedCountry = '';
      _vehicleImage = null;
      _partImage = null;
      _partVideo = null;
    });
    _vehicleModelController.clear();
    _vehicleYearController.clear();
    _provinceController.clear();
    _partNameController.clear();
    _partNumberController.clear();
    _descriptionController.clear();
    _pageController.jumpToPage(0);
    context.read<CreateRequestProvider>().reset();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServiceLocator.get<CreateRequestProvider>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
            onPressed: () => context.go('/orders'),
          ),
          title: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              return Column(
                children: [
                  Text(
                    l10n.requestSparePartTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    l10n.fillInDetailsBelow,
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              );
            },
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: AppColors.borderLight),
          ),
        ),
        body: Consumer<CreateRequestProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    // Dismiss keyboard when tapping outside (only when not loading)
                    if (!provider.isLoading) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: ListView(
                    children: [
                      // Progress Bar
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: AppColors.backgroundSecondary,
                        child: Column(
                          children: [
                            Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.border,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: (_currentStep + 1) / _totalSteps,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Builder(
                              builder: (context) {
                                final l10n = AppLocalizations.of(context)!;
                                return Text(
                                  l10n.stepXOfY(_currentStep + 1, _totalSteps),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Form Content
                      SizedBox(
                        height:
                            MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            kToolbarHeight -
                            100, // Approximate height for progress bar and buttons
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [_buildStep1(), _buildStep2()],
                        ),
                      ),

                      // Navigation Buttons
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          border: Border(
                            top: BorderSide(
                              color: AppColors.borderLight,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: _currentStep == 0 ? 1 : 2,
                              child: Builder(
                                builder: (context) {
                                  final l10n = AppLocalizations.of(context)!;
                                  return AppButton(
                                    height: 53,
                                    text: _currentStep == 0
                                        ? l10n.next
                                        : l10n.submitRequest,
                                    onPressed: provider.isLoading
                                        ? null
                                        : () => _handleNext(provider),
                                    isLoading: provider.isLoading,
                                    trailingIcon: _currentStep == 0
                                        ? Icons.chevron_right
                                        : null,
                                  );
                                },
                              ),
                            ),
                            if (_currentStep == 0) ...[
                              const SizedBox(width: 12),
                              Expanded(
                                child: Builder(
                                  builder: (context) {
                                    final l10n = AppLocalizations.of(context)!;
                                    return AppButton(
                                      height: 53,
                                      text: l10n.cancel,
                                      onPressed: _handleCancel,
                                      type: AppButtonType.outline,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Loading Overlay
                if (provider.isLoading)
                  AbsorbPointer(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Builder(
                                builder: (context) {
                                  final l10n = AppLocalizations.of(context)!;
                                  return Column(
                                    children: [
                                      Text(
                                        l10n.submittingRequest,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        provider.hasVideo
                                            ? l10n.uploadingVideoFile
                                            : l10n.pleaseWait,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStep1() {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKeyStep1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.vehicleInformation,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.tellUsAboutYourVehicle,
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),

            // Vehicle Type
            Text(
              '${l10n.vehicleTypeLabel} *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _vehicleTypes.map((type) {
                final isSelected = _selectedVehicleType == type;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedVehicleType = type;
                    _vehicleTypeError = null;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.background,
                      border: Border.all(
                        color: _vehicleTypeError != null
                            ? AppColors.error
                            : (isSelected
                                  ? AppColors.primary
                                  : AppColors.border),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      type.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.textWhite
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (_vehicleTypeError != null) ...[
              const SizedBox(height: 8),
              Text(
                _vehicleTypeError!,
                style: TextStyle(fontSize: 12, color: AppColors.error),
              ),
            ],
            const SizedBox(height: 24),

            // Vehicle Model
            AppTextField(
              controller: _vehicleModelController,
              label: '${l10n.vehicleModelLabel} *',
              hint: l10n.vehicleModelHint,
              type: AppTextFieldType.text,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.pleaseEnterVehicleModel;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Vehicle Year
            AppTextField(
              controller: _vehicleYearController,
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
            Text(
              '${l10n.country} *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                _showCountrySelector();
                setState(() {
                  _countryError = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border.all(
                    color: _countryError != null
                        ? AppColors.error
                        : AppColors.border,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCountry.isEmpty
                          ? l10n.selectCountry
                          : _countries[_selectedCountry] ?? l10n.selectCountry,
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedCountry.isEmpty
                            ? AppColors.textLight
                            : AppColors.textPrimary,
                      ),
                    ),
                    const Icon(
                      Icons.expand_more,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            if (_countryError != null) ...[
              const SizedBox(height: 8),
              Text(
                _countryError!,
                style: TextStyle(fontSize: 12, color: AppColors.error),
              ),
            ],
            const SizedBox(height: 16),

            // Province/State
            AppTextField(
              controller: _provinceController,
              label: '${l10n.provinceStateLabel} *',
              hint: l10n.provinceStateHint,
              type: AppTextFieldType.text,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.pleaseEnterProvinceState;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Vehicle Image
            Text(
              l10n.vehicleImageOptional,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showImagePickerOptions(true),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  border: Border.all(
                    color: AppColors.border,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _vehicleImage != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _vehicleImage!,
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => setState(() => _vehicleImage = null),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: AppColors.textWhite,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 32,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.tapToAddVehicleImage,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKeyStep2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sparePartDetails,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.describePartYouNeed,
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),

            // Part Name
            AppTextField(
              controller: _partNameController,
              label: '${l10n.partNameLabel} *',
              hint: l10n.partNameHint,
              type: AppTextFieldType.text,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.pleaseEnterPartName;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Part Number
            AppTextField(
              controller: _partNumberController,
              label: l10n.partNumberLabel,
              hint: l10n.partNumberHint,
              type: AppTextFieldType.text,
            ),
            const SizedBox(height: 16),

            // Description
            AppTextField(
              controller: _descriptionController,
              label: '${l10n.descriptionLabel} *',
              hint: l10n.descriptionHint,
              type: AppTextFieldType.multiline,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.pleaseEnterDescription;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Part Image
            Text(
              l10n.partImageOptional,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showImagePickerOptions(false),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  border: Border.all(
                    color: AppColors.border,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _partImage != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _partImage!,
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => setState(() => _partImage = null),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: AppColors.textWhite,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 32,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.tapToAddPartImage,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Part Video
            Text(
              l10n.partVideoOptional,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickVideo,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  border: Border.all(
                    color: _partVideo != null
                        ? AppColors.primary
                        : AppColors.border,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _partVideo != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam,
                            size: 32,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.videoSelected,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => setState(() => _partVideo = null),
                            child: Text(
                              l10n.remove,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam_outlined,
                            size: 32,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.tapToAddPartVideo,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
