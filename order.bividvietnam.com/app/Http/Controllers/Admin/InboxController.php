<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\inBox;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class InboxController extends Controller
{
    public function index(){
        $user = Auth::user()->id;
        $inbox = inBox::where("user_id", $user)->get();
        return response()->json([
            "inbox" => $inbox]);
    }
    public function show($id){
        $inBox = inBox::find($id);
        $data = [
            'inBox' => $inBox,
        ];
        return response()->json($data);
    }
    public function store(Request $request)
    {
        $name = 'Báo cáo hàng cận Date';
        $nameUser =  $request->input('ma_sale');
        $currentDate = date('Y/m/d');
        $user = User::where('username', $nameUser)->first();
        $inboxEntry = inBox::create([
            'name' => $name,
            'date' => $currentDate,
            'templates' => $request->input('content'),
            'user_id' => $user->id, 
        ]);
    
        return response()->json([
            'message' => 'Status created successfully',
            'data' => $inboxEntry
        ], 201);
    }
    
}
