import 'package:flutter/material.dart';
import '../models/data_layer.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  Plan plan = const Plan();
  @override
  Widget build(BuildContext context) {
    Widget _buildAddTaskButton() {
      return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            plan = Plan(
                name: plan.name,
                tasks: List<Task>.from(plan.tasks)..add(const Task()));
          });
        },
      );
    }

    Widget _buildTaskTile(Task task, int index) {
      return ListTile(
        leading: Checkbox(
            value: task.complete,
            onChanged: (selected) {
              setState(() {
                plan = Plan(
                  name: plan.name,
                  tasks: List<Task>.from(plan.tasks)
                    ..[index] = Task(
                      description: task.description,
                      complete: selected ?? false,
                    ),
                );
              });
            }),
        title: TextFormField(
          initialValue: task.description,
          onChanged: (text) => {
            setState(() {
              plan = Plan(
                name: plan.name,
                tasks: List<Task>.from(plan.tasks)
                  ..[index] = Task(
                    complete: task.complete,
                    description: text,
                  ),
              );
            }),
          },
        ),
      );
    }

    Widget _buildList() {
      return ListView.builder(
          itemCount: plan.tasks.length,
          itemBuilder: (context, index) =>
              _buildTaskTile(plan.tasks[index], index));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Master Plan"),
      ),
      body: _buildList(),
      floatingActionButton: _buildAddTaskButton(),
    );
  }
}
