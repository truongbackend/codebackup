<?php

namespace App\Http\Controllers\Admin;

use Exception;

use App\Models\User;
use App\Mail\SendUser;
use App\Models\Stores;
use App\Models\Company;
use App\Models\Functions;
use App\Models\UsersGroup;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Validation\ValidationException;
use Spatie\Permission\Models\Role;
use Illuminate\Support\Facades\Auth;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $keyword = $request->input('keyword');
        $usersQuery = User::query();

        if ($keyword) {
            $usersQuery->where(function ($query) use ($keyword) {
                $query->where('username', 'like', "%{$keyword}%")
                    ->orWhere('email', 'like', "%{$keyword}%")
                    ->orWhere('phone', 'like', "%{$keyword}%");
            });
        }

        $users = $usersQuery->get();
        $userRoles = [];
        foreach ($users as $user) {
            $userRoles[$user->id] = $user->getRoleNames()->toArray();
        }
        $users_customer = User::whereIn('group_id', [0, 8])->get();
        $users_admin = User::whereIn('group_id', [16, 13, 10])->get();
        $users_other = User::whereNotIn('group_id', [16, 0, 8, 13, 10])->get();
        $stores = Stores::paginate(50);
        $data = [
            'users' => $users,
            'userRoles' => $userRoles,
            'stores' => $stores,
            'users_customer' => $users_customer,
            'users_admin' => $users_admin,
            'users_other' => $users_other,
        ];

        return response()->json($data);
    }
    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $role = Role::where('status', 0)->paginate(50);
        $user = Auth::user();
        $stores = Stores::query();
        if ($user->company_select) {
            $stores->where('company_id', $user->company_select);
        }
        $stores = $stores->paginate(50);
        $company = Company::all();
        $data = [
            'stores' => $stores,
            'role' => $role,
            'company' => $company,
        ];
        return response()->json($data);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {

        try {
            $validated = $request->validate([
                'email' => 'required|unique:cms_users,email|email',
                'phone' => 'required',
                'role' => 'required',
                'store_id' => 'required',
                'display_name' => 'required',
                'password' => 'required|min:6',
                'company_id'=> 'required',
            ], [
                "email.required" => "Vui lòng nhập email",
                "phone.required" => "Vui lòng nhập số điện thoại",
                "role.required" => "Vui lòng nhập nhóm người dùng",
                "display_name.required" => "Vui lòng nhập tên",
                "store_id.required" => "Vui lòng nhập khu vực",
                "email.unique" => "Tài khoản đã tồn tại",
                "email.email" => "Email không hợp lệ",
                "phone.required" => "Hãy nhập số điện thoại khách hàng",
                "password.required" => "Vui lòng nhập mật khẩu",
                "password.min" => "Mật khẩu phải có ít nhất 6 ký tự",
                "company_id.required" => "Vui lòng nhập công ty",
            ]);
            $validated['password'] = Hash::make($request->input('password'));
            $validated['user_status'] = 1;
            $validated['company_id'] = json_encode($validated['company_id']); 
            $user = User::create($validated);
            $role = Role::where('id', $validated['role'])->first();
            $user->assignRole($role);
            $user_id = 'doan.diepkhanh@bjvietduc.com';
            // $user_id = $user['email'];
            Mail::to($user_id)->send(new SendUser($user));

            return response()->json(['message' => 'Bạn đã đăng ký thành công tài khoản'], 200);
        } catch (ValidationException $e) {
            return response()->json(['errors' => $e->errors()], 422);
        } catch (Exception $e) {
            return response()->json(['error' => 'Lỗi khi lưu đơn hàng ' . $e->getMessage()], 500);
        }
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $users = User::find($id);
        $users_group = UsersGroup::all();
        $stores = Stores::all();
        $functions = Functions::all();
        return response()->json([
            "users" => $users,
            "stores" => $stores,
            "users_group" => $users_group,
            "functions" => $functions
        ]);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $stores = Stores::paginate(50);
        $users_group = UsersGroup::paginate(50);
        $users = User::find($id);
        return response()->json([
            "users" => $users,
            "users_group" => $users_group,
            "stores" => $stores,

        ]);
    }
    public function update(Request $request, $id)
    {
        $users = User::find($id);
        $users->update($request->all());
        return response()->json($request->all());
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
{
    $user = User::find($id);

    if (!$user) {
        return response()->json('Không tìm thấy người dùng', 404);
    }
    $roles = $user->roles;
    $isAdmin = $roles->contains('name', 'Admin');
    if ($isAdmin) {
        return response()->json('Không thể xóa người dùng có vai trò là Admin', 401);
    } else {
        $user->delete();
        return response()->json('Xóa người dùng thành công');
    }
}
public function getUser() {
    $assignedUserIds = User::whereNotNull('user_assigned')->pluck('user_assigned');
    $users = User::whereDoesntHave('roles', function ($query) {
                     $query->where('name', 'Admin');
                 })
                 ->get();
    return response()->json([
        "users" => $users,
    ]);
}
}
