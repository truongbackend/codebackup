<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Stores;
use App\Models\Company;
use App\Models\User;
use DB;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;
class RoleController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $companyIds = is_array($user->company_select) ? $user->company_select : [$user->company_select];
        $companyIds = array_map(function($value) {
            return (int)$value;
        }, $companyIds);
        $roles = DB::table('roles')
            ->where(function ($query) use ($companyIds) {
                foreach ($companyIds as $companyId) {
                    $query->orWhere('company_id', 'LIKE', "%$companyId%");
                }
            })
            ->orderBy('created_at', 'desc')
            ->get();
        return response()->json($roles);
    }
    public function companyRole(){
        $company = Company::all();
        $data = [
            'company' => $company,
        ];
        return response()->json($data);
    }
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|unique:roles|string|max:255',
            'permissions' => 'array',
            'company_id' => 'required',
        ], [
            "company_id.required" => "Vui lòng chọn công ty",
            "name.required" => "Hãy nhập tên nhóm quyền",
            "name.unique" => "Nhóm quyền đã tồn tại",
            "prd_name.max" => "Ký tự tối đa là 255",
        ]);
            $request->merge(['company_id' => json_encode($request->company_id)]);
            $role = Role::create($request->all());
        if ($request->has('permissions')) {
            $permissions = Permission::whereIn('name', $request->permissions)->get();
            $role->syncPermissions($permissions);
        }
        return response()->json($role, 201);
    }
    public function show($id)
    {   
        $role = Role::with('permissions')->findOrFail($id);
        $company = Company::all();
        return response()->json([
            'role' => $role,
            'company' => $company
        ]);
    }
    public function update(Request $request, $id)
    {
        $request->validate([
            'company_id' => 'required',
        ],[
            "company_id.required" => "Vui lòng chọn công ty",
        ]);
        $role = Role::find($id);
        if (!$role) {
            return response()->json(['message' => 'Không tìm thấy vai trò'], 404);
        }
        $data = $request->only(['name', 'note', 'status','company_id']);
        $role->update($data);
        $role->syncPermissions($request->get('permissions'));
        if (array_key_exists('company_id', $data)) {
            $this->updateUserCompanyId($role, $data['company_id']);
        }
    
        return response()->json(['message' => 'Cập nhật vai trò thành công'], 200);
    }
    protected function updateUserCompanyId($role, $companyId)
        {
            $users = $role->users;
            foreach ($users as $user) {
                $user->update(['company_id' => $companyId]);
            }
        }
    public function getRolesUser(Request $request, $userID)
    {
        $user = User::find($userID);
        if ($user && (empty($user->company_id) || $user->company_id === 0)) {
            $roles = $user->roles()->get();
            $companyIds = [];
            foreach ($roles as $role) {
                if (isset($role->company_id) && !empty($role->company_id)) {
                    $decodedIds = json_decode($role->company_id, true);
                    $companyIds = array_merge($companyIds, $decodedIds);
                }
            }
            $user->update(['company_id' => $companyIds]);
        }
        $company = Company::all();
        $roles = $user->roles;
        $stores = Stores::paginate(50);
        if (!$user) {
            return response()->json(['error' => 'Người dùng không tồn tại'], 404);
        }
        $rolePermissions = [];
        if ($user->permissions) {
            $userPermissions = json_decode($user->permissions, true);
            $rolePermissions = array_merge($rolePermissions, $userPermissions);
        }
        return response()->json(['permissions' => $rolePermissions ?: [], 'stores' => $stores, 'user' => $user , 'roles' => $roles , 'company' => $company]);
    }
    public function showDataRoles(Request $request, $id){
        $role = Role::find($id);
        $users = User::all();
        $stores = Stores::all();
        $UserRoles = $role->users;
        return response()->json(['UserRoles' => $UserRoles,'stores' => $stores]);
    }
    public function getUserRoles()
    {
        $user =  Auth::user();
        $roles = $user->roles()->get()->pluck('name');
        return response()->json(['roles' => $roles]);
    }
}
