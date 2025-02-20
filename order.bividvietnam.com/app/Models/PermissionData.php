<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PermissionData extends Model
{
    protected $table = 'grouppermissionsbydata';
    public $timestamps = false;
    protected $fillable = ['role_id', 'store_id', 'created','updated','Upcreated','Updatedate'];
    use HasFactory;
}
