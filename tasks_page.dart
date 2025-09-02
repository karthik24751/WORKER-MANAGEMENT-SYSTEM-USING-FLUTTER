import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_theme.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadMockTasks();
  }

  void _loadMockTasks() {
    _tasks.addAll([
      Task(
        id: '1',
        title: 'Safety Inspection',
        description: 'Complete monthly safety inspection of construction site',
        assignedTo: 'John Worker',
        assignedBy: 'Manager Smith',
        priority: TaskPriority.high,
        status: TaskStatus.inProgress,
        dueDate: DateTime.now().add(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Safety',
      ),
      Task(
        id: '2',
        title: 'Equipment Maintenance',
        description: 'Perform routine maintenance on excavator',
        assignedTo: 'Sarah Worker',
        assignedBy: 'Manager Smith',
        priority: TaskPriority.medium,
        status: TaskStatus.pending,
        dueDate: DateTime.now().add(const Duration(days: 5)),
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        category: 'Maintenance',
      ),
      Task(
        id: '3',
        title: 'Material Delivery Check',
        description: 'Verify and document incoming material delivery',
        assignedTo: 'Mike Worker',
        assignedBy: 'Manager Smith',
        priority: TaskPriority.low,
        status: TaskStatus.completed,
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        completedAt: DateTime.now().subtract(const Duration(hours: 2)),
        category: 'Logistics',
      ),
      Task(
        id: '4',
        title: 'Quality Control Review',
        description: 'Review concrete pouring quality and documentation',
        assignedTo: 'Lisa Worker',
        assignedBy: 'Manager Smith',
        priority: TaskPriority.high,
        status: TaskStatus.overdue,
        dueDate: DateTime.now().subtract(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        category: 'Quality',
      ),
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text(
          'Tasks',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showFilterDialog(context),
            icon: const Icon(Icons.filter_list),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'In Progress'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(_tasks),
          _buildTaskList(_tasks.where((t) => t.status == TaskStatus.pending).toList()),
          _buildTaskList(_tasks.where((t) => t.status == TaskStatus.inProgress).toList()),
          _buildTaskList(_tasks.where((t) => t.status == TaskStatus.completed).toList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTaskDialog(context),
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppTheme.paddingMedium),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task)
            .animate(delay: Duration(milliseconds: index * 100))
            .fadeIn()
            .slideY(begin: 0.3);
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => _showTaskDetails(context, task),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        child: Padding(
          padding: EdgeInsets.all(AppTheme.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  _buildPriorityBadge(task.priority, theme),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Text(
                task.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task.assignedTo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.category,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task.category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: _getDueDateColor(task),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Due: ${_formatDate(task.dueDate)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getDueDateColor(task),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  _buildStatusBadge(task.status, theme),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(TaskPriority priority, ThemeData theme) {
    Color color;
    String label;
    
    switch (priority) {
      case TaskPriority.high:
        color = Colors.red;
        label = 'HIGH';
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        label = 'MED';
        break;
      case TaskPriority.low:
        color = Colors.green;
        label = 'LOW';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TaskStatus status, ThemeData theme) {
    Color color;
    String label;
    
    switch (status) {
      case TaskStatus.pending:
        color = Colors.grey;
        label = 'PENDING';
        break;
      case TaskStatus.inProgress:
        color = Colors.blue;
        label = 'IN PROGRESS';
        break;
      case TaskStatus.completed:
        color = Colors.green;
        label = 'COMPLETED';
        break;
      case TaskStatus.overdue:
        color = Colors.red;
        label = 'OVERDUE';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Color _getDueDateColor(Task task) {
    final now = DateTime.now();
    final difference = task.dueDate.difference(now).inDays;
    
    if (difference < 0) return Colors.red;
    if (difference <= 1) return Colors.orange;
    return Colors.grey;
  }

  void _showTaskDetails(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(AppTheme.paddingLarge),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildPriorityBadge(task.priority, Theme.of(context)),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(task.description),
                
                const SizedBox(height: 16),
                
                _buildDetailRow('Assigned To', task.assignedTo, Icons.person),
                _buildDetailRow('Assigned By', task.assignedBy, Icons.supervisor_account),
                _buildDetailRow('Category', task.category, Icons.category),
                _buildDetailRow('Due Date', _formatDate(task.dueDate), Icons.schedule),
                _buildDetailRow('Created', _formatDate(task.createdAt), Icons.create),
                
                if (task.completedAt != null)
                  _buildDetailRow('Completed', _formatDate(task.completedAt!), Icons.check_circle),
                
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updateTaskStatus(task, TaskStatus.inProgress),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Task'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updateTaskStatus(task, TaskStatus.completed),
                        icon: const Icon(Icons.check),
                        label: const Text('Complete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _updateTaskStatus(Task task, TaskStatus newStatus) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task.copyWith(
          status: newStatus,
          completedAt: newStatus == TaskStatus.completed ? DateTime.now() : null,
        );
      }
    });
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task status updated to ${newStatus.name}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showCreateTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    TaskPriority selectedPriority = TaskPriority.medium;
    String selectedCategory = 'General';
    DateTime selectedDueDate = DateTime.now().add(const Duration(days: 7));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create New Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<TaskPriority>(
                  value: selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  items: TaskPriority.values.map((priority) => 
                    DropdownMenuItem(
                      value: priority,
                      child: Text(priority.name.toUpperCase()),
                    ),
                  ).toList(),
                  onChanged: (value) => setState(() => selectedPriority = value!),
                ),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: ['General', 'Safety', 'Maintenance', 'Quality', 'Logistics']
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => selectedCategory = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  _createTask(
                    titleController.text,
                    descriptionController.text,
                    selectedPriority,
                    selectedCategory,
                    selectedDueDate,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _createTask(String title, String description, TaskPriority priority, String category, DateTime dueDate) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      assignedTo: 'Current User',
      assignedBy: 'Manager',
      priority: priority,
      status: TaskStatus.pending,
      dueDate: dueDate,
      createdAt: DateTime.now(),
      category: category,
    );

    setState(() {
      _tasks.insert(0, newTask);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task created successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Tasks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('By Priority'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              title: const Text('By Category'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              title: const Text('By Due Date'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

enum TaskPriority { high, medium, low }
enum TaskStatus { pending, inProgress, completed, overdue }

class Task {
  final String id;
  final String title;
  final String description;
  final String assignedTo;
  final String assignedBy;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String category;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.assignedBy,
    required this.priority,
    required this.status,
    required this.dueDate,
    required this.createdAt,
    this.completedAt,
    required this.category,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? assignedTo,
    String? assignedBy,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? completedAt,
    String? category,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedBy: assignedBy ?? this.assignedBy,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      category: category ?? this.category,
    );
  }
}
