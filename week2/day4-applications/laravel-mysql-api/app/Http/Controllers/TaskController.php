<?php

namespace App\Http\Controllers;

use App\Models\Task;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    // GET /api/tasks
    public function index() {
        return response()->json(Task::all());
    }

    // POST /api/tasks
    public function store(Request $request) {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'status' => 'in:pending,in_progress,completed',
            'priority' => 'in:low,medium,high',
            'due_date' => 'nullable|date'
        ]);

        $task = Task::create($validated);
        return response()->json($task, 201);
    }

    // GET /api/tasks/{id}
    public function show($id) {
        $task = Task::find($id);
        if (!$task) return response()->json(['error' => 'Task not found'], 404);
        return response()->json($task);
    }

    // PUT /api/tasks/{id}
    public function update(Request $request, $id) {
        $task = Task::find($id);
        if (!$task) return response()->json(['error' => 'Task not found'], 404);

        $validated = $request->validate([
            'title' => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
            'status' => 'in:pending,in_progress,completed',
            'priority' => 'in:low,medium,high',
            'due_date' => 'nullable|date'
        ]);

        $task->update($validated);
        return response()->json($task);
    }

    // DELETE /api/tasks/{id}
    public function destroy($id) {
        $task = Task::find($id);
        if (!$task) return response()->json(['error' => 'Task not found'], 404);
        
        $task->delete();
        return response()->json(['message' => 'Task deleted successfully']);
    }

    // POST /api/tasks/{id}/complete (Custom Business Logic Route)
    public function markComplete($id) {
        $task = Task::find($id);
        if (!$task) return response()->json(['error' => 'Task not found'], 404);
        
        $task->update(['status' => 'completed']);
        return response()->json($task);
    }
}