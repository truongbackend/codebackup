<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Receipt extends Model
{
    protected $table = 'cms_receipt';
    public $timestamps = false;
    protected $fillable = ['order_id','type_id','type_id','store_id','receipt_date','notes','deleted','user_init','customer_id'];
    use HasFactory;
}
