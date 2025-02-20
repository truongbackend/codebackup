<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Template extends Model
{
    protected $table = 'cms_templates';
    public $timestamps = false;
    protected $fillable = ['content','name'];
    use HasFactory;
}
