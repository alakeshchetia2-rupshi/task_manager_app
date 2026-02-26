import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  String _currentFilter = 'All';
  bool _isLoading = false;

  List<Task> get tasks => _filteredTasks;
  String get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;

  // Fetch tasks from API
  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await ApiService().fetchTasks();
      _filteredTasks = _tasks;
    } catch (e) {
      print('Error fetching tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter tasks
  void filterTasks(String filter) {
    _currentFilter = filter;
    
    if (filter == 'All') {
      _filteredTasks = _tasks;
    } else if (filter == 'Completed') {
      _filteredTasks = _tasks.where((task) => task.completed).toList();
    } else if (filter == 'Pending') {
      _filteredTasks = _tasks.where((task) => !task.completed).toList();
    }
    
    notifyListeners();
  }
}