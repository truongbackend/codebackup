<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\PermissionData;
use App\Models\Stores;
use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;

class PermissionDataController extends Controller
{
    public function index()
    {
        $roles = Role::all();
        $stores = Stores::all();
        $permissionData = PermissionData::all();
        return response()->json([
            'roles' => $roles,
            'stores' => $stores,
            'permissionData' => $permissionData
        ]);
    }
    public function store(Request $request)
    {
        $validated = $request->validate([
            'role_id' => 'required',
            'store_id' => 'required',
        ], [
            "role_id.required" => "Hãy chọn nhóm quyền",
            "store_id.required" => "Hãy chọn khu vực"
        ]);
        PermissionData::create($request->all());
        return response()->json(['message' => 'Store created successfully']);
    }
    public function getUserStore(Request $request){
        $keyword = $request->input('keyword');
        $users = User::query();
        if ($keyword) {
            $users->where(function($query) use ($keyword) {
                $query->where('display_name', 'like', "%{$keyword}%")
                    ->orWhere('phone', 'like', "%{$keyword}%")
                    ->orWhere('email', 'like', "%{$keyword}%");
            });
        }

        $users = $users->paginate(50);
        $userRoles = [];
        foreach ($users as $user) {
            $userRoles[$user->id] = $user->getRoleNames()->toArray();
        }
        $stores = Stores::all();
        $permissions = Permission::all();
        $roles = Role::all();

        return response()->json([
            'roles' => $roles,
            'permissions' => $permissions,
            'users' => $users,
            'stores' => $stores,
            'userRoles' => $userRoles,
            'totalPages' => $users->lastPage(),
        ]);
    }
}
