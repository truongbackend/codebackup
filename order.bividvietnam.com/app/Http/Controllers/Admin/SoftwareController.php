<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Stores;
use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;

class SoftwareController extends Controller
{
    public function index(Request $request) {
        $keyword = $request->input('keyword');
        $users = User::query()
                 ->where('user_status', 1)
                 ->where('lock_status', 1);
    if ($keyword) {
        $users->where(function ($query) use ($keyword) {
            $query->where('display_name', 'like', "%{$keyword}%")
                  ->orWhere('phone', 'like', "%{$keyword}%")
                  ->orWhere('email', 'like', "%{$keyword}%");
        });
    }
    $users = $users->orderBy('created', 'desc')->paginate(50);
    $stores = Stores::paginate(50);
    $roles = Role::all();
        $data = [
            'users' => $users,
            'stores' => $stores,
            'roles' => $roles,
            'totalPages' => $users->lastPage(),
        ];
        return response()->json($data);
    }
    public function update($id)
    {
        $data['lock_status'] = 0; 
        User::where('id', $id)->update($data);
        return response()->json(['message' => 'User updated successfully']);
    }
}
