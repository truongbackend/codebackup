<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ImportCustomer extends Model
{
    protected $table = 'import_customer';
    protected $primaryKey = 'id';
    public $timestamps = false;
    protected $fillable = ['customer_code','customer_name', 'customer_email','customer_phone','customer_addr','customer_ship_addr','notes','created','company_id','user_init','store_id','created_db'];
    use HasFactory;
}
