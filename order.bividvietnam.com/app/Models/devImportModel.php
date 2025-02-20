<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class devImportModel extends Model
{
    public $timestamps = false;
    protected $table = 'dev_import_log';
    protected $fillable = ['date_Customer','date_Customer_Dbl','date_Customer_Dbl','date_Product', 'date_WinningProduct','date_DebtsCustomer','updated_at','created_at'];
    use HasFactory;
}
