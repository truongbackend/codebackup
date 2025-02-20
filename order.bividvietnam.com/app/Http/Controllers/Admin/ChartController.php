<?php

namespace App\Http\Controllers\Admin;

use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;

class ChartController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        try {
            $user = Auth::user();
            $data = DB::table('cms_orders')
                ->select(
                    DB::raw('YEAR(created) as year'),
                    DB::raw('MONTH(created) as month'),
                    DB::raw('SUM(total_price) as total_price')
                )
                ->where('company_id', $user->company_select)
                ->groupBy('year', 'month')
                ->get();
            $formattedData = [];
            foreach ($data as $item) {
                $year = $item->year;
                $month = $item->month;
                $totalPrice = $item->total_price;

                $formattedData[] = [
                    'year' => $year,
                    'month' => $month,
                    'total_price' => $totalPrice
                ];
            }

            return response()->json(['data' => $formattedData]);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred'], 500);
        }
    }
    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create(Request $request)
    {
        $validated = $request->validate([
            'year' => 'min:1900',
        ],
        [
            "year.min" => "Vui lòng nhập năm lớn hơn năm 2000",
        ]
    );
        $year = $request->input('year');
        $query = DB::table('cms_orders')
            ->select(
                DB::raw('YEAR(created) as year'),
                DB::raw('MONTH(created) as month'),
                DB::raw('SUM(total_price) as total_price')
            )
            ->groupBy('year', 'month');
        if ($year !== null) {
            $query->where(DB::raw('YEAR(created)'), $year);
        }
        $data = $query->get();
        return response()->json(['data' => $data]);
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
