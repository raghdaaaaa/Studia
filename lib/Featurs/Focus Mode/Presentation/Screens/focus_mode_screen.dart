import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:studia/Featurs/Add_Task/Data/Services/task_service.dart';
import 'package:studia/Featurs/Focus%20Mode/Data/Services/focus_session_store.dart';
import 'package:studia/Featurs/Focus%20Mode/Presentation/Widgets/timer_circle.dart';
import 'package:studia/Featurs/Focus%20Mode/Presentation/Widgets/timer_controls.dart';
import '../../../../Core/Constants/app_strings.dart';
import '../../../../Core/Theme/app_palette.dart';
import '../../../../Core/Widgets/app_scaffold.dart';

class FocusModeScreen extends StatefulWidget {
  final String taskId;
  final String taskTitle;

  const FocusModeScreen({
    super.key,
    required this.taskId,
    required this.taskTitle,
  });

  @override
  State<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends State<FocusModeScreen> {
  static const int _totalSeconds = 25 * 60;

  final TaskService _taskService = TaskService();
  final FocusSessionStore _sessionStore = FocusSessionStore();

  Timer? _timer;
  int _remainingSeconds = _totalSeconds;
  int _todaySessions = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _loadTodaySessions();
  }

  Future<void> _loadTodaySessions() async {
    final count = await _sessionStore.todaySessionCount();
    if (!mounted) return;
    setState(() {
      _todaySessions = count;
    });
  }

  // A single focus block is 4 sessions; show the current session (capped).
  int get _currentSessionNumber {
    final next = _todaySessions + 1;
    return next.clamp(1, 4);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isRunning) {
      _pause();
    } else if (_remainingSeconds > 0) {
      if (widget.taskId.isEmpty) {
        _showMessage('Select a task first.');
        return;
      }
      _start();
    }
  }

  void _start() {
    if (_timer != null) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 1) {
        _pause();
        setState(() {
          _remainingSeconds = 0;
        });
        _completeTask();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _isRunning = false;
    });
  }

  void _reset() {
    _pause();
    setState(() {
      _remainingSeconds = _totalSeconds;
    });
  }

  Future<void> _completeTask() async {
    if (widget.taskId.isEmpty) return;

    try {
      await _taskService.updateTaskCompletion(
        taskId: widget.taskId,
        isCompleted: true,
      );
      await _sessionStore.recordSession();

      if (!mounted) return;

      final count = await _sessionStore.todaySessionCount();
      if (!mounted) return;

      setState(() {
        _todaySessions = count;
      });

      _showMessage('Focus session complete!');
    } catch (e) {
      if (!mounted) return;
      _showMessage('Could not update task: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        ((_totalSeconds - _remainingSeconds) / _totalSeconds)
            .clamp(0.0, 1.0)
            .toDouble();

    return AppScaffold(
      showBottomNav: false,
      showFab: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: math.max(0.0, constraints.maxHeight - 100),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.focusModeTitle,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                          color: context.accentColor,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Task Name + Sessions Counter
                      Column(
                        children: [
                          Text(
                            widget.taskTitle.isEmpty
                                ? AppStrings.focusModeCurrentTask
                                : widget.taskTitle,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                              color: context.accentColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.label,
                                size: 14,
                                color: context.textSecondaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Session $_currentSessionNumber of 4',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: context.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),

                      Center(
                        child: TimerCircle(
                          progress: progress,
                          timeText: _formatTime(_remainingSeconds),
                        ),
                      ),
                      const SizedBox(height: 50),

                      Center(
                        child: TimerControls(
                          isRunning: _isRunning,
                          onStop: _reset,
                          onPlayPause: _togglePlayPause,
                        ),
                      ),
                      const SizedBox(height: 55),

                      // Give Up Button
                      Center(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: BorderSide(
                              color: context.accentColor,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 55,
                              vertical: 15,
                            ),
                          ),
                          child: Text(
                            AppStrings.focusModeGiveUp,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: context.accentColor,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
