<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class StoreManager extends Model
{
    protected $table = 'cms_store_manager';
    public $timestamps = false;
    protected $fillable = ['name', 'status'];
    use HasFactory;
}
