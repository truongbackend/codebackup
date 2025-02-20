<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UsersGroup extends Model
{
    protected $table = 'cms_users_group';
    public $timestamps = false;
    protected $fillable = ['group_name'];
    use HasFactory;
}
