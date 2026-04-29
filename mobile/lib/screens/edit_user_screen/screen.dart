import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/services/api.dart';
import 'package:techarrow_2026_app/services/auth.dart';
import 'package:techarrow_2026_app/widgets/app_snackbar.dart';

/// Profile edit: nickname, date of birth, email, password — layout per design mock.
class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  static const Color _fieldFill = Color(0xFFEBF0F5);
  static const Color _saveButtonFill = Color(0xFFD9E6F2);

  late final TextEditingController _nicknameCtrl;
  DateTime? _birthdate;
  bool _isSaving = false;
  bool _didInitFromAuth = false;

  @override
  void initState() {
    super.initState();
    _nicknameCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitFromAuth) return;
    final me = StreamAuthScope.of(context).currentUser;
    _nicknameCtrl.text = me?.username ?? '';
    _birthdate = me?.birthdate;
    _didInitFromAuth = true;
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(
    BuildContext context, {
    String? hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: _fieldFill,
      hintText: hintText,
      hintStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      suffixIcon: suffixIcon,
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required String label,
    required String hint,
    required DateTime? selectedDate,
    required void Function(DateTime) onDateSelected,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _showBirthdatePicker(
            context,
            selectedDate: selectedDate,
            onDateSelected: onDateSelected,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: _fieldFill,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? "${selectedDate.day.toString().padLeft(2, '0')}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.year}"
                        : hint,
                    style: textTheme.bodyLarge?.copyWith(
                      color: selectedDate != null
                          ? onSurface
                          : onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(Icons.calendar_today, color: onSurfaceVariant),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showBirthdatePicker(
    BuildContext context, {
    required DateTime? selectedDate,
    required void Function(DateTime) onDateSelected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final buttonColor = colorScheme.primary;
    final now = DateTime.now();
    final initialDate =
        selectedDate ?? DateTime(now.year - 16, now.month, now.day);

    BottomPicker.date(
      dismissable: true,
      initialDateTime: initialDate,
      minDateTime: DateTime(1900),
      maxDateTime: now,
      dateOrder: DatePickerDateOrder.dmy,
      backgroundColor: colorScheme.surface,
      buttonWidth: MediaQuery.of(context).size.width - 40,
      buttonPadding: 14,
      buttonSingleColor: buttonColor,
      pickerThemeData: CupertinoTextThemeData(
        dateTimePickerTextStyle: theme.textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      headerBuilder: (pickerContext) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Выберите дату рождения',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(pickerContext).pop(),
              icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
      buttonContent: Text(
        'Готово',
        textAlign: TextAlign.center,
        style: theme.textTheme.labelLarge?.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      buttonStyle: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(14),
      ),
      onSubmit: (date) {
        if (date is DateTime) {
          onDateSelected(date);
        }
      },
    ).show(context);
  }

  Future<void> _save() async {
    if (_isSaving) return;
    final username = _nicknameCtrl.text.trim();
    if (username.isEmpty) {
      AppSnackBar.error(context, 'Введите никнейм');
      return;
    }
    if (_birthdate == null) {
      AppSnackBar.error(context, 'Выберите дату рождения');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final res = await ApiService.instance.client.apiAuthMePatch(
        body: UserUpdate(username: username, birthdate: _birthdate),
      );
      if (!mounted) return;
      if (res.isSuccessful) {
        await StreamAuthScope.of(context).refreshMe();
        if (!mounted) return;
        Navigator.of(context).maybePop();
        return;
      }
      AppSnackBar.serverError(
        context,
        fallback: 'Не удалось сохранить',
        response: res,
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.serverError(
        context,
        fallback: 'Не удалось сохранить',
        error: e,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Редактирование',
          style: textTheme.titleMedium?.copyWith(
            color: onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back, color: onSurface),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _labeledBlock(
                label: 'Никнейм',
                child: TextField(
                  controller: _nicknameCtrl,
                  style: textTheme.bodyLarge?.copyWith(color: onSurface),
                  decoration: _fieldDecoration(context),
                ),
                textTheme: textTheme,
                onSurface: onSurface,
              ),
              const SizedBox(height: 20),
              _buildDateField(
                context,
                label: 'Дата рождения',
                hint: 'ДД.ММ.ГГГГ',
                selectedDate: _birthdate,
                onDateSelected: (d) => setState(() => _birthdate = d),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _saveButtonFill,
                    foregroundColor: onSurface,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isSaving ? null : _save,
                  child: Text(
                    _isSaving ? 'Сохранение...' : 'Сохранить',
                    style: textTheme.titleMedium?.copyWith(
                      color: onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _labeledBlock({
    required String label,
    required Widget child,
    required TextTheme textTheme,
    required Color onSurface,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
