import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_part_app/core/di/service_locator.dart';
import 'package:vehicle_part_app/core/services/image_compression_service.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import 'package:vehicle_part_app/shared/widgets/loading_indicator.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';
import '../providers/create_request_provider.dart';
import '../widgets/beautiful_stepper_widget.dart';
import '../widgets/step1_form_widget.dart';
import '../widgets/step2_form_widget.dart';
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

  // Step 2 Controllers
  final _partNameController = TextEditingController();
  final _partNumberController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Form values
  String _selectedVehicleType = 'car';
  String? _selectedProvinceKey; // Store province key instead of localized name
  File? _vehicleImage;
  File? _partImage;
  File? _partVideo;

  // Validation error messages
  String? _vehicleTypeError;
  String? _provinceError;

  final ImagePicker _imagePicker = ImagePicker();
  late final ImageCompressionService _compressionService;

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

  // Province keys (used to get localized names)
  final List<String> _provinceKeys = [
    'western',
    'central',
    'southern',
    'northern',
    'eastern',
    'northWestern',
    'northCentral',
    'uva',
    'sabaragamuwa',
  ];

  // Get localized province names
  List<String> _getProvinceNames(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _provinceKeys.map((key) {
      switch (key) {
        case 'western':
          return l10n.provinceWestern;
        case 'central':
          return l10n.provinceCentral;
        case 'southern':
          return l10n.provinceSouthern;
        case 'northern':
          return l10n.provinceNorthern;
        case 'eastern':
          return l10n.provinceEastern;
        case 'northWestern':
          return l10n.provinceNorthWestern;
        case 'northCentral':
          return l10n.provinceNorthCentral;
        case 'uva':
          return l10n.provinceUva;
        case 'sabaragamuwa':
          return l10n.provinceSabaragamuwa;
        default:
          return '';
      }
    }).toList();
  }

  // Get province key from localized name
  String? _getProvinceKey(String? localizedName, BuildContext context) {
    if (localizedName == null) return null;
    final names = _getProvinceNames(context);
    final index = names.indexOf(localizedName);
    return index >= 0 ? _provinceKeys[index] : null;
  }

  // Get localized name from province key
  String? _getProvinceName(String? key, BuildContext context) {
    if (key == null) return null;
    final index = _provinceKeys.indexOf(key);
    if (index >= 0) {
      return _getProvinceNames(context)[index];
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _compressionService = ServiceLocator.get<ImageCompressionService>();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _vehicleModelController.dispose();
    _vehicleYearController.dispose();
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
        imageQuality: 100, // Get original quality, we'll compress it ourselves
      );

      if (image != null) {
        final originalFile = File(image.path);
        
        // Show loading indicator while compressing
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          LoadingIndicator.show(
            context,
            message: l10n.compressingImage,
            subMessage: l10n.pleaseWait,
            barrierDismissible: false,
          );
        }

        try {
          // Compress the image using moderate settings (balanced quality and size)
          final compressedFile = await _compressionService.compressImageModerate(
            originalFile,
          );

          if (mounted) {
            LoadingIndicator.hide(context);
          }

          if (compressedFile != null) {
            // Get file sizes for feedback
            final originalSize = await _compressionService.getFileSize(originalFile);
            final compressedSize = await _compressionService.getFileSize(compressedFile);

            setState(() {
              if (isVehicleImage) {
                _vehicleImage = compressedFile;
              } else {
                _partImage = compressedFile;
              }
            });

            // Show success message with compression info
            if (mounted && originalSize != compressedSize) {
              final l10n = AppLocalizations.of(context)!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.imageCompressed(originalSize, compressedSize),
                  ),
                  backgroundColor: AppColors.success,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          } else {
            // If compression failed, use original file
            setState(() {
              if (isVehicleImage) {
                _vehicleImage = originalFile;
              } else {
                _partImage = originalFile;
              }
            });
          }
        } catch (compressionError) {
          if (mounted) {
            LoadingIndicator.hide(context);
            // If compression fails, use original file
            setState(() {
              if (isVehicleImage) {
                _vehicleImage = originalFile;
              } else {
                _partImage = originalFile;
              }
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        LoadingIndicator.hide(context);
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
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.takePhoto),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, isVehicleImage: isVehicleImage);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.chooseFromGallery),
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

  bool _validateStep1() {
    // Clear previous errors
    setState(() {
      _vehicleTypeError = null;
      _provinceError = null;
    });

    // Validate vehicle type
    if (_selectedVehicleType.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _vehicleTypeError = l10n.pleaseSelectVehicleType;
      });
    }

    // Validate province
    if (_selectedProvinceKey == null || _selectedProvinceKey!.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _provinceError = l10n.pleaseEnterProvinceState;
      });
    }

    // Validate form fields
    final isValid = _formKeyStep1.currentState?.validate() ?? false;

    // Return true only if all validations pass
    return isValid && _vehicleTypeError == null && _provinceError == null;
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

  Future<void> _submitRequest(CreateRequestProvider provider) async {
    // Show loading indicator before starting the request
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      LoadingIndicator.show(
        context,
        message: l10n.submittingRequest,
        subMessage: _partVideo != null
            ? l10n.uploadingVideoFile
            : l10n.pleaseWait,
        barrierDismissible: false,
      );
    }

    try {
      // Get localized province name for API (or use key, depending on backend requirement)
      final provinceName = _selectedProvinceKey != null
          ? _getProvinceName(_selectedProvinceKey, context) ?? ''
          : '';

      final data = CreateRequestData(
        vehicleType: _selectedVehicleType,
        vehicleModel: _vehicleModelController.text.trim(),
        vehicleYear: int.parse(_vehicleYearController.text.trim()),
        province: provinceName,
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

      // Hide loading indicator after request completes
      if (mounted) {
        LoadingIndicator.hide(context);
        // Wait a frame to ensure the dialog is dismissed before showing success dialog
        await Future.delayed(const Duration(milliseconds: 100));
      }

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
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                  child: Text(l10n.viewRequests),
                ),
              ],
            ),
          );
        }
      } else if (provider.hasError) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.errorMessage ?? l10n.failedToSubmitRequest),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      // Ensure loading indicator is hidden even if an error occurs
      if (mounted) {
        LoadingIndicator.hide(context);
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorSubmittingRequest(e.toString())),
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
      _selectedProvinceKey = null;
      _vehicleImage = null;
      _partImage = null;
      _partVideo = null;
    });
    _vehicleModelController.clear();
    _vehicleYearController.clear();
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
                size: 18,
              ),
              onPressed: () => context.go('/orders'),
            ),
          ),
          title: Column(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ).createShader(bounds),
                child: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return Text(
                      l10n.requestSparePartTitle,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Consumer<CreateRequestProvider>(
            builder: (context, provider, child) {
              return GestureDetector(
                onTap: () {
                  // Dismiss keyboard when tapping outside (only when not loading)
                  if (!provider.isLoading) {
                    FocusScope.of(context).unfocus();
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                  ),
                  child: Column(
                    children: [
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return BeautifulStepperWidget(
                            currentStep: _currentStep,
                            totalSteps: _totalSteps,
                            stepLabels: [l10n.vehicleInfo, l10n.partDetails],
                          );
                        },
                      ),

                      // Form Content
                      SizedBox(
                        height:
                            MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom -
                            kToolbarHeight -
                            100, // Approximate height for progress bar
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Step1FormWidget(
                              provider: provider,
                              formKey: _formKeyStep1,
                              vehicleModelController: _vehicleModelController,
                              vehicleYearController: _vehicleYearController,
                              selectedVehicleType: _selectedVehicleType,
                              selectedProvince: _selectedProvinceKey != null
                                  ? _getProvinceName(_selectedProvinceKey, context)
                                  : null,
                              vehicleImage: _vehicleImage,
                              vehicleTypeError: _vehicleTypeError,
                              provinceError: _provinceError,
                              vehicleTypes: _vehicleTypes,
                              provinces: _getProvinceNames(context),
                              onVehicleTypeSelected: (type) {
                                setState(() {
                                  _selectedVehicleType = type;
                                  _vehicleTypeError = null;
                                });
                              },
                              onProvinceSelected: (province) {
                                // Convert localized name back to key
                                final key = _getProvinceKey(province, context);
                                setState(() {
                                  _selectedProvinceKey = key;
                                  _provinceError = null;
                                });
                              },
                              onImagePickerTap: () =>
                                  _showImagePickerOptions(true),
                              onRemoveImage: () =>
                                  setState(() => _vehicleImage = null),
                              onNext: _handleNext,
                            ),
                            Step2FormWidget(
                              provider: provider,
                              formKey: _formKeyStep2,
                              partNameController: _partNameController,
                              partNumberController: _partNumberController,
                              descriptionController: _descriptionController,
                              partImage: _partImage,
                              partVideo: _partVideo,
                              onImagePickerTap: (isVehicle) =>
                                  _showImagePickerOptions(isVehicle),
                              onRemoveImage: () =>
                                  setState(() => _partImage = null),
                              onPickVideo: _pickVideo,
                              onRemoveVideo: () =>
                                  setState(() => _partVideo = null),
                              onSubmit: _handleNext,
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
        ),
      ),
    );
  }
}
