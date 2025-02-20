<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Customers_Bids_Products extends Model
{
    protected $table = 'cms_customers_bids_products';
    const UPDATED_AT = 'updated';
    const CREATED_AT = 'created';
    public $timestamps = false;
    protected $fillable = ['bid_id','customer_id','product_id','prd_code','prd_sell_price','customer_name', 'quantity','remain','deleted','expiration_date','customer_code'];
    use HasFactory;
}
