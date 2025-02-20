<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ImportWinningProduct extends Model
{
    protected $table = 'import_product_customer';
    public $timestamps = false;
    protected $fillable = ['customer_id','product_id','prd_code','user_init','prd_sell_price','quantity','company_id','expiration_date','created','ten_kh'];
    use HasFactory;
}
