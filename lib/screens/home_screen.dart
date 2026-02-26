import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch tasks when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Navigate back to login
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Buttons
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFilterButton('All', Colors.blue),
                _buildFilterButton('Pending', Colors.orange),
                _buildFilterButton('Completed', Colors.green),
              ],
            ),
          ),
          
          // Tasks List
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                if (taskProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (taskProvider.tasks.isEmpty) {
                  return const Center(
                    child: Text('No tasks found'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: task.completed 
                              ? Colors.green 
                              : Colors.orange,
                          child: Icon(
                            task.completed 
                                ? Icons.check 
                                : Icons.access_time,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration: task.completed 
                                ? TextDecoration.lineThrough 
                                : null,
                          ),
                        ),
                        subtitle: Text(
                          task.completed ? 'Completed' : 'Pending',
                          style: TextStyle(
                            color: task.completed 
                                ? Colors.green 
                                : Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Icon(
                          task.completed 
                              ? Icons.check_circle 
                              : Icons.radio_button_unchecked,
                          color: task.completed 
                              ? Colors.green 
                              : Colors.grey,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, Color color) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        bool isSelected = taskProvider.currentFilter == label;
        
        return ElevatedButton(
          onPressed: () {
            taskProvider.filterTasks(label);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? color : Colors.white,
            foregroundColor: isSelected ? Colors.white : color,
            side: BorderSide(color: color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(label),
        );
      },
    );
  }
}