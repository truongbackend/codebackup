<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\User;
use App\Models\Stores;
class Order extends Model
{
    const UPDATED_AT = 'updated';
    const CREATED_AT = 'created';
    protected $table = 'cms_orders';
    public $timestamps = false;
    protected $fillable = ['output_code','customer_id', 'store_id','order_status','created','discount_item','customer_pay'];
    use HasFactory;
    public function customer()
    {
        return $this->belongsTo(Customer::class, 'customer_id');
    }
    public function user()
    {
        return $this->belongsTo(User::class, 'user_init');
    }
    public function stores()
    {
        return $this->belongsTo(Stores::class, 'store_id');
    }
}
