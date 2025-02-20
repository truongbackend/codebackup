<?php

namespace App\Http\Controllers\Admin;

use App\Models\Order;
use App\Models\Status;
use App\Models\Stores;
use App\Models\OrderPx;
use App\Models\Customer;
use App\Models\UsersGroup;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Support\Facades\Date;

class SummaryController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $storesId = $request->input('store_id');
        $customerId = $request->input('customer_id');
        $usersId = $request->input('user_init');
        $orderPx = OrderPx::query();
        if ($customerId) {
            $orderPx->where('customer_id', $customerId);
        }
        if ($storesId) {
            $orderPx->where('store_id', $storesId);
        }
        if ($usersId) {
            $orderPx->where('user_init', $usersId);
        }
        $orderPx = $orderPx->paginate(50);
        $stores = Stores::all();
        $status = Status::all();
        $customers = Customer::all();
        $users = User::all();

        $data = [
            'orderPx' => $orderPx,
            'status' => $status,
            'stores' => $stores,
            'customer' => $customers,
            'users' => $users,
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
