<?php

namespace App\Http\Controllers\Admin;

use App\Models\Stores;
use App\Models\Customer;
use App\Models\UsersGroup;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\CustomersBids;
use App\Models\Debts;
use App\Models\Functions;
use App\Models\Order;
use App\Models\OrderPx;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use App\Mail\SendCustomer;
use Nette\Utils\Random;
use App\Models\Company;
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
    $customers = Customer::query();
    if ($user->company_select) {
        $customers->where('company_id', $user->company_select);
    }
    if ($keyword) {
        $customers->where(function ($query) use ($keyword) {
            $query->where('customer_name', 'like', "%{$keyword}%")
                ->orWhere('customer_phone', 'like', "%{$keyword}%")
                ->orWhere('customer_code', 'like', "%{$keyword}%");
        });
    }

    if ($user->hasRole('Admin')) {
        $customers->orderBy('created', 'desc')->paginate(50);
    } else {
        $assignedUsers = [];
        $this->getUsersAssignedToUser($user->id, $assignedUsers);
        $assignedUserIds = array_unique(array_merge([$user->id], array_column($assignedUsers, 'id')));
        $customers->whereIn('user_assigned', $assignedUserIds);
    }

    $customers = $customers->orderBy('created', 'desc')->paginate(50);
    $stores = Stores::all();
    $data = [
        'customers' => $customers,
        'stores' => $stores,
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
    $validated = $request->validate([
        'customer_name' => 'required|max:255',
    ], [
        "customer_name.required" => "Vui lòng nhập tên khách hàng",
    ]);
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

}
