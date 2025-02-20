<?php

namespace App\Imports;

use App\Models\Category;
use App\Models\Product;
use App\Models\ProductsManufacture;
use App\Models\ProductsUnit;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithHeadingRow;
use Maatwebsite\Excel\Concerns\WithValidation;

class ProductImport implements ToCollection, WithHeadingRow, WithValidation
{
    private $existingProducts = [];

    public function collection(Collection $rows)
    {
        foreach ($rows as $row) {
            if (
                isset($row['ten_san_pham']) &&
                isset($row['ma_san_pham']) &&
                isset($row['so_luong']) &&
                isset($row['hoat_chat']) &&
                isset($row['dong_goi']) &&
                isset($row['gia_ban']) &&
                isset($row['nong_do']) &&
                isset($row['nha_san_xuat']) &&
                isset($row['danh_muc']) &&
                isset($row['don_vi_tinh'])
            ) {
                $manufacturerId = null;
                $prdUnitId = null;
                $categoryId = null;

                $manufacturer = ProductsManufacture::where('prd_manuf_name', $row['nha_san_xuat'])->first();
                if ($manufacturer) {
                    $manufacturerId = $manufacturer->ID;
                }

                $prdUnit = ProductsUnit::where('prd_unit_name', $row['don_vi_tinh'])->first();
                if ($prdUnit) {
                    $prdUnitId = $prdUnit->ID;
                }

                $category = Category::where('prd_group_name', $row['danh_muc'])->first();
                if ($category) {
                    $categoryId = $category->ID;
                }

                $data = [
                    'prd_name' => $row['ten_san_pham'],
                    'prd_code' => $row['ma_san_pham'],
                    'prd_sls' => $row['so_luong'],
                    'prd_active' => $row['hoat_chat'],
                    'prd_pack' => $row['dong_goi'],
                    'prd_sell_price' => $row['gia_ban'],
                    'prd_content' => $row['nong_do'],
                    'prd_manufacture_id' => $manufacturerId,
                    'prd_unit_id' => $prdUnitId,
                    'prd_group_id' => $categoryId,
                ];

                $existingProduct = Product::where('prd_name', $row['ten_san_pham'])->first();
                if ($existingProduct) {
                    $this->existingProducts[] = [
                        'row' => $row->toArray(),
                        'existing_product' => $existingProduct->toArray(),
                    ];
                }

                Product::create($data);
            }
        }
    }

    public function rules(): array
    {
        return [
            'ten_san_pham' => 'unique:cms_products,prd_name',
            'ma_san_pham' => 'unique:cms_products,prd_code',
        ];
    }

    public function customValidationMessages()
    {
        return [
            'ten_san_pham.unique' => 'Tên sản phẩm đã tồn tại trong hệ thống.',
            'ma_san_pham.unique' => 'Mã sản phẩm đã tồn tại trong hệ thống.',
        ];
    }

    public function getExistingProducts()
    {
        return $this->existingProducts;
    }
}
