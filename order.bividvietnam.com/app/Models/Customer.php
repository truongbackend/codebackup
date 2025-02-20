<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Customer extends Model
{
    const UPDATED_AT = 'updated';
    const CREATED_AT = 'created';
    protected $primaryKey = 'ID';
    protected $table = 'cms_customers';
    public $timestamps = false;
    protected $fillable = ['cms_customers','user_init','customer_image','user_upd','customer_code','customer_name', 'customer_phone','customer_addr','customer_ship_addr','customer_email','user_assigned','company_id'];
    use HasFactory;
}
