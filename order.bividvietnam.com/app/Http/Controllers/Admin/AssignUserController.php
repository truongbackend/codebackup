<?php

namespace App\Http\Controllers\Admin;

use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use App\Http\Controllers\Controller;

class AssignUserController extends Controller
{
    public function assignRolesAndPermissions(Request $request, $userId)
    {
        $user = User::findOrFail($userId);
        $user->syncRoles([$request->role]);
        $user->syncPermissions([$request->permission]);
        return response()->json(['message' => 'Roles and permissions assigned successfully']);
    }
    public function getRolePermissions($roleId)
    {
        $role = Role::find($roleId);
        if (!$role) {
            return response()->json(['error' => 'Role not found'], 404);
        }
        $permissions = $role->permissions;
        return response()->json($permissions);
    }
}
