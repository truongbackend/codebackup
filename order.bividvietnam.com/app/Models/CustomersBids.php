<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CustomersBids extends Model
{
    protected $table = 'cms_customers_bids';
    public $timestamps = false;
    protected $fillable = ['output_code','customer_id', 'begin_date','expiration_date','total_quantity','total_price'];
    use HasFactory;
}
