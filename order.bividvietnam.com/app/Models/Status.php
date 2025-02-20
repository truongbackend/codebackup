<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Status extends Model
{
    protected $table = 'cms_status';
    public $timestamps = false;
    protected $fillable = ['name'];
    use HasFactory;
}
