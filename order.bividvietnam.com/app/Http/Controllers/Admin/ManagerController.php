<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\StoreManager;
use Illuminate\Http\Request;

class ManagerController extends Controller
{

    public function index()
    {
        $store_manager = StoreManager::all();
        return response()->json(['store_manager' => $store_manager]);
    }
}
