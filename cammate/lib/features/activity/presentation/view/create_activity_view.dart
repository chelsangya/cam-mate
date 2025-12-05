import 'package:cammate/core/common/appbar/my_custom_appbar.dart';
import 'package:cammate/features/activity/presentation/view_model/activity_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateActivityView extends ConsumerStatefulWidget {
  const CreateActivityView({super.key});

  @override
  ConsumerState<CreateActivityView> createState() => _CreateActivityViewState();
}

class _CreateActivityViewState extends ConsumerState<CreateActivityView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cameraIdController = TextEditingController();
  final TextEditingController _activityTypeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _confidenceController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();

  @override
  void dispose() {
    _cameraIdController.dispose();
    _activityTypeController.dispose();
    _descriptionController.dispose();
    _confidenceController.dispose();
    _statusController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // nothing to prefetch for create activity form
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final cameraId = int.tryParse(_cameraIdController.text.trim());
    final confidence = double.tryParse(_confidenceController.text.trim()) ?? 0.0;
    if (cameraId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Camera ID is required and must be a number')));
      return;
    }

    ref
        .read(activityViewModelProvider.notifier)
        .createActivity(
          cameraId: cameraId,
          activityType: _activityTypeController.text.trim(),
          description: _descriptionController.text.trim(),
          confidence: confidence,
          status: _statusController.text.trim().isEmpty ? null : _statusController.text.trim(),
          priority:
              _priorityController.text.trim().isEmpty ? null : _priorityController.text.trim(),
          context: context,
        );
  }

  InputDecoration _fieldDecoration(BuildContext context, String label) => InputDecoration(
    labelText: label,
    filled: true,
    // subtle contrast inside the white card
    fillColor: Colors.grey.shade50,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activityViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: myCustomAppBar(context, 'Create Activity'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _cameraIdController,
                      decoration: _fieldDecoration(context, 'Camera ID'),
                      keyboardType: TextInputType.number,
                      validator:
                          (v) => (v == null || v.trim().isEmpty) ? 'Camera ID is required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _activityTypeController,
                      decoration: _fieldDecoration(context, 'Activity Type'),
                      validator:
                          (v) =>
                              (v == null || v.trim().isEmpty) ? 'Activity type is required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: _fieldDecoration(context, 'Description'),
                      maxLines: 3,
                      validator:
                          (v) => (v == null || v.trim().isEmpty) ? 'Description is required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _confidenceController,
                      decoration: _fieldDecoration(context, 'Confidence (0.0 - 1.0)'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Confidence is required';
                        final parsed = double.tryParse(v.trim());
                        if (parsed == null) return 'Enter a valid number';
                        if (parsed < 0 || parsed > 1) return 'Confidence must be between 0 and 1';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _statusController,
                      decoration: _fieldDecoration(context, 'Status (optional)'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _priorityController,
                      decoration: _fieldDecoration(context, 'Priority (optional)'),
                    ),
                    const SizedBox(height: 12),
                    const SizedBox.shrink(),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: state.isLoading ? null : _submit,
                        child:
                            state.isLoading
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Creating...'),
                                  ],
                                )
                                : const Text('Create Activity'),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
