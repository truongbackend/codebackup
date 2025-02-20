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
use App\Models\orderLogModel;
use App\Models\Product;
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
        $ordersQuery->where(function ($query) use ($keyword) {
            $query->where('output_code', 'like', "%{$keyword}%")
                  ->orWhereHas('customer', function ($query) use ($keyword) {
                      $query->where('customer_name', 'like', "%{$keyword}%");
                  })
                  ->orWhereHas('user', function ($query) use ($keyword) {
                      $query->where('display_name', 'like', "%{$keyword}%");
                  })
                  ->orWhereHas('stores', function ($query) use ($keyword) {
                      $query->where('store_name', 'like', "%{$keyword}%");
                  });
        });
    }
    if ($user->roles()->where('name', 'Admin')->exists()) {
        $orders = $ordersQuery->paginate(50);
    } else {
        $assignedUserIds = $this->getUsersAssignedToUser($user->id);
        $assignedUserIds[] = $user->id; // Include the current user's ID as well
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

public function getUsersAssignedToUser($id, &$assignedUserIds = [])
{
    $users = User::where('user_assigned', 'LIKE', "%$id%")->get();

    foreach ($users as $user) {
        if (!in_array($user->id, $assignedUserIds)) {
            $assignedUserIds[] = $user->id;
            $this->getUsersAssignedToUser($user->id, $assignedUserIds);
        }
    }
    return $assignedUserIds;
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
        $product = Product::all();
        $status = Status::whereIn('id', [1, 2, 3,4,5])->get();
        $order_detail = OrderDetail::where("order_id", $id)->get();
        $order_log = orderLogModel::where('order_id' , $id)->get();
        $user = User::all();
        return response()->json([
            "order" => $order,
            "customer" => $customer,
            "order_detail" => $order_detail,
            "product" => $product,
            "status" => $status,
            "user" => $user,
            "order_log" =>$order_log
        ]);
    }
    public function update(Request $request, $id)
{
    $order = Order::find($id);
    $originalOrder = $order->toArray();
    $originalOrderDetails = OrderDetail::where("order_id", $id)->get();
    $logData = [];
    if ($request->has('order_status')) {
        $orderDelete = $request->input('order_status');
        $delete = $request->input('deleted');
        if ($order->order_status != $orderDelete || $order->deleted != $delete) {
            Order::where('id', $id)->update([
                'order_status' => $orderDelete,
                'deleted' => $delete
            ]);
        }
    }
    if ($order->order_status == 1) {
        orderLogModel::create([
            'order_id' => $id,
            'quantity' => null,
            'price' => null,
            'created_at' => now(),
            'product_id' => null,
            'user_id' => Auth::user()->id,
            'status' => 1,
        ]);

    }
    if ($request->has('notes')) {
        $notes = $request->input('notes');
        if ($order->notes != $notes) {
            Order::where('id', $id)->update(['notes' => $notes]);
        }
    }
    if ($request->has('quantity')) {
        $quantityData = $request->input('quantity');
        foreach ($quantityData as $item) {
            $originalOrderDetail = OrderDetail::find($item['id']);
            $quantityChanged = $originalOrderDetail->quantity != $item['quantity'];
            $priceChanged = $originalOrderDetail->price != $item['price'];
            if ($quantityChanged || $priceChanged) {
                $logData[] = [
                    'order_id' => $id,
                    'quantity' => $originalOrderDetail->quantity,
                    'price' => $originalOrderDetail->price,
                    'created_at' => now(),
                    'product_id' => $originalOrderDetail->product_id,
                    'user_id' => Auth::user()->id,
                    'status' => 4,
                ];
                OrderDetail::where('ID', $item['id'])->update([
                    'quantity' => $item['quantity'],
                    'price' => $item['price']
                ]);
            }
        }
        Order::where('id', $id)->update(['order_status' => 4]);
    }
    if ($request->has('status')) {
        $statusId = $request->input('status');
        if ($order->order_status != $statusId) {
            $logData[] = [
                'order_id' => $id,
                'quantity' => null,
                'price' => null,
                'created_at' => now(),
                'product_id' => null,
                'user_id' => Auth::user()->id,
                'status' => $order->order_status,
            ];
            Order::where('id', $id)->update(['order_status' => $statusId, 'user_upd' => Auth::user()->id]);
        }
    }
    foreach ($logData as $log) {
        orderLogModel::create($log);
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
    $user = Auth::user()->id;
    $orderDetail = OrderDetail::find($id);
    if ($orderDetail) {
        OrderDetail::where('ID', $id)->delete();
        orderLogModel::create([
            'order_id' => $orderDetail->order_id,
            'quantity' => $orderDetail->quantity,
            'price' => $orderDetail->price,
            'product_id' => $orderDetail->product_id,
            'user_id' => $user,
            'status' => 4,
            'delete' => 1,
        ]);
        Order::where('ID', $orderDetail->order_id)->update(['order_status' => 4]);
        return response()->json('Xóa thành công sản phẩm');
    } else {
        return response()->json('Không tìm thấy sản phẩm để xóa', 404);
    }
}
}
