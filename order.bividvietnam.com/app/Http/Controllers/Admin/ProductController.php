<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Product;
use App\Imports\ProductImport;
use App\Models\ProductsManufacture;
use App\Models\ProductsUnit;
use App\Models\Status;
use Illuminate\Http\Request;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
class ProductController extends Controller

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
        $user = Auth::user();
        if ($user->company_select) {
            $products->where('company_id', $user->company_select);
        }
        if ($keyword) {
            $products->where('prd_name', 'like', "%{$keyword}%");
            $products->orWhere('prd_code', 'like', "%{$keyword}%");
            $products->orWhere('prd_active', 'like', "%{$keyword}%");
        }

        $products = $products->orderBy('created', 'desc')->paginate(50);
        $category = Category::all();
        $producer = ProductsManufacture::all();
        $status = Status::paginate(50);
        $data = [
            'product' => $products,
            'producer' => $producer,
            'category' => $category,
            'status' => $status,
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
        $producer = ProductsManufacture::paginate(50);
        $product_unit = ProductsUnit::paginate(50);
        $user = Auth::user();
        $category = Category::query();
        if ($user->company_select) {
            $category->where('company_id', $user->company_select);
        }
        $category = $category->paginate(50);
        $data = [
            'producer' => $producer,
            'product_unit' => $product_unit,
            'category' => $category,
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
    if ($request->hasFile('file')) {
        Excel::import(new ProductImport, $request->file('file'));
        return response()->json('Products successfully uploaded');
    }
    $validator = Validator::make($request->all(), [
        'prd_code' => 'distinct',
        'prd_name' => 'required|max:255',
        'prd_sell_price' => 'required|numeric|min:0',
        // 'prd_active' => 'required',
        // 'prd_content' => 'required',

    ], [
        // "prd_content.required" => "Hãy nhập nồng độ hàm lượng",
        // "prd_active.required" => "Hãy nhập đơn vị hoạt chất",
        "prd_unit_id.required" => "Hãy nhập đơn vị tính",
        "prd_name.required" => "Hãy nhập tên sản phẩm",
        "prd_name.max" => "Ký tự tối đa là 255",
        "prd_sell_price.required" => "Hãy nhập số tiền sản phẩm",
        "prd_sell_price.numeric" => "Số tiền sản phẩm phải là số",
        "prd_sell_price.min" => "Số tiền sản phẩm không được nhỏ hơn 0",
    ]);
    if ($validator->fails()) {
        return response()->json($validator->errors(), 400);
    }
    $user = Auth::user();
    $company_id = $user->company_select;
    $requestData = $request->all();
    if ($request->hasFile('prd_image_url')) {
        $imagePath = $request->file('prd_image_url')->store('product_images', 'public');
        $requestData['prd_image_url'] = $imagePath;
    }
    $requestData['company_id'] = $company_id;
    $products = Product::create($requestData);
    return response()->json(['message' => 'Sản phẩm đã tạo thành công'], 201);
}

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $producer = ProductsManufacture::paginate(50);
        $product_unit = ProductsUnit::paginate(50);
        $products = Product::find($id);
        $category = Category::paginate(50);
        return response()->json([
            "products" => $products,
            "producer" => $producer,
            "product_unit" => $product_unit,
            "category" => $category,
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
        $category = Category::paginate(50);
        $producer = ProductsManufacture::paginate(50);
        $product_unit = ProductsUnit::paginate(50);
        $products = Product::find($id);
        return response()->json([
            "products" => $products,
            "producer" => $producer,
            "product_unit" => $product_unit,
            "category" => $category,
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
        Product::where('id' , $id)->update($request->all());
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
        Product::where('id',$id)->delete();
        return response()->json('The post successfully deleted');
    }
}
