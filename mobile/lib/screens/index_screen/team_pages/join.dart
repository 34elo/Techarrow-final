import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/screens/index_screen/pages/team.dart';
import 'package:techarrow_2026_app/services/api.dart';
import 'package:techarrow_2026_app/widgets/app_snackbar.dart';

class TeamJoinPage extends StatefulWidget {
  const TeamJoinPage({super.key, required this.changePage});

  final void Function(TeamPageStatus status) changePage;

  @override
  State<TeamJoinPage> createState() => _TeamJoinPageState();
}

class _TeamJoinPageState extends State<TeamJoinPage>
    with SingleTickerProviderStateMixin {
  late TextEditingController _teamIdController;

  @override
  void initState() {
    super.initState();
    _teamIdController = TextEditingController();
  }

  @override
  void dispose() {
    _teamIdController.dispose();
    super.dispose();
  }

  Future<void> _joinTeam() async {
    final String teamId = _teamIdController.text.trim();
    if (teamId.isEmpty) {
      AppSnackBar.error(context, 'Введите ID команды');
      return;
    }
    try {
      final res = await ApiService.instance.client.apiTeamsJoinPost(
        body: TeamJoinRequest(code: teamId),
      );
      if (!mounted) return;
      if (res.isSuccessful) {
        widget.changePage(TeamPageStatus.info);
        return;
      }

      if (res.statusCode == 401) {
        AppSnackBar.error(context, 'Неверный ID команды');
        return;
      }

      AppSnackBar.serverError(
        context,
        fallback: 'Не удалось присоединиться к команде',
        response: res,
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.serverError(
        context,
        fallback: 'Ошибка при присоединении к команде',
        error: e,
      );
    }
  }

  void _scanQr() {
    Navigator.of(context)
        .push<String>(
          MaterialPageRoute(builder: (_) => const TeamQrScannerPage()),
        )
        .then((String? scannedTeamId) {
          if (scannedTeamId == null || scannedTeamId.isEmpty) {
            return;
          }
          _teamIdController.text = scannedTeamId;
          _joinTeam();
        });
  }

  void _createTeam() {
    widget.changePage(TeamPageStatus.create);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // Title
              Text(
                "Добавьте или создайте команду",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Text(
                "Введите ID команды или отсканируйте QR-код",
                style: TextStyle(color: Colors.grey[600]),
              ),

              SizedBox(height: 30),

              // Input label
              Text("ID команды"),
              SizedBox(height: 8),

              // Input field
              TextField(
                controller: _teamIdController,
                decoration: InputDecoration(
                  hintText: "000000000000",
                  filled: true,
                  fillColor: Colors.grey[300],
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Join + QR row
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _joinTeam,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondaryContainer,
                        foregroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text("Присоединиться"),
                    ),
                  ),
                  SizedBox(width: 12),

                  // QR button
                  IconButton(
                    onPressed: _scanQr,
                    padding: EdgeInsets.zero,
                    icon: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.qr_code_scanner),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Create button
              OutlinedButton(
                onPressed: _createTeam,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  side: BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Создать команду",
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamQrScannerPage extends StatefulWidget {
  const TeamQrScannerPage({super.key});

  @override
  State<TeamQrScannerPage> createState() => _TeamQrScannerPageState();
}

class _TeamQrScannerPageState extends State<TeamQrScannerPage> {
  bool _isHandlingScan = false;

  void _handleScan(String teamId) {
    if (_isHandlingScan) {
      return;
    }
    _isHandlingScan = true;
    Navigator.of(context).pop(teamId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Сканирование QR',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (capture.barcodes.isEmpty) {
            return;
          }
          final String? raw = capture.barcodes.first.rawValue?.trim();
          if (raw == null || raw.isEmpty) {
            return;
          }
          _handleScan(raw);
        },
      ),
    );
  }
}
