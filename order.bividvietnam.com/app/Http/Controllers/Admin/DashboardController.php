<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Order;
use App\Models\Product;
use App\Models\ProductsManufacture;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;
class DashboardController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
{
    $user = Auth::user();
    $roles= $user->getRoleNames();
    $companySelect = $user->company_select;
    $today = Carbon::now()->toDateString();
    $userId = $user->id;
    $totalMoneyToday = Order::where('order_status', '<>', 5)
        ->where('deleted', 0)
        ->where('user_init', $userId)
        ->whereDate('created', $today)
        ->where('company_id', $companySelect)
        ->sum('total_price');

    $totalOrderToday = Order::where('deleted', 0)
        ->where('user_init', $userId)
        ->whereDate('created', now())
        ->where('company_id', $companySelect)
        ->count('ID');

    $totalCancelToday = Order::where('order_status', 5)
        ->where('user_init', $userId)
        ->whereDate('created', now())
        ->where('company_id', $companySelect)
        ->count();

    $totalCustomerToday = Order::where('order_status', '<>', 5)
        ->where('user_init', $userId)
        ->whereDate('created', now())
        ->where('company_id', $companySelect)
        ->count('customer_id');

    $totalMoneySum = Order::where('order_status', '<>', 5)
        ->where('user_init', $userId)
        ->where('deleted', 0)
        ->where('company_id', $companySelect)
        ->sum('total_money');

    $totalQuantity = Order::where('order_status', '<>', 5)
        ->where('user_init', $userId)
        ->where('deleted', 0)
        ->where('company_id', $companySelect)
        ->sum('total_quantity');

    $numberCategories = ProductsManufacture::distinct('prd_manuf_name')
        ->where('company_id', $companySelect)
        ->count();

    $inventoryProduct = Product::where(['prd_status' => 1, 'deleted' => 0, 'prd_sls' => 0])
        ->where('user_init', $userId)
        ->where('company_id', $companySelect)
        ->count('ID');

    $outStockProduct = Product::where(['prd_status' => 1, 'deleted' => 0, 'prd_sls' => 0])
        ->where('user_init', $userId)
        ->where('company_id', $companySelect)
        ->count('ID');

    $numberProducts = Product::distinct('prd_name')
        ->where('prd_status', 1)
        ->where('user_init', $userId)
        ->where('deleted', 0)
        ->where('company_id', $companySelect)
        ->count();

    $nullPrice = Product::whereNull('prd_sell_price')
        ->where('user_init', $userId)
        ->where('company_id', $companySelect)
        ->count();

    $nullPriceOrigin = Product::whereNull('prd_origin_price')
        ->where('user_init', $userId)
        ->where('company_id', $companySelect)
        ->count();

    $totalOrder = Order::where('deleted', 0)
        ->where('user_init', $userId)
        ->where('company_id', $companySelect)
        ->whereOr('order_status', '<>', 5)
        ->count('ID');

    $data = [
        'roles' => $roles,
        'user' => $user,
        'total_money_sum' => $totalMoneySum,
        'totalQuantity' => $totalQuantity,
        'numberCategories' => $numberCategories,
        'numberProducts' => $numberProducts,
        'nullPrice' => $nullPrice,
        'totalMoneyToday' => $totalMoneyToday,
        'totalOrderToday' => $totalOrderToday,
        'totalCancelToday' => $totalCancelToday,
        'totalCustomerToday' => $totalCustomerToday,
        'inventoryProduct' => $inventoryProduct,
        'totalOrder' => $totalOrder,
        'outStockProduct' => $outStockProduct,
        'nullPriceOrigin' => $nullPriceOrigin,
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
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
