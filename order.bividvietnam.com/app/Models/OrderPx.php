<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OrderPx extends Model
{
    protected $table = 'cms_orders_px';
    public $timestamps = true;
    protected $fillable = ['output_code','total_price','created','notes'];
    use HasFactory;
}
