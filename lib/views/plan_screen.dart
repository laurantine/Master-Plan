import 'package:flutter/material.dart';
import 'package:master_plan/plan_provider.dart';
import '../models/data_layer.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  // Plan plan = const Plan();
  late ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        FocusScope.of(context).requestFocus(FocusNode());
      });
  }

  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    Widget _buildAddTaskButton(BuildContext context) {
      ValueNotifier<Plan> planNotifier = PlanProvider.of(context);
      return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Plan currentPlan = planNotifier.value;
          planNotifier.value = Plan(
            name: currentPlan.name,
            tasks: List<Task>.from(currentPlan.tasks)..add(const Task()),
          );
          // setState(() {
          //   plan = Plan(
          //       name: plan.name,
          //       tasks: List<Task>.from(plan.tasks)..add(const Task()));
          // });
        },
      );
    }

    Widget _buildTaskTile(Task task, int index, BuildContext context) {
      ValueNotifier<Plan> planNotifier = PlanProvider.of(context);
      return ListTile(
        leading: Checkbox(
            value: task.complete,
            onChanged: (selected) {
              Plan currentPlan = planNotifier.value;
              planNotifier.value = Plan(
                name: currentPlan.name,
                tasks: List<Task>.from(currentPlan.tasks)
                  ..[index] = Task(
                    description: task.description,
                    complete: selected ?? false,
                  ),
              );
              // setState(() {
              //   plan = Plan(
              //     name: plan.name,
              //     tasks: List<Task>.from(plan.tasks)
              //       ..[index] = Task(
              //         description: task.description,
              //         complete: selected ?? false,
              //       ),
              //   );
              // });
            }),
        title: TextFormField(
          initialValue: task.description,
          onChanged: (text) {
            Plan currentPlan = planNotifier.value;
            planNotifier.value = Plan(
              name: currentPlan.name,
              tasks: List<Task>.from(currentPlan.tasks)
                ..[index] = Task(
                  description: text,
                  complete: task.complete,
                ),
            );
            // setState(() {
            //   plan = Plan(
            //     name: plan.name,
            //     tasks: List<Task>.from(plan.tasks)
            //       ..[index] = Task(
            //         complete: task.complete,
            //         description: text,
            //       ),
            //   );
            // }),
          },
        ),
      );
    }

    Widget _buildList(Plan plan) {
      return ListView.builder(
          controller: scrollController,
          keyboardDismissBehavior:
              Theme.of(context).platform == TargetPlatform.iOS
                  ? ScrollViewKeyboardDismissBehavior.onDrag
                  : ScrollViewKeyboardDismissBehavior.manual,
          itemCount: plan.tasks.length,
          itemBuilder: (context, index) =>
              _buildTaskTile(plan.tasks[index], index, context));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Master Plan"),
      ),
      body: ValueListenableBuilder<Plan>(
        valueListenable: PlanProvider.of(context),
        builder: (context, plan, child) {
          return Column(
            children: [
              Expanded(child: _buildList(plan)),
              SafeArea(child: Text(plan.completenessMessage))
            ],
          );
        },
      ),
      floatingActionButton: _buildAddTaskButton(context),
    );
  }
}
