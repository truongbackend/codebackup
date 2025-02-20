<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductsManufacture extends Model
{
    protected $table = 'cms_products_manufacture';
    public $timestamps = false;
    protected $fillable = ['prd_manuf_name'];

    use HasFactory;
}
