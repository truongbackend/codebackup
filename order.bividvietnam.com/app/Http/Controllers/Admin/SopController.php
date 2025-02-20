<?php

namespace App\Http\Controllers\Admin;

use Exception;
use App\Models\Order;
use App\Models\Product;
use App\Models\Customer;
use App\Models\OrderDetail;
use App\Models\ProductsUnit;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Customers_Bids_Products;
use App\Models\CustomersBids;
use App\Models\Receipt;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Mail;
use App\Mail\OrderShipped;
use App\Models\User;

class SopController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $keyword = $request->input('keyword');
        $products = Product::query();
        if ($keyword) {
            $products->where(function ($query) use ($keyword) {
                $query->where('prd_name', 'like', "%{$keyword}%")
                    ->orWhere('prd_code', 'like', "%{$keyword}%")
                    ->orWhere('prd_active', 'like', "%{$keyword}%");
            });
        }
        $today = date('Y-m-d');
        $user = Auth::user();
        $customers = [];
        if ($user->roles()->where('name', 'Admin')->exists()) {
            $customers = Customer::where('company_id', $user->company_select)->get();
        } else {
            $assignedUsers = [];
            $this->getUsersAssignedToUser($user->id, $assignedUsers);
            $assignedUserIds = array_unique(array_merge([$user->id], array_column($assignedUsers, 'id')));
            $customers = Customer::where('company_id', $user->company_select)
                ->whereIn('user_assigned', $assignedUserIds)
                ->get();
        }
        $productsList = $products->where('prd_status', '1')->where('deleted', '0')->where('company_id', $user->company_select)->get();
        $customer_bids = CustomersBids::all();
        $product_unit = ProductsUnit::all();
        $data = [
            'customer' => $customers,
            'products' => $productsList,
            'product_unit' => $product_unit,
            'customer_bids' => $customer_bids,
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
    public function getList(Request $request)
    {
        $keyword = $request->input('keyword');
        $today = date('Y-m-d');
        $customer_id = $request->input('customer_id');
        $customer_bids_products = Customers_Bids_Products::where('deleted', '0')
            ->where('customer_id', $customer_id)
            ->where('quantity', '>', 0)
            ->where('expiration_date', '>=', $today);
        if ($keyword) {
            $customer_bids_products->where('prd_code', 'LIKE', "%$keyword%");
        }
        $customer_bids_products = $customer_bids_products->get();
        $data = [
            'customer_bids_products' => $customer_bids_products,
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
            $requestData = $request->all();
            $order = new Order();
            $year = date("y");
            $date = date("mdHis");
            $user = Auth::user();
            $order->company_id = $user->company_select;
            $order->user_init = $user->id;
            $order->store_id = $user->store_id;
            $order->output_code = 'DH' . $year . $date;
            $order->customer_id = $requestData['customer_id'];
            $order->notes = $requestData['notes'];
            $order->total_quantity = $requestData['total_quantity'];
            $order->total_price = $requestData['total_price'];
            $order->total_money = $requestData['total_price'];
            $order->save();
            foreach ($requestData['selected_products'] as $item) {
                $orderDetail = new OrderDetail();
                $orderDetail->order_id = $order->id;
                $orderDetail->product_id = $item['product_id'];
                $orderDetail->quantity = $item['quantity'];
                $orderDetail->product_name = $item['name'];
                $orderDetail->product_code = $item['maProduct'];
                $orderDetail->price = $item['price'];
                // $orderDetail->bid_id = $item['product_unit'];
                $orderDetail->save();
                //$product_unit = ProductsUnit::find($orderDetail->bid_id)->prd_unit_name;
            }
            $dateReceipt = gmdate("Y:m:d H:i:s", time() + 7 * 3600);
            $OrderReceipt = new Receipt();
            $OrderReceipt->order_id = $order->id;
            $OrderReceipt->receipt_date = $dateReceipt;
            $OrderReceipt->notes = $requestData['notes'];
            $OrderReceipt->user_init = $user->id;
            $OrderReceipt->customer_id = $requestData['customer_id'];
            $OrderReceipt->store_id = $user->store_id;
            $OrderReceipt->save();
            $customer_id = $requestData['customer_id'];
            $user_id = $user->id;
            $customer = Customer::find($customer_id);
            $products = $requestData['selected_products'];
            $userOrder = User::find($user_id);
            if ($customer) {
                $customer_email = 'doan.diepkhanh@bjvietduc.com';
                // $customer_email = $customer['customer_email'];
                $order->customer_email = $customer_email;
                Mail::to($customer_email)->send(new OrderShipped($order, $customer, $products, $userOrder, $orderDetail));
            } else {
                return response()->json(['error' => 'Không tìm thấy thông tin khách hàng'], 404);
            }
            return response()->json(['message' => 'Đã lưu đơn hàng thành công'], 200);
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
