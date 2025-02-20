<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ImportCustomerDebt extends Model
{
    protected $table = 'import_debts_customer';
    public $timestamps = false;
    protected $fillable = ['output_code','customer_id','ten_kh','user_init','order_id','company_id'];
    use HasFactory;
}
