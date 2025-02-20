<?php

namespace App\Http\Controllers\Admin;

use App\Models\Stores;
use App\Models\Customer;
use App\Models\UsersGroup;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Debts;
use App\Models\Functions;
use App\Models\Order;
use App\Models\OrderPx;
use App\Models\User;
use App\Models\CustomersBids;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use App\Mail\SendCustomer;
use Nette\Utils\Random;
use App\Models\Company;
use App\Models\Customers_Bids_Products;
use App\Models\Product;
use Illuminate\Support\Facades\Auth;
class CustomerController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
{
    $user = Auth::user();
    $keyword = $request->input('keyword');
    $customersQuery = Customer::query();

    if ($user->company_select) {
        $customersQuery->where('company_id', $user->company_select);
    }

    if ($keyword) {
        $customersQuery->where(function ($query) use ($keyword) {
            $query->where('customer_name', 'like', "%{$keyword}%")
                  ->orWhere('customer_phone', 'like', "%{$keyword}%")
                  ->orWhere('customer_code', 'like', "%{$keyword}%");
        });
    }

    if ($user->hasRole('Admin')) {
        $customers = $customersQuery->orderBy('created', 'desc')->paginate(50);
    } else {
        $assignedUserIds = $this->getUsersAssignedToUser($user->id);
        $assignedUserIds[] = $user->id; // Include the current user's ID
        $customers = $customersQuery->whereIn('user_assigned', $assignedUserIds)->orderBy('created', 'desc')->paginate(50);
    }

    $stores = Stores::all();
    $data = [
        'customers' => $customers,
        'stores' => $stores,
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
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $stores = Stores::paginate(50);
        $customers = Customer::paginate(50);
        $data = [
            'stores' => $stores,
            'customers' => $customers,
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
    $user = Auth::user()->id;
    $request->merge(['user_assigned' => $user]);
    $currentYear = date('Y');
    $dayOfYear = date('z') + 1;
    $randomNumber = mt_rand(100, 999);
    if ($request->customer_code) {
        $customer_code = $request->customer_code;
    }else{
        $customer_code = $currentYear . $dayOfYear . $randomNumber;
    }
    $request->merge(['customer_code' => $customer_code]);
    $userlogin = Auth::user();
    $request->merge(['company_id' => $userlogin->company_select]);
    $request->merge(['user_init' => $user]);
    $requestData = $request->all();
    if ($request->hasFile('customer_image')) {
        $imagePath = $request->file('customer_image')->store('customer_images', 'public');
        $requestData['customer_image'] = $imagePath;
    }
    $customer = Customer::create($requestData);
    return response()->json(['message' => 'Customer created successfully'], 201);
}


    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $customer = Customer::find($id);
        $stores = Stores::all();
        $users = User::where('customer_id', $id)->get();
        $customerBids = CustomersBids::where('customer_id', $id)->where('deleted', 0)->get();
        $order_Px = Order::where('customer_id', $id)
            ->select('id', 'customer_id', 'output_code', 'created', 'total_money', 'mtc', 'order_status')
            ->union(
                OrderPx::where('customer_id', $id)
                    ->select('id', 'customer_id', 'output_code', 'created', 'total_money', 'mtc', 'order_status')
                    ->where('deleted', 0)
            )
            ->get();
        // $order = Order::where('user_init',$users)->get();
        $order_Debts = Debts::where('customer_id', $id)->where('debt_status', 0)->get();
        return response()->json([
            "customer" => $customer,
            "stores" => $stores,
            "customerBids" => $customerBids,
            "users" => $users,
            "order_Px" => $order_Px,
            "order_Debts" => $order_Debts,
            // "order" => $order,
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
        $stores = Stores::all();
        $customer = Customer::find($id);
        $company = Company::all();
        if (!$customer) {
            return response()->json(["error" => "Không tìm thấy khách hàng"], 404);
        }
        $users =  User::where('deleted', 0)
            ->whereIn('id', [$id])
            ->get();

        return response()->json([
            'company' => $company,
            "customer" => $customer,
            "stores" => $stores,
            "users" => $users
        ]);
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
        Customer::where('id', $id)->update($request->all());
        return response()->json(['message' => 'Store updated successfully']);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        Customer::where('id', $id)->delete();
        return response()->json('The post successfully deleted');
    }
    public function getCustomer(){
        $customer = Customer::all();
        $user = User::all();
        return response()->json([
            "customer" => $customer,
            "users" => $user
        ]);
    }
    public function putCustomerToUser(Request $request, $id){
        $customer = Customer::find($id);
        if ($customer) {
            $customer->user_assigned = null;
            $customer->save();
            return response()->json(['message' => 'User assigned relationship removed successfully']);

        } else {
            return response()->json(['error' => 'User not found'], 404);
        }
    }
    public function postCustomerToUser(Request $request, $id){
        $customerSelect = $request->input('selectedCustomer');
        $customers = Customer::find($customerSelect);
        $customers->user_assigned = $id;
        $customers->save();
        return response()->json(['message' => 'User assigned relationship removed successfully']);
    }
    public function biddingContractCustomer(){
        $products = Product::all();
        $data = [
            'product' => $products,
        ];
        return response()->json($data);
    }
    public function postBiddingCustomer(Request $request) {
        $customersBid = CustomersBids::create($request->all());
        $product = $request->input('product');
        $price = $request->input('prd_sell_price');
        $quantity = $request->input('total_quantity');
        $customer = $request->input('customer_id');
        $customersBidsProduct = Customers_Bids_Products::create([
            'bid_id' => $customersBid->id,
            'product_id' => $product['ID'],
            'prd_code' => $product['prd_code'],
            'prd_sell_price' =>$price,
            'quantity' =>$quantity,
            'customer_id' =>$customer,
        ]);
        return response()->json(['message' => 'Tạo thành công mã hợp đồng']);
    }
    public function editBiddingCustomer( Request $request){
        $customer_id = $request->input('customer_id');
        $output_code = $request->input('output_code');
        $customerBid  = CustomersBids::where('customer_id', $customer_id)
                            ->where('output_code', $output_code)
                            ->first();
        $customersBidsProducts = Customers_Bids_Products::where('customer_id', $customer_id)
                            ->where('bid_id', $customerBid->ID)
                            ->get();
        dd($customersBidsProducts);
        $data = [
            'product' => $customerBid,
            'products' => $customersBidsProducts
        ];
        return response()->json($data);
    }
    public function DeleteBiddingCustomer(Request $request){
        $customer_id = $request->input('customer_id');
        $customerBids = $request->input('output_code');
        dd( $customerBids);
    }

}
