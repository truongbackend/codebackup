<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Debts extends Model
{
    protected $table = 'cms_debts';
    public $timestamps = false;
    protected $fillable = ['output_code','customer_id', 'paiddate','paid','unpaid','expdate','order_id','company_id','ten_kh'];
    use HasFactory;
    public function customer()
    {
        return $this->belongsTo(Customer::class, 'customer_id');
    }
}
