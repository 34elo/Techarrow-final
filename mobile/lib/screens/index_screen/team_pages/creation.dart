import 'package:flutter/material.dart';
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/screens/index_screen/pages/team.dart';
import 'package:techarrow_2026_app/services/api.dart';
import 'package:techarrow_2026_app/widgets/app_snackbar.dart';

class TeamCreationPage extends StatefulWidget {
  const TeamCreationPage({super.key, required this.changePage});

  final void Function(TeamPageStatus status) changePage;

  @override
  State<TeamCreationPage> createState() => _TeamCreationPageState();
}

class _TeamCreationPageState extends State<TeamCreationPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    if (name.isEmpty) {
      AppSnackBar.error(context, 'Введите название команды');
      return;
    }
    if (description.isEmpty) {
      AppSnackBar.error(context, 'Введите описание команды');
      return;
    }

    setState(() => _submitting = true);
    try {
      final res = await ApiService.instance.client.apiTeamsPost(
        body: TeamCreate(name: name, description: description),
      );
      if (!mounted) return;

      if (res.isSuccessful && res.body != null) {
        widget.changePage(TeamPageStatus.info);
      } else {
        AppSnackBar.serverError(
          context,
          fallback: 'Не удалось создать команду',
          response: res,
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.serverError(
        context,
        fallback: 'Ошибка при создании команды',
        error: e,
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    widget.changePage(TeamPageStatus.join);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                Text(
                  "Создание команды",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 20),

            // Team name
            Text("Название команды", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "Патиссоны",
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainer,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 20),

            // Description
            Text("Описание", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: "Добавьте пару слов о вашей команде",
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainer,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            Spacer(),

            // Create button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  foregroundColor: Colors.black87,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text("Создать"),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
