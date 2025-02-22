<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Company extends Model
{
    protected $table = 'cms_company';
    public $timestamps = false;
    protected $fillable = ['name','status'];
    use HasFactory;
}
