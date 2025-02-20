<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Customer;
use App\Models\Product;
use App\Models\ImportCustomer;
use App\Models\ImportProduct;
use Illuminate\Support\Facades\Auth;
use App\Models\Customers_Bids_Products;
use App\Models\Debts;
use App\Models\ImportCustomerDebt;
use App\Models\ImportWinningProduct;
use App\Models\devImportModel;
class ImportController extends Controller
{
    public function customersFilter (Request $request){
        $customerNames = $request->all();
        $existingCustomers = Customer::whereIn('customer_code', $customerNames)->get();
        $remainingCustomerNames = array_diff($customerNames, $existingCustomers->pluck('customer_code')->toArray());
        return response()->json($remainingCustomerNames);
    }
    public function customersImport (Request $request){
        $user = Auth::user()->id;
        $customers = $request->all();
        $company_id = Auth::user()->company_select;
        foreach ($customers as $customerData) {
            $existingCustomer = ImportCustomer::where('customer_code', $customerData['customer_code'])->first();
            if (is_null($existingCustomer)) {
                $customerData['company_id'] = $user;
                $customerData['user_init'] = $user;
                ImportCustomer::create($customerData);
            }
        }
        return response()->json(['message' => 'Import thành công']);
    }
    public function importDateCustomer(Request $request){
        $dateCustomer = $request->input('date');
        $dateProduct = $request->input('dateProduct');
        $devImport = DevImportModel::find(1);
        if (!$devImport) {
            return response()->json(['message' => 'Record not found'], 404);
        }
        $updateData = [];
        $company_id = Auth::user()->company_select;
        if ($company_id == '1') {
            $updateData['date_Customer_Bileje'] = $dateCustomer;
        }if ($company_id == '2') {
            $updateData['date_Customer'] = $dateCustomer;
        } else {
            $updateData['date_Customer_Dbl'] = $dateCustomer;
        }     
        if ($dateCustomer !== null) {
            $updateData['date_Customer'] = $dateCustomer;
        }
        if ($dateProduct !== null) {
            $updateData['date_Product'] = $dateProduct;
        }
        if (!empty($updateData)) {
            $devImport->update($updateData);
        }
        return response()->json(['message' => 'Update successful']);
    }

    public function getDateCustomer()
        {
            $devImport = DevImportModel::all();
            return response()->json($devImport);
        }

    public function productsFilter (Request $request){
        $productNames = $request->all();
        $existingProduct = Product::whereIn('prd_code', $productNames)->get();
        $remainingProductNames = array_diff($productNames, $existingProduct->pluck('prd_code')->toArray());
        return response()->json($remainingProductNames);
    }

    public function productImport(Request $request) {
        $user = Auth::user()->id;
        $company_id = Auth::user()->company_select;
        $products = $request->all();

        foreach ($products as $productData) {
            $existingProduct = ImportProduct::where('prd_name', $productData['prd_name'])->first();

            if (is_null($existingProduct)) {
                $productData['company_id'] = $company_id;
                $productData['user_id'] = $user;
                ImportProduct::create($productData);
            }
        }
        return response()->json(['message' => 'Import thành công']);
    }
    public function productWinningFilter(Request $request)
    {
        $productNames = $request->all();
        $productQuery = Customers_Bids_Products::query();
        if (!is_array($productNames)) {
            return response()->json(['error' => 'Invalid input'], 400);
        }
        foreach ($productNames as $condition) {
            $productQuery->orwhere('customer_code', $condition['customer_id']);
            $productQuery->orWhere('prd_code', $condition['prd_code']);
        }
        $existingProducts = $productQuery->get();
        $foundPairs = $existingProducts->map(function ($product) {
            return ['prd_code' => $product->prd_code];
        })->toArray();
        $remainingProductNames = array_filter($productNames, function ($condition) use ($foundPairs) {
            foreach ($foundPairs as $pair) {
                if ($pair['prd_code'] == $condition['prd_code']) {
                    return false;
                }
            }
            return true;
        });
        return response()->json(array_values($remainingProductNames));
    }
    public function productWinningImport (Request $request){
        $user = Auth::user()->id;
        $product = $request->all();
        foreach ($product as $products) {
            $existingProducts = ImportWinningProduct::where('prd_code', $products['prd_code'])->first();
            if (is_null($existingProducts)) {
                $products['user_id'] = $user;
                $products['company_id'] = $user;
                ImportProduct::create($products);
            }
        }
        return response()->json(['message' => 'Import thành công']);
    }
    public function importProductWinning(Request $request){
        $customerCode = $request->input('customer_id_product');
        $customerId = Customer::where('customer_code', 'LIKE', "%{$customerCode}%")->value('ID');
        if ($customerId) {
            $request->merge(['customer_id' => $customerId]);
        }else{
            $request->merge(['customer_id' => null]);
        }
        $productCode = $request->input('product_code');
        $productID = Product::where('prd_code', $productCode)->value('ID');
        if ($productID) {
            $request->merge(['product_id' => $productID]);
        }else{
            $request->merge(['product_id' => null]);
        }
        $request->merge(['customer_code' => $customerCode]);
        $requestData = $request->all();
        $product = Customers_Bids_Products::create($requestData);
        return response()->json(['message' => 'Sản phẩm đã tạo thành công'], 201);
    }

