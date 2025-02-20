<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\UsersGroup;
use Illuminate\Http\Request;
use App\Models\Order;
use App\Models\Product;
use App\Models\OrderDetail;
use App\Models\OrderPx;
use App\Models\Order_px_Detail;
use App\Models\DebtsDetail;

class UserGroupController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $user_group = UsersGroup::paginate(50);
        $data = [
            'user_group' => $user_group,
        ];
        return response()->json($data);
    }
    // public function get(){
    //     $orders = OrderPx::all();
    //     foreach($orders->chunk(10000) as $chunk){
    //         foreach($chunk as $order){
    //             $orderID = $order->ID;
    //             $detailOrders = json_decode($order->detail_order, true);
    //             if($detailOrders){
    //                 foreach ($detailOrders as $detailOrder) {
    //                     if(isset($detailOrder['quantity']) && is_numeric($detailOrder['quantity']) && isset($detailOrder['bid_id'])) {
    //                         $orderDetail = new DebtsDetail();
    //                             $product = Product::find($detailOrder['id']);
    //                             $orderDetail->product_name = $product->prd_name;
    //                             $orderDetail->product_code = $product->prd_code;
    //                             $orderDetail->quantity = $detailOrder['quantity'];
    //                             $orderDetail->product_id = $detailOrder['id'];
    //                             $orderDetail->bid_id = $detailOrder['bid_id'];
    //                             $orderDetail->price = $detailOrder['price'];
    //                             $orderDetail->order_id = $orderID;
    //                             $orderDetail->save();
    //                     }
    //                 }
    //             }
    //         }
    //     }
    //     return response()->json(['message' => 'Order details saved successfully']);
    // }
    public function get(){
        $orders = Order::all();
        foreach($orders as $order){
            $orderID = $order->ID;
            $detailOrders = json_decode($order->detail_order, true);
            if($detailOrders){
                foreach ($detailOrders as $detailOrder) {
                    if(isset($detailOrder['quantity']) && is_numeric($detailOrder['quantity']) && isset($detailOrder['bid_id'])) {
                        $orderDetail = new OrderDetail();
                        $product = Product::find($detailOrder['id']);
                        if($product){
                            $orderDetail->product_name = $product->prd_name;
                            $orderDetail->product_code = $product->prd_code;
                            $orderDetail->quantity = $detailOrder['quantity'];
                            $orderDetail->product_id = $detailOrder['id'];
                            $orderDetail->bid_id = $detailOrder['bid_id'];
                            $orderDetail->price = $detailOrder['price'];
                            $orderDetail->order_id = $orderID;
                            $orderDetail->save();
                        } else {

                        }
                    }
                }
            }
        }
        return response()->json(['message' => 'Order details saved successfully']);
    }




}
