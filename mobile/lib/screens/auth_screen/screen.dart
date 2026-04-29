import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:techarrow_2026_app/services/auth.dart';

enum _ScreenStates { regFirst, regLast, login }

final RegExp _emailFormat = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

bool _isValidEmail(String raw) {
  final s = raw.trim();
  return s.isNotEmpty && _emailFormat.hasMatch(s);
}

bool _isValidPassword(String raw) => raw.length >= 8;

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({super.key});

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime? birthdate;
  final _nicknameController = TextEditingController();
  bool _hidePassword = true;
  _ScreenStates _state = _ScreenStates.login;

  bool get _canProceedRegistrationFirst =>
      _nicknameController.text.trim().isNotEmpty && birthdate != null;

  bool get _canSubmitRegistration =>
      _canProceedRegistrationFirst &&
      _isValidEmail(_emailController.text) &&
      _isValidPassword(_passwordController.text);

  bool get _canSubmitLogin =>
      _isValidEmail(_emailController.text) &&
      _isValidPassword(_passwordController.text);

  String? get _emailFieldError {
    final t = _emailController.text.trim();
    if (t.isEmpty) return null;
    if (!_isValidEmail(_emailController.text)) {
      return 'Введите корректный адрес почты';
    }
    return null;
  }

  String? get _passwordFieldError {
    final t = _passwordController.text;
    if (t.isEmpty) return null;
    if (!_isValidPassword(t)) {
      return 'Пароль должен содержать не менее 8 символов';
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {});

    await StreamAuthScope.of(
      context,
    ).signIn(_emailController.text.trim(), _passwordController.text);

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _signOn() async {
    if (!_canSubmitRegistration) return;

    setState(() {});

    await StreamAuthScope.of(context).signOn(
      _emailController.text.trim(),
      _passwordController.text,
      _nicknameController.text,
      birthdate!,
    );

    if (!mounted) return;

    setState(() {});
  }

  void setScreenState(_ScreenStates newState) {
    setState(() {
      final switchesBetweenLoginAndRegistration =
          (_state == _ScreenStates.login) != (newState == _ScreenStates.login);
      if (switchesBetweenLoginAndRegistration) {
        _resetFields();
      }
      _state = newState;
    });
  }

  void _resetFields() {
    _emailController.clear();
    _passwordController.clear();
    _nicknameController.clear();
    birthdate = null;
    _hidePassword = true;
  }

  @override
  void initState() {
    super.initState();
  }

  ButtonStyle _primaryButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.surfaceContainerHighest;
        }
        return theme.primaryColorLight;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurfaceVariant;
        }
        return colorScheme.onPrimary;
      }),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _state == _ScreenStates.regLast
                ? _buildRegistrationSecond(context)
                : _state == _ScreenStates.regFirst
                ? _buildRegistrationFirst(context)
                : _buildLogin(context),
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationFirst(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(height: 70),
      Text(
        'Регистрация',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: MediaQuery.of(context).size.width / 1.2,
        child: Text(
          'Заполните свои данные для регистрации',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 24),
      _buildField(
        context,
        label: "Никнейм",
        controller: _nicknameController,
        hint: "Введите никнейм",
      ),
      const SizedBox(height: 24),
      _buildDateField(
        context,
        label: "Дата рождения",
        hint: "ДД.ММ.ГГГГ",
        selectedDate: birthdate,
        onDateSelected: (date) {
          setState(() {
            birthdate = date;
          });
        },
      ),

      const SizedBox(height: 48),
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: _primaryButtonStyle(context),
              onPressed: _canProceedRegistrationFirst
                  ? () => setScreenState(_ScreenStates.regLast)
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Далее"),
              ),
            ),
          ),
        ],
      ),
      Spacer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          Text("Есть аккаунт?"),
          InkWell(
            onTap: () {
              setScreenState(_ScreenStates.login);
            },
            child: Text(
              "Войти",
              style: Theme.of(
                context,
              ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      SizedBox(height: 20),
    ],
  );

  Widget _buildRegistrationSecond(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => setScreenState(_ScreenStates.regFirst),
            iconSize: 24,
            icon: Icon(Icons.arrow_back),
          ),
        ],
      ),
      const SizedBox(height: 22),
      Text(
        'Регистрация',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: MediaQuery.of(context).size.width / 1.2,
        child: Text(
          'Заполните свои данные для регистрации',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 24),
      _buildField(
        context,
        label: "Почта",
        controller: _emailController,
        hint: "Введите почту",
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        errorText: _emailFieldError,
      ),
      const SizedBox(height: 24),
      _buildField(
        context,
        label: "Пароль",
        controller: _passwordController,
        hidden: _hidePassword,
        onHide: (value) {
          setState(() {
            _hidePassword = value;
          });
        },
        hint: "Введите пароль",
        errorText: _passwordFieldError,
      ),

      const SizedBox(height: 48),
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: _primaryButtonStyle(context),
              onPressed: _canSubmitRegistration ? _signOn : null,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Зарегистрироваться"),
              ),
            ),
          ),
        ],
      ),
      Spacer(),
    ],
  );

  Widget _buildLogin(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Spacer(),
      Text(
        'Привет!',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: MediaQuery.of(context).size.width / 1.2,
        child: Text(
          'Заполните свои данные для входа в аккаунт или зарегестрируйтесь',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 24),
      _buildField(
        context,
        label: "Почта",
        controller: _emailController,
        hint: "Введите почту",
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        errorText: _emailFieldError,
      ),
      const SizedBox(height: 24),
      _buildField(
        context,
        label: "Пароль",
        controller: _passwordController,
        hidden: _hidePassword,
        onHide: (value) {
          setState(() {
            _hidePassword = value;
          });
        },
        hint: "Введите пароль",
        errorText: _passwordFieldError,
      ),

      const SizedBox(height: 48),
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: _primaryButtonStyle(context),
              onPressed: _canSubmitLogin ? _signIn : null,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Войти"),
              ),
            ),
          ),
        ],
      ),
      Spacer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          Text("Вы впервые?"),
          InkWell(
            onTap: () {
              setScreenState(_ScreenStates.regFirst);
            },
            child: Text(
              "Зарегистрироваться",
              style: Theme.of(
                context,
              ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      SizedBox(height: 20),
    ],
  );

  Widget _buildField(
    BuildContext context, {
    required String label,
    TextEditingController? controller,
    FocusNode? focusNode,
    void Function(bool value)? onHide,
    required String hint,
    bool? hidden,
    TextInputType keyboardType = TextInputType.text,
    bool autocorrect = true,
    String? errorText,
  }) {
    final borderRadius = BorderRadius.circular(14);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: hidden ?? false,
          keyboardType: keyboardType,
          autocorrect: autocorrect,
          textAlignVertical: TextAlignVertical.center,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: onHide != null && hidden != null
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Icon(
                      !hidden ? Icons.visibility : Icons.visibility_off,
                    ),
                    onTap: () => onHide(!hidden),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required String label,
    required String hint,
    required DateTime? selectedDate,
    required void Function(DateTime) onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _showBirthdatePicker(
            context,
            selectedDate: selectedDate,
            onDateSelected: onDateSelected,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? "${selectedDate.day.toString().padLeft(2, '0')}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.year}"
                        : hint,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: selectedDate != null
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
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
}
