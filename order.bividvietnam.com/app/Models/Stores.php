<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Stores extends Model
{
    protected $table = 'cms_stores';
    public $timestamps = false;
    protected $fillable = ['store_name','user_init','store_manager','status','company_id'];
    use HasFactory;
}
