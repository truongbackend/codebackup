<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order_px_Detail extends Model
{
    protected $table = 'cms_order_px_detail';
    public $timestamps = false;
    protected $fillable = ['quantity','price', 'bid_id','order_px_id','id_product','product_code','product_name'];
    use HasFactory;
}
