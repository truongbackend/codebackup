<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Customer;
use App\Models\Debts;
use App\Models\Debts_Detail;
use App\Models\DebtsDetail;
use App\Models\OrderPx;
use App\Models\Product;
use App\Models\ProductsUnit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;

class DebtsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $perPage = $request->input('per_page', 50);
        $keyword = $request->input('keyword');
        $customerId = $request->input('customer_id');
        $selectStatusOrder = $request->input('selected_status');
        $debts = Debts::query()->with('Customer');
        if ($keyword) {
            $debts->where(function ($query) use ($keyword) {
                $query->where('output_code', 'like', "%{$keyword}%")
                      ->orWhere('paiddate', 'like', "%{$keyword}%")
                      ->orWhereHas('Customer', function ($subquery) use ($keyword) {
                          $subquery->where('customer_name', 'like', "%{$keyword}%");
                      });
            });
        }
        if ($customerId) {
            $debts->where('customer_id', $customerId);
        }
        $user = Auth::user();
        if ($user->company_select) {
            $debts->where('company_id', $user->company_select);
        }
        if ($selectStatusOrder !== null) {
            if ($selectStatusOrder === '0') {
                $debts->where('paid', 0);
            } elseif ($selectStatusOrder === '1') {
                $debts->where('paid', '>', 0);
            }
        }
        $user = Auth::user();
        if ($user->hasRole('Admin')) {
            $debts = $debts->orderBy('expdate', 'asc');
        }else{
            $assignedUsers = [];
            $this->getUsersAssignedToUser($user->id, $assignedUsers);
            $assignedUserIds = array_unique(array_merge([$user->id], array_column($assignedUsers, 'id')));
            
            $customers = Customer::whereIn('user_assigned', $assignedUserIds)->pluck('id');
            $debts->whereIn('customer_id', $customers)->orderBy('expdate', 'asc');
        }
        $debts = $debts->paginate($perPage);
        $customer = Customer::all();
        $data = [
            'debts' => $debts,
            'customer' => $customer,
        ];
        return response()->json($data);
    }
    public function getUsersAssignedToUser($id, &$assignedUsers = [])
{
    $users = User::where('user_assigned', 'LIKE', "%$id%")->get();
    foreach ($users as $user) {
        $assignedUsers[] = $user;
        $this->getUsersAssignedToUser($user->id, $assignedUsers);
    }
    return $assignedUsers;
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
        $debts = Debts::find($id);
        $customer = Customer::all();
        $orderPx = OrderPx::all();
        $orderID = $debts->order_id;
        $debtsDetail = DebtsDetail::where("order_id", $orderID)->get();
        $product = Product::all();
        $product_unt = ProductsUnit::all();
        return response()->json([
            "debts" => $debts,
            "customer" => $customer,
            "orderPx" => $orderPx,
            "product" => $product,
            "debtsDetail" => $debtsDetail,
            "product_unt" => $product_unt,
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
