<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Mail\ResetPassword;
use App\Models\User;
use App\Models\Company;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class AuthController extends Controller
{

    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required'],
        ], [
            'email.required' => 'Vui lòng nhập email',
            'email.email' => 'Hãy nhập đúng định dạng email',
            'password.required' => 'Hãy nhập mật khẩu',
        ]);

        $credentials = $request->only('email', 'password');
        if (!$token = auth()->attempt($credentials)) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }
        $user = auth()->user();
        if ($user->lock_status !== 0) {
            return response()->json(['error' => 'Tài khoản bị khóa'], 401);
        }
        return $this->respondWithToken($token);
    }

    public function forgotPassword(Request $request)
    {
        $request->validate([
            'email' => ['required', 'email'],
        ]);
        $user = User::where('email', $request->email)->first();
        if (!$user) {
            return response()->json(['message' => 'Email không tồn tại trong hệ thống'], 404);
        }
        $token = Str::random(60);
        $password = Hash::make('test123456');
        $user->update([
            'reset_password_token' => $token,
            'password' => $password,
        ]);
        Mail::to($user->email)->send(new ResetPassword($token));
        return response()->json(['message' => 'Email đã được gửi tới email của bạn']);
    }
    protected function respondWithToken($token)
    {
        return response()->json([
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => Auth::factory()->getTTL() * 60,
            'user' => auth()->user(),
        ]);
    }
    public function userProfile()
    {
        $user = Auth::user();
        if ($user) {
            $user->logined = Carbon::now();
            if ($user->company_select === null) {
                $companyIds = json_decode($user->company_id, true);
                $user->company_select = $companyIds[0];
            }
            $user->save();
        }
        return response()->json(Auth::user());
    }
    public function updatePassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'current_password' => 'required',
            'new_password' => 'required|min:6|different:current_password',
            'confirm_password' => 'required|same:new_password'
        ], [
            'current_password.required' => 'Vui lòng nhập mật khẩu',
            'new_password.required' => 'Vui lòng nhập mật khẩu mới',
            'new_password.min' => 'Vui lòng nhập mật khẩu mới dài hơn 6 kí tự',
            'confirm_password.required' => 'Hãy nhập mật khẩu xác nhận',
            'confirm_password.same' => 'Mật khẩu mới và mật khẩu xác nhận không giống',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
        $user = Auth::user();
        if (!Hash::check($request->input('current_password'), $user->password)) {
            return response()->json(['message' => 'Mật khẩu hiện tại không đúng'], 400);
        }
        $user->password = Hash::make($request->input('new_password'));
        $user->save();

        return response()->json(['message' => 'Mật khẩu đã được cập nhật thành công']);
    }
    public function logout()
    {
        auth()->logout();

        return response()->json(['message' => 'Successfully logged out']);
    }
    public function getCompany(){
        $user = Auth::user();
        if ($user) {
            $companyIds = json_decode($user->company_id, true);
            $company = Company::whereIn('id', $companyIds)->get();
            return response()->json(['company' => $company]);
        } else {
            return response()->json(['message' => 'Không tìm thấy người dùng đã xác thực'], 404);
        }
    }

    public function putCompany(Request $request){
        $user = Auth::user();
        if ($user) {
            $companySelect = $request->input('company_select');
            if (empty($companySelect)) {
                $companyIds = json_decode($user->company_id, true);
                $companySelect = $companyIds[0];
            }
            $user->company_select = $companySelect;
            $user->save();
            return response()->json(['message' => 'Cập nhật company_id thành công'], 200);
        } else {
            return response()->json(['message' => 'Không tìm thấy người dùng'], 404);
        }
    }
    public function profileCompany()
    {
        $company = Company::all();
        return response()->json(['company' => $company]);
    }

}
