<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductsUnit extends Model
{
    protected $table = 'cms_products_unit';
    public $timestamps = false;
    protected $fillable = ['prd_unit_name'];
    use HasFactory;
}
