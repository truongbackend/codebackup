<?php

namespace App\Http\Controllers\Admin;

use App\Models\Order;
use App\Models\UsersGroup;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Customer;
use App\Models\OrderDetail;
use App\Models\ProductsUnit;
use App\Models\Status;
use App\Models\Stores;
use App\Models\Template;
use App\Models\User;
use Illuminate\Support\Facades\Mail;
use App\Mail\DeleteOrder;
use App\Mail\StatusOrder;
use Illuminate\Support\Facades\Auth;

class OrderController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */

    public function index(Request $request)
    {
        $keyword = $request->input('keyword');
        $user = Auth::user();
        
        $ordersQuery = Order::orderBy('created', 'desc');
        if ($user->company_select) {
            $ordersQuery->where('company_id', $user->company_select);
        }
        if ($keyword) {
            $ordersQuery->where('output_code', 'like', "%{$keyword}%");
        }
        if ($user->roles()->where('name', 'Admin')->exists()) {
            $orders = $ordersQuery->paginate(50);
        } else {
            $assignedUsers = [];
            $this->getUsersAssignedToUser($user->id, $assignedUsers);
            $assignedUserIds = array_unique(array_merge([$user->id], array_column($assignedUsers, 'id')));
            $orders = $ordersQuery->whereIn('user_init', $assignedUserIds)->paginate(50);
        }
        $customer = Customer::all();
        $users = User::all();
        $stores = Stores::all();
        $status = Status::all();
        $template = Template::find(1);
        $data = [
            'order' => $orders,
            'customer' => $customer,
            'stores' => $stores,
            'users' => $users,
            'status' => $status,
            'template' => $template,
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
    public function create()
    {
    }

    public function store(Request $request)
    {
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $order = Order::find($id);
        $customer = Customer::all();
        $customer_id = $order->customer_id;
        $customerOrder = Customer::find($customer_id);
        $user_id = $order->user_init;
        $userOrder = User::find($user_id);
        $status = Status::whereNotIn('id', [6, 8, 7])->get();
        $order_detail = OrderDetail::where("order_id", $id)->get();
        $template = Template::find(1);
        return response()->json([
            "order" => $order,
            "customer" => $customer,
            "order_detail" => $order_detail,
            'status' => $status,
            'template' => $template,
            'customerOrder' => $customerOrder,
            'userOrder' => $userOrder,
        ]);
    }
    public function edit($id)
    {
        $order = Order::find($id);
        $customer = Customer::all();
        $product_unt = ProductsUnit::all();
        $order_detail = OrderDetail::where("order_id", $id)->get();
        return response()->json([
            "order" => $order,
            "customer" => $customer,
            "order_detail" => $order_detail,
            "product_unt" => $product_unt,
        ]);
    }
    public function update(Request $request, $id)
    {
        $order = Order::find($id);
        if ($request->has('order_status')) {
            $orderDelete = $request->input('order_status');
            $delete = $request->input('deleted');
            Order::where('id' , $id)->update([
                'order_status' => $orderDelete,
                'deleted' => $delete
            ]);
        }
        if ($request->has('status')) {
            $statusId = $request->input('status');
            Order::where('id', $id)->update(['order_status' => $statusId, 'user_upd' => Auth::user()->id]);
            $customer = Customer::find($order->customer_id);
            if ($customer) {
                $customer_email = 'doan.diepkhanh@bjvietduc.com';
                // $customer_email = $customer->customer_email;
                $userUpdate = User::find(Auth::user()->id);
                $orderStatus = Status::find($order->order_status);
                Mail::to($customer_email)->send(new StatusOrder($order, $customer, $userUpdate, $orderStatus));
            }
        }
        if ($request->has('notes')) {
            $notes = $request->input('notes');
            Order::where('id', $id)->update(['notes' => $notes]);
        }

        if ($request->has('quantity')) {
            $quantityData = $request->input('quantity');
            foreach ($quantityData as $item) {
                OrderDetail::where('ID', $item['id'])->update(['quantity' => $item['quantity']]);
            }
        }
        $order_detail = OrderDetail::where("order_id", $id)->get();
        $customerOrder = Customer::all();
        return response()->json([
            "order" => $order,
            "customerOrder" => $customerOrder,
            "order_detail" => $order_detail
        ]);
    }
    public function destroy($id)
    {
        OrderDetail::where('ID', $id)->delete();
        return response()->json('Xóa thành công sản phẩm');
    }
}
