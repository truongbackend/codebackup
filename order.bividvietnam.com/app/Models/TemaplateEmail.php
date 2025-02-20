<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TemaplateEmail extends Model
{
    protected $table = 'cms_emails';
    public $timestamps = false;
    protected $fillable = ['content','name','to_email','cc_email','bcc_email'];
    use HasFactory;
}
