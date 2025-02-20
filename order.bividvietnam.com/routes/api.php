<?php

use App\Models\UsersGroup;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\SopController;
use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\Admin\RoleController;
use App\Http\Controllers\Admin\UserController;
use App\Http\Controllers\Admin\ChartController;
use App\Http\Controllers\Admin\DebtsController;
use App\Http\Controllers\Admin\OrderController;
use App\Http\Controllers\Admin\RolesController;
use App\Http\Controllers\Admin\StatusController;
use App\Http\Controllers\Admin\StoresController;
use App\Http\Controllers\Admin\ManagerController;
use App\Http\Controllers\Admin\ProductController;
use App\Http\Controllers\Admin\SettingController;
use App\Http\Controllers\Admin\SummaryController;
use App\Http\Controllers\Admin\CategoryController;
use App\Http\Controllers\Admin\CustomerController;
use App\Http\Controllers\Admin\TemplateController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\UserGroupController;
use App\Http\Controllers\Admin\AssignUserController;
use App\Http\Controllers\Admin\PermissionController;
use App\Http\Controllers\Admin\TemplateEmailController;
use App\Http\Controllers\Admin\PermissionDataController;
use App\Http\Controllers\Admin\ImportController;


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
Route::middleware(['checkPermission'])->group(function () {
    Route::resource('sop', SopController::class);
    Route::post('sop/getlist', [SopController::class, 'getList']);
    Route::resource('users', UserController::class);
    Route::resource('setting', SettingController::class);
    Route::resource('products', ProductController::class);
    Route::resource('stores', StoresController::class);
    Route::resource('groupusers', UserGroupController::class);
    Route::resource('order', OrderController::class);
    Route::resource('customers', CustomerController::class);
    Route::resource('debts', DebtsController::class);
    Route::resource('category', CategoryController::class);
    Route::resource('status', StatusController::class);
    Route::resource('summary', SummaryController::class);
    Route::resource('chart', ChartController::class);
    Route::resource('dashboard', DashboardController::class);
    Route::resource('template', TemplateController::class);
    Route::resource('template-email', TemplateEmailController::class);
    Route::resource('status', StatusController::class);
    Route::get('roles/{id}', [RoleController::class, 'show']);
    Route::put('roles/{id}', [RoleController::class, 'update']);
    Route::get('roles/{id}/data', [RoleController::class, 'showDataRoles']);
    Route::put('roles/{id}/data', [RoleController::class, 'updateDataRoles']);
    Route::get('roles', [RoleController::class, 'index']);
    Route::post('roles', [RoleController::class, 'store']);
    Route::get('companyRole',[RoleController::class, 'companyRole']);
    Route::get('permissions', [PermissionController::class, 'index']);
    Route::put('permissions/{id}', [PermissionController::class, 'destroy']);
    Route::get('manager', [ManagerController::class, 'index']);
    Route::get('getUserStore', [PermissionDataController::class, 'getUserStore']);
    Route::get('getUser',[UserController::class,'getUser']);
    Route::get('permissionData/{id}/show',[PermissionController::class,'permissionData']);
    Route::post('permissionData/{id}/show',[PermissionController::class,'permissionDataUser']);
    Route::put('permissionData/{id}',[PermissionController::class,'permissionDataDelete']);
    Route::get('user/permission', [PermissionController::class, 'getUserPermissions']);
    Route::get('user/{id}/permission', [PermissionController::class, 'getPermission']);
    Route::get('getUsersAssignedToUser/{id}',[PermissionController::class,'getUsersAssignedToUser']);
    Route::get('getCustomerToUser',[PermissionController::class,'getCustomerToUser']);
    Route::get('getCustomerToUser/{id}',[PermissionController::class,'getCustomerToUserID']);
    Route::put('postCustomerToUser/{id}',[CustomerController::class,'postCustomerToUser']);
    Route::put('putCustomerToUser/{id}',[CustomerController::class,'putCustomerToUser']);
    Route::get('checkPermissionUser',[AuthController::class, 'checkPermissionUser']);
    Route::get('user/{id}/roles', [RoleController::class, 'getRolesUser']);
    Route::get('permission/data', [PermissionDataController::class, 'index']);
    Route::post('permission/data/create', [PermissionDataController::class, 'store']);
    Route::put('user/{id}/permissions', [PermissionController::class, 'updatePermissions']);
    Route::get('user/roles', [RoleController::class, 'getUserRoles']);
    Route::put('getCompany/{id}', [PermissionController::class, 'resetCompany']);
    Route::post('customersFilter', [ImportController::class, 'customersFilter']);
    Route::post('customersImport', [ImportController::class, 'customersImport']);
    Route::post('productsFilter', [ImportController::class, 'productsFilter']);
    Route::post('productImport', [ImportController::class, 'productImport']);
    Route::post('productWinningImport', [ImportController::class, 'productWinningImport']);
    Route::post('productWinningFilter', [ImportController::class, 'productWinningFilter']);
    Route::post('importProductWinning', [ImportController::class, 'importProductWinning']);
    Route::post('debtsUser', [ImportController::class, 'debtsUser']);
    Route::post('debtCustomerfilter', [ImportController::class, 'debtCustomerfilter']);
    Route::post('debtCustomer', [ImportController::class, 'debtCustomer']);
    Route::post('importDebtCustomer', [ImportController::class, 'importDebtCustomer']);
    Route::post('productImportWinning', [ImportController::class, 'productImportWinning']);
});
    Route::get('get', [UserGroupController::class, 'get']);
    Route::post('login', [AuthController::class, 'login']);
    Route::post('forgot-password', [AuthController::class, 'forgotPassword']);
    Route::post('logout', [AuthController::class, 'logout']);
    Route::get('profile', [AuthController::class, 'userProfile']);
    Route::get('company', [AuthController::class, 'getCompany']);
    Route::put('companySelect', [AuthController::class, 'putCompany']);
    Route::post('update-password', [AuthController::class, 'updatePassword']);
    Route::get('profileCompany', [AuthController::class, 'profileCompany']);
