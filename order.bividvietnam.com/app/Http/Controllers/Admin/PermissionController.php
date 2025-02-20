<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Stores;
use App\Models\User;
use App\Models\Customer;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;

class PermissionController extends Controller
{
    public function index(Request $request)
    {
        $keyword = $request->input('keyword');
        $users = User::query();
        if ($keyword) {
            $users->where(function ($query) use ($keyword) {
                $query->where('display_name', 'like', "%{$keyword}%")
                    ->orWhere('phone', 'like', "%{$keyword}%")
                    ->orWhere('email', 'like', "%{$keyword}%");
            });
        }
        $user = Auth::user();
        $companyIds = is_array($user->company_select) ? $user->company_select : [$user->company_select];
        $companyIds = array_map(function($value) {
            return (int)$value;
        }, $companyIds);
        $users = $users->where(function ($query) use ($companyIds) {
            foreach ($companyIds as $companyId) {
                $query->orWhere('company_id', 'LIKE', "%$companyId%");
            }
        })->orderBy('created', 'desc')->paginate(50);
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
    public function updatePermissions(Request $request, $userID)
    {
        $user = User::find($userID);
        if (!$user) {
            return response()->json(['error' => 'Người dùng không tồn tại'], 404);
        }
        if (empty($request->company_id)) {
            $roles = $user->roles()->get();
            $companyIds = [];
            foreach ($roles as $role) {
                if (isset($role->company_id) && !empty($role->company_id)) {
                    $decodedIds = json_decode($role->company_id, true);
                    $companyIds = array_merge($companyIds, $decodedIds);
                }
            }
            $uniqueCompanyIds = array_unique($companyIds);
            $formattedCompanyIds = json_decode(json_encode($uniqueCompanyIds), true);
            $request->merge(['company_id' => $formattedCompanyIds]);
        } else {
            $company_id = $request->company_id;
            $request->merge(['company_id' => $company_id]);
        }
        $user->update($request->all());
        $permissions = $request->input('permissions', []);
        $user->syncPermissions($permissions);
        $deniedPermissions = $request->input('denied_permissions', []);
        if (!empty($deniedPermissions)) {
            foreach ($deniedPermissions as $permission) {
                $permissionModel = Permission::where('name', $permission)->first();
                if ($permissionModel) {
                    $user->permissions()->syncWithoutDetaching([$permissionModel->id => ['block' => 1]]);
                }
            }
        }
        $userRoles = $request->input('userRoles', []);
        $user->syncRoles($userRoles);
        return response()->json(['message' => 'Quyền và vai trò đã được cập nhật thành công']);
    }
    public function getUserPermissions()
    {
        $user = Auth::user();
        $permissions = [];
        if ($user->roles) {
            $roles = $user->roles;
            foreach ($roles as $role) {
                $rolePermissions = $role->permissions->pluck('name')->toArray();
                $permissions = array_merge($permissions, $rolePermissions);
            }
        }
        if ($user->permissions) {
            $userPermissions = json_decode($user->permissions, true);
            $userPermissionNames = array_column($userPermissions, 'name');
            $permissions = array_merge($permissions, $userPermissionNames);
        }
        $blockedPermissions = $user->permissions()
            ->wherePivot('block', 1)
            ->pluck('name')
            ->toArray();
        $permissions = array_diff($permissions, $blockedPermissions);
        $allBlockedPermissions = array_merge($rolePermissions, $userPermissionNames, $blockedPermissions);
        $filteredPermissions = array_filter($allBlockedPermissions, function ($permission) use ($blockedPermissions) {
            return !in_array($permission, $blockedPermissions);
        });
        return response()->json(['permissions' => array_unique($filteredPermissions)]);
    }
    public function destroy($id)
    {
        $users = User::find($id);
        if ($users) {
            $users->delete();
            return response()->json('Xóa khách hàng thành công');
        } else {
            return response()->json('Không tìm thấy người dùng', 404);
        }
    }
    public function getPermission(Request $request, $userID)
    {
        $user = User::find($userID);
        $roles = Role::where('status', 0)->get();
        $permissions = $user->permissions()->withPivot('block')->get();
        return response()->json(['roles' => $roles, 'permissions' => $permissions]);
    }
    public function permissionData(Request $request, $id)
    {
        $users = User::find($id);
        $stores = Stores::all();
        $usersAssigned = User::where('user_assigned', 'LIKE', "%$id%")->get();
        return response()->json(['users' => $users , 'usersAssigned' => $usersAssigned, 'stores' => $stores]);
    }
    public function permissionDataUser(Request $request, $id)
    {
        $userId = $request->input('selectedUser');
        $selectedUser = User::find($userId);
        $user = User::find($id);
        if ($selectedUser && $user) {
            $userAssigned = $selectedUser->user_assigned ?? [];
            if ($selectedUser && $user) {
                $userAssigned = json_decode($selectedUser->user_assigned, true) ?? [];
                if (!in_array($user->id, $userAssigned)) {
                    $userAssigned[] = $user->id;
                    $selectedUser->user_assigned = json_encode($userAssigned);
                    $selectedUser->save();
                    
                    return response()->json(['message' => 'Thêm người dùng thành công']);
                } else {
                    return response()->json(['error' => 'Người dùng đã tồn tại trong danh sách']);
                }
            } else {
                return response()->json(['error' => 'Người dùng đã tồn tại trong danh sách']);
            }
        } else {
            return response()->json(['error' => 'Người dùng hoặc người dùng được chọn không tồn tại'], 404);
        }
    }
    public function permissionDataDelete(Request $request, $id){
        $idUserDelete = $request->input('idUserDelete');

        $user = User::find($id);
        if ($user) {
            $assignedIds = json_decode($user->user_assigned);
            if ($assignedIds) {
                $assignedIds = array_filter($assignedIds, function($value) use ($idUserDelete) {
                    return $value != $idUserDelete;
                });
                $user->user_assigned = json_encode(array_values($assignedIds));
            } else {
                $user->user_assigned = null; 
            }
            
            $user->save();
            
            return response()->json(['message' => 'User assigned relationship removed successfully']);
        } else {
            return response()->json(['error' => 'User not found'], 404);
        }
    }
    public function getUsersAssignedToUser($id, &$assignedUsers = []) {
        $users = User::where('user_assigned', $id)->get();
        foreach ($users as $user) {
            $assignedUsers[] = $user;
            $this->getUsersAssignedToUser($user->id, $assignedUsers);
        }
        $assignedUserIds = array_column($assignedUsers, 'id');
        $orders = Order::whereIn('user_init', $assignedUserIds)->get();
        return response()->json(['assigned_users' => $assignedUsers, 'orders' => $orders]);
    }
    public function getCustomerToUser(){
        $customer = Customer::all();
        return response()->json(['customer' => $customer]);
    }
    public function getCustomerToUserID (Request $request, $id){
        $customerAssigned = Customer::where('user_assigned', $id)->get();
        return response()->json(['customerAssigned' => $customerAssigned]);
    }
    public function resetCompany(Request $request, $id)
    {
        try {
            $user = User::find($id);
            if (!$user) {
                return response()->json(['message' => 'Người dùng không tồn tại'], 404);
            }
            $user->update(['company_id' => null]);
            return response()->json(['message' => 'Cập nhật company_id thành công'], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
}
