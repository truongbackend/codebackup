<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Functions extends Model
{
    protected $table = 'cms_function';
    public $timestamps = true;
    protected $fillable = ['name'];
    use HasFactory;
}
