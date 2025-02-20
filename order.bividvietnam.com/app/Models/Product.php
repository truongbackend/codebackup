<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $table = 'cms_products';
    public $timestamps = false;
    protected $fillable = ['prd_code','prd_name', 'prd_active','prd_content','prd_sls','prd_sell_price','prd_pack','prd_status','prd_manufacture_id','prd_image_url','prd_descriptions','prd_unit_id','company_id','created'];
    use HasFactory;
}
