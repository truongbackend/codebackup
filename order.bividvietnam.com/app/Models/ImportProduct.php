<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ImportProduct extends Model
{
    protected $table = 'import_product';
    public $timestamps = false;
    protected $fillable = ['prd_code','prd_name', 'prd_active','user_id','prd_content','prd_sls','prd_sell_price','store_id','prd_pack','prd_manufacture_id','prd_image_url','prd_descriptions','prd_unit_id','company_id','created'];
    use HasFactory;
}
