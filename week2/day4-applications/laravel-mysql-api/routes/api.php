<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\TaskController;

// Deep Health Check Endpoint
Route::get('/health', function () {
    try {
        DB::connection()->getPdo();
        return response()->json([
            'status' => 'healthy',
            'database' => 'connected',
            'framework' => 'Laravel'
        ]);
    } catch (\Exception $e) {
        return response()->json([
            'status' => 'degraded',
            'database' => 'disconnected',
            'error' => $e->getMessage()
        ], 503);
    }
});

// Auto-maps all index, store, show, update, destroy methods!
Route::apiResource('tasks', TaskController::class);

// Custom endpoint to mark a task as complete
Route::post('tasks/{id}/complete', [TaskController::class, 'markComplete']);