<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\StoreManager;
use App\Models\Stores;
use Illuminate\Contracts\Cache\Store;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
class StoresController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {   
        $store_manager = StoreManager::paginate(50);
        $user = Auth::user();
        $storesQuery = Stores::query();
        if ($user->company_select) {
            $storesQuery->where('company_id', $user->company_select);
        }
        $stores = $storesQuery->orderBy('created', 'desc')->paginate(50);
        
        return response()->json(['stores' => $stores , 'store_manager' => $store_manager]);
    }
    public function store(Request $request)
    {
        $validated = $request->validate([
            'store_name' => 'required|unique:cms_stores,store_name',
        ], [
            "store_name.required" => "Hãy nhập tên kho",
            "store_name.unique" => "Tên kho đã tồn tại"
        ]);
        Stores::create($request->all());
        return response()->json(['message' => 'Store created successfully']);
    }
    public function edit($id)
    {
        $stores = Stores::find($id);
        return response()->json(["stores" => $stores]);
    }
    public function update(Request $request, $id)
    {
        Stores::where('id' , $id)->update($request->all());
        return response()->json(['message' => 'Store updated successfully']);
    }
    public function destroy($id)
    {
        Stores::where('id',$id)->delete();
        return response()->json('The post successfully deleted');
    }
}
