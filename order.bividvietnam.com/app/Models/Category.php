<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    protected $table = 'cms_products_group';
    public $timestamps = false;
    protected $fillable = ['prd_group_name','parentid', 'level','created','company_id'];
    use HasFactory;
}
