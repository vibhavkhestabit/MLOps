<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Task extends Model
{
    use HasFactory;

    // This protects against "Mass Assignment" vulnerabilities
    protected $fillable = [
        'title', 
        'description', 
        'status', 
        'priority', 
        'due_date'
    ];
}