    public function debtsUser (Request $request){
        $user = Auth::user()->id;
        $product = $request->all();
        foreach ($product as $products) {
            $existingProducts = ImportProduct::where('prd_name', $products['prd_name'])->first();
            if (is_null($existingProducts)) {
                $products['user_id'] = $user;
                ImportProduct::create($products);
            }
        }
        return response()->json(['message' => 'Import thành công']);
    }
    public function debtCustomerfilter(Request $request) {
        $filterConditions = $request->all();
        $query = Debts::query();
        foreach ($filterConditions as $condition) {
            $query->orWhere(function ($query) use ($condition) {
                $query->where('customer_id', $condition['customer_id'])
                      ->where('output_code', $condition['output_code']);
            });
        }
        $existingCustomers = $query->get();
        $foundPairs = $existingCustomers->map(function ($customer) {
            return ['customer_id' => $customer->customer_id, 'output_code' => $customer->output_code];
        })->toArray();
        $remainingConditions = array_filter($filterConditions, function ($condition) use ($foundPairs) {
            foreach ($foundPairs as $pair) {
                if ($pair['customer_id'] == $condition['customer_id'] && $pair['output_code'] == $condition['output_code']) {
                    return false;
                }
            }
            return true;
        });
        return response()->json($remainingConditions);
    }
    public function debtCustomer (Request $request){
        $user = Auth::user()->id;
        $company_id = Auth::user()->company_select;
        $customers = $request->all();
        foreach ($customers as $customerData) {
            $existingCustomer = ImportCustomerDebt::where('customer_id', $customerData['customer_id'])
                                ->where('output_code', $customerData['output_code'])
                                ->first();
            if (is_null($existingCustomer)) {
                $customerData['user_init'] = $user;
                $customerData['company_id'] = $user;
                ImportCustomerDebt::create($customerData);
            }
        }
        return response()->json(['message' => 'Import thành công']);
    }
    public function importDebtCustomer(Request $request) {
        $customerDebts = $request->all();
        $user = Auth::user()->id;
        $company_id = Auth::user()->company_select;
        $debtsToInsert = [];
        foreach ($customerDebts as $customerDebt) {
            $debtsToInsert[] = [
                'output_code' => $customerDebt['output_code'],
                'ten_kh' => $customerDebt['ten_kh'],
                'customer_id' => $customerDebt['customer_id'],
                'paiddate' => $customerDebt['paiddate'],
                'expdate' => $customerDebt['expdate'],
                'paid' => $customerDebt['paid'],
                'company_id' => $company_id
            ];
        }
         Debts::insert($debtsToInsert);
        return response()->json(['message' => 'Công nợ theo khách hàng'], 201);
    }
    public function productImportWinning (Request $request){
        $user = Auth::user()->id;
        $company_id = Auth::user()->company_select;
        $product = $request->all();
        foreach ($product as $productsData) {
            $existingCustomer = ImportWinningProduct::where('customer_id', $productsData['customer_id'])
                                ->where('product_id', $productsData['product_id'])
                                ->first();
            if (is_null($existingCustomer)) {
                $productsData['user_init'] = $user;
                $productsData['company_id'] = $user;
                ImportWinningProduct::create($productsData);
            }
        }
        return response()->json(['message' => 'Import thành công']);
    }
}
