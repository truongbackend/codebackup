<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Tổng quan công nợ phải thu <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách</h4>
<div class="card">
    <div class="card-body">
        <div class="row">
            <div class="col-md-4">
                <label for="exampleFormControlSelect1" class="form-label">Công ty</label>
                <model-list-select :list="company" v-model="selectedCompany" option-value="ma_cty" option-text="ten_cty" placeholder="Chọn công ty"></model-list-select>
            </div>
            <div class="col-md-4">
                <label for="exampleFormControlSelect1" class="form-label">Nhân viên</label>
                <model-list-select :list="ds_nhanvien" v-model="selectedUser" option-value="ma_kh" option-text="ten_kh" placeholder="Chọn nhân viên"></model-list-select>
            </div>
            <div class="col-md-4">
                <label for="exampleFormControlSelect1" class="form-label">khu vực </label>
                <model-list-select :list="ds_khuvuc" v-model="selectedKV" option-value="ma_khuvuc" option-text="ten_khuvuc" placeholder="Chọn khu vực"></model-list-select>
            </div>
        </div>
        <div class="row mt-3">
            <div class="col-md-4">
                <label for="exampleFormControlSelect1" class="form-label">khách hàng</label>
                <model-list-select :list="ds_khachhang" v-model="selectedCustomer" option-value="ma_kh" option-text="ten_kh" placeholder="Chọn khách hàng"></model-list-select>
            </div>
            <div class="col-md-4">
                <label for="exampleFormControlSelect1" class="form-label">Từ ngày</label>
                <input v-model="selectedDate" class="form-control" type="date" value="2021-06-18" id="html5-date-input">
            </div>
            <div class="col-md-4">
                <label for="exampleFormControlSelect1" class="form-label">Đến ngày</label>
                <input v-model="selectedDateEnd" class="form-control" type="date" value="2021-06-18" id="html5-date-input">
            </div>
        </div>
        <div class="row mt-3">
            <div class="col-md-3">

                <button type="button" class="btn btn-outline-danger" @click="getInventory">
                    <i class='bx bx-search-alt'></i> Xem kết quả
                </button>
            </div>
        </div>
    </div>
</div>
<div class="text-center" v-if="isLoading">
    <div class="spinner-border spinner-border-lg text-success " role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>
<div class="row">
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Dự nợ đầu kỳ</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.duno_dauky)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Phát sinh trong kỳ</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.phatsinh_trongky)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Thu trong kỳ</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.thu_trongky)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Nợ cuối kỳ</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.no_cuoiky)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Trong hạn</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.trong_han)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Quá hạn 30</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.quahan_30)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Quá hạn 60</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.quahan_60)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Quá hạn 90</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.quahan_90)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Quá hạn >90</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.quahan_120)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Phát sinh cùng kỳ</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.phatsinh_cungky)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">TT cùng kỳ</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.no_c_ttcungky)}} %</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Thu cùng kỳ</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.thu_cungky)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">TT cùng kỳ</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.co_c_ttcungky)}} %</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Phát sinh năm trước</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.phatsinh_namtruoc)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">TT so với năm trước</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.quahan30_ttsovoinamtruoc)}} %</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Thu năm trước</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.thu_namtruoc)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">TT so với năm trước</span>
                <h6 class="card-title mb-2">{{ formatNumber(ds_congnochung.quahan90_ttsovoinamtruoc)}} %</h6>
            </div>
        </div>
    </div>
</div>
<div class="row mt-4">
    <canvas ref="chartCanvas"></canvas>
</div>
<div class="row">
    <div class="col-md-6">
        <div class="card mt-4">
            <div class="card-header justify-content-between text-center">
                <h5 class="card-title m-0">Công nợ theo loại</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap scroll table-scroll table-px table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Loại</th>
                                <th>Nợ đầu kỳ</th>
                                <th>PS trong kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>Thu trong kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>Nợ cuối kỳ</th>
                                <th>Tỷ trọng</th>
                                <th>Nợ trong hạn</th>
                                <th>Quá hạn 30 </th>
                                <th>Quá hạn 60</th>
                                <th>Quá hạn 90</th>
                                <th>Quá > 90</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_congnotheoloais, index) in ds_congnotheoloai" :key="index">
                                <td>{{ ds_congnotheoloais.ten }}</td>
                                <td>{{ formatNumber(ds_congnotheoloais.no_dauky) }}</td>
                                <td>{{ formatNumber(ds_congnotheoloais.ps_trongky) }}</td>
                                <td>{{ formatNumber(ds_congnotheoloais.no_c_ttcungky) }}</td>
                                <td>{{ formatNumber(ds_congnotheoloais.thu_trongky) }}</td>
                                <td>{{ formatNumber(ds_congnotheoloais.co_c_ttcungky) }}</td>
                                <td>{{ formatNumber(ds_congnotheoloais.no_cuoiky) }}</td>
                                <td>{{ formatNumber(ds_congnotheoloais.tytrong) }}</td>
                                <td>{{ formatNumber(ds_congnotheoloais.no_tronghan) }}</td>
                                <td>{{ formatNumber(ds_congnotheoloais.quahan_30ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheoloais.quahan_60ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheoloais.quahan_90ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheoloais.quahan_120ngay) }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card mt-4">
            <div class="card-header justify-content-between text-center">
                <h5 class="card-title m-0">Công nợ theo kênh</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap table-scroll table-px table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Kênh</th>
                                <th>Nợ đầu kỳ</th>
                                <th>PS trong kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>Thu trong kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>Nợ cuối kỳ</th>
                                <th>Tỷ trọng</th>
                                <th>Nợ trong hạn</th>
                                <th>Quá hạn 30 </th>
                                <th>Quá hạn 60</th>
                                <th>Quá hạn 90</th>
                                <th>Quá > 90</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_congnotheokenh, index) in ds_congnotheokenh" :key="index">
                                <td>{{ ds_congnotheokenh.ten }}</td>
                                <td>{{ formatNumber(ds_congnotheokenh.no_dauky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokenh.ps_trongky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokenh.no_c_ttcungky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokenh.thu_trongky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokenh.co_c_ttcungky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokenh.no_cuoiky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokenh.tytrong) }}</td>
                                <td>{{ formatNumber(ds_congnotheokenh.no_tronghan) }}</td>
                                <td>{{ formatNumber(ds_congnotheokenh.quahan_30ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheokenh.quahan_60ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheokenh.quahan_90ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheokenh.quahan_120ngay) }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-6">
        <div class="card mt-4">
            <div class="card-header justify-content-between text-center">
                <h5 class="card-title m-0">Công nợ theo chi nhánh</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap scroll table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Chi nhánh</th>
                                <th>Nợ đầu kỳ</th>
                                <th>PS trong kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>Thu trong kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>Nợ cuối kỳ</th>
                                <th>Tỷ trọng</th>
                                <th>Nợ trong hạn</th>
                                <th>Quá hạn 30 </th>
                                <th>Quá hạn 60</th>
                                <th>Quá hạn 90</th>
                                <th>Quá > 90</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_congnotheochinhanhs, index) in ds_congnotheochinhanh" :key="index">
                                <td>{{ ds_congnotheochinhanhs.ten }}</td>
                                <td>{{ ds_congnotheochinhanhs.no_dauky }}</td>
                                <td>{{ ds_congnotheochinhanhs.ps_trongky }}</td>
                                <td>{{ ds_congnotheochinhanhs.no_c_ttcungky }}</td>
                                <td>{{ ds_congnotheochinhanhs.thu_trongky }}</td>
                                <td>{{ ds_congnotheochinhanhs.co_c_ttcungky }}</td>
                                <td>{{ ds_congnotheochinhanhs.no_cuoiky }}</td>
                                <td>{{ ds_congnotheochinhanhs.tytrong }}</td>
                                <td>{{ ds_congnotheochinhanhs.no_tronghan }}</td>
                                <td>{{ ds_congnotheochinhanhs.quahan_30ngay }}</td>
                                <td>{{ ds_congnotheochinhanhs.quahan_60ngay }}</td>
                                <td>{{ ds_congnotheochinhanhs.quahan_90ngay }}</td>
                                <td>{{ ds_congnotheochinhanhs.quahan_120ngay }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card mt-4">
            <div class="card-header justify-content-between text-center">
                <h5 class="card-title m-0">Công nợ theo khu vực</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Khu vực</th>
                                <th>Nợ đầu kỳ</th>
                                <th>PS trong kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>Thu trong kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>Nợ cuối kỳ</th>
                                <th>Tỷ trọng</th>
                                <th>Nợ trong hạn</th>
                                <th>Quá hạn 30 </th>
                                <th>Quá hạn 60</th>
                                <th>Quá hạn 90</th>
                                <th>Quá > 90</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_congnotheokhuvucs, index) in ds_congnotheokhuvuc" :key="index">
                                <td>{{ ds_congnotheokhuvucs.ten }}</td>
                                <td>{{ formatNumber(ds_congnotheokhuvucs.no_dauky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhuvucs.ps_trongky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhuvucs.no_c_ttcungky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhuvucs.thu_trongky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhuvucs.co_c_ttcungky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhuvucs.no_cuoiky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhuvucs.tytrong) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhuvucs.no_tronghan) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhuvucs.quahan_30ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhuvucs.quahan_60ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhuvucs.quahan_90ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhuvucs.quahan_120ngay) }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-6">
        <div class="card mt-4">
            <div class="card-header justify-content-between text-center">
                <h5 class="card-title m-0">Công nợ theo asm</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap scroll table-scroll table-px table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Tên asm</th>
                                <th>Nợ đầu kỳ</th>
                                <th>PS trong kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>Thu trong kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>Nợ cuối kỳ</th>
                                <th>Tỷ trọng</th>
                                <th>Nợ trong hạn</th>
                                <th>Quá hạn 30 </th>
                                <th>Quá hạn 60</th>
                                <th>Quá hạn 90</th>
                                <th>Quá > 90</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_congnotheoasms, index) in ds_congnotheoasm" :key="index">
                                <td>{{ ds_congnotheoasms.ten }}</td>
                                <td>{{ formatNumber(ds_congnotheoasms.no_dauky) }}</td>
                                <td>{{ formatNumber(ds_congnotheoasms.ps_trongky) }}</td>
                                <td>{{ formatNumber(ds_congnotheoasms.no_c_ttcungky) }}</td>
                                <td>{{ formatNumber(ds_congnotheoasms.thu_trongky) }}</td>
                                <td>{{ formatNumber(ds_congnotheoasms.co_c_ttcungky) }}</td>
                                <td>{{ formatNumber(ds_congnotheoasms.no_cuoiky) }}</td>
                                <td>{{ formatNumber(ds_congnotheoasms.tytrong) }}</td>
                                <td>{{ formatNumber(ds_congnotheoasms.no_tronghan) }}</td>
                                <td>{{ formatNumber(ds_congnotheoasms.quahan_30ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheoasms.quahan_60ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheoasms.quahan_90ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheoasms.quahan_120ngay) }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card mt-4">
            <div class="card-header justify-content-between text-center">
                <h5 class="card-title m-0">Công nợ theo nhóm khách hàng</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap table-scroll table-px table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Tên nhóm khách hàng</th>
                                <th>Nợ đầu kỳ</th>
                                <th>PS trong kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>Thu trong kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>Nợ cuối kỳ</th>
                                <th>Tỷ trọng</th>
                                <th>Nợ trong hạn</th>
                                <th>Quá hạn 30 </th>
                                <th>Quá hạn 60</th>
                                <th>Quá hạn 90</th>
                                <th>Quá > 90</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_congnotheonkhs, index) in ds_congnotheonkh" :key="index">
                                <td>{{ ds_congnotheonkhs.ten }}</td>
                                <td>{{ formatNumber(ds_congnotheonkhs.no_dauky) }}</td>
                                <td>{{ formatNumber(ds_congnotheonkhs.ps_trongky) }}</td>
                                <td>{{ formatNumber(ds_congnotheonkhs.no_c_ttcungky) }}</td>
                                <td>{{ formatNumber(ds_congnotheonkhs.thu_trongky) }}</td>
                                <td>{{ formatNumber(ds_congnotheonkhs.co_c_ttcungky) }}</td>
                                <td>{{ formatNumber(ds_congnotheonkhs.no_cuoiky) }}</td>
                                <td>{{ formatNumber(ds_congnotheonkhs.tytrong) }}</td>
                                <td>{{ formatNumber(ds_congnotheonkhs.no_tronghan) }}</td>
                                <td>{{ formatNumber(ds_congnotheonkhs.quahan_30ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheonkhs.quahan_60ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheonkhs.quahan_90ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheonkhs.quahan_120ngay) }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-6">
        <div class="card mt-4">
            <div class="card-header justify-content-between text-center">
                <h5 class="card-title m-0">Công nợ theo sale</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap scroll table-scroll table-px table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Tên seo</th>
                                <th>Nợ đầu kỳ</th>
                                <th>PS trong kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>Thu trong kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>Nợ cuối kỳ</th>
                                <th>Tỷ trọng</th>
                                <th>Nợ trong hạn</th>
                                <th>Quá hạn 30 </th>
                                <th>Quá hạn 60</th>
                                <th>Quá hạn 90</th>
                                <th>Quá > 90</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_congnotheosales, index) in ds_congnotheosale" :key="index">
                                <td>{{ ds_congnotheosales.ten }}</td>
                                <td>{{ formatNumber(ds_congnotheosales.no_dauky) }}</td>
                                <td>{{ formatNumber(ds_congnotheosales.ps_trongky) }}</td>
                                <td>{{ formatNumber(ds_congnotheosales.no_c_ttcungky) }}</td>
                                <td>{{ formatNumber(ds_congnotheosales.thu_trongky) }}</td>
                                <td>{{ formatNumber(ds_congnotheosales.co_c_ttcungky) }}</td>
                                <td>{{ formatNumber(ds_congnotheosales.no_cuoiky) }}</td>
                                <td>{{ formatNumber(ds_congnotheosales.tytrong) }}</td>
                                <td>{{ formatNumber(ds_congnotheosales.no_tronghan) }}</td>
                                <td>{{ formatNumber(ds_congnotheosales.quahan_30ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheosales.quahan_60ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheosales.quahan_90ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheosales.quahan_120ngay) }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card mt-4">
            <div class="card-header justify-content-between text-center">
                <h5 class="card-title m-0">Công nợ theo khách hàng</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap table-scroll table-px table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Tên khách hàng</th>
                                <th>Nợ đầu kỳ</th>
                                <th>PS trong kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>Thu trong kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>Nợ cuối kỳ</th>
                                <th>Tỷ trọng</th>
                                <th>Nợ trong hạn</th>
                                <th>Quá hạn 30 </th>
                                <th>Quá hạn 60</th>
                                <th>Quá hạn 90</th>
                                <th>Quá > 90</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_congnotheokhachhangs, index) in ds_congnotheokhachhang" :key="index">
                                <td>{{ ds_congnotheokhachhangs.ten }}</td>
                                <td>{{ formatNumber(ds_congnotheokhachhangs.no_dauky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhachhangs.ps_trongky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhachhangs.no_c_ttcungky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhachhangs.thu_trongky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhachhangs.co_c_ttcungky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhachhangs.no_cuoiky) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhachhangs.tytrong) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhachhangs.no_tronghan) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhachhangs.quahan_30ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhachhangs.quahan_60ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhachhangs.quahan_90ngay) }}</td>
                                <td>{{ formatNumber(ds_congnotheokhachhangs.quahan_120ngay) }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
</template>

<script>
import axios from 'axios';
import {
    defineComponent,
    ref,
    onMounted,
    watchEffect,
    computed
} from 'vue';
import {
    inject
} from 'vue';
import { ModelListSelect } from 'vue-search-select';
export default {
     components: {
        ModelListSelect,
    },
    setup() {
        const selectedUser = ref('');
        const company = ref([]);
        const ds_nhanvien = ref([]);
        const ds_vattu = ref([]);
        const globalState = inject('globalState');
        const baseApi = globalState.baseApi;
        const selectedCompany = ref('002');
        const selectedVt = ref('');
        const selectedCustomer = ref('');
        const ds_khachhang = ref([]);
        const ds_hinhthucxem = ref('');
        const selectDatetime = ref('2');
        const doanhthu_theohinhthuc = ref('');
        const selectedDate = ref('');
        const selectedDateEnd = ref('');
        const ds_congnotheoloai = ref('');
        const selectedMbC = ref('');
        const selectedKV = ref();
        const ds_congnotheothang = ref('');
        const ds_khuvuc = ref([]);
        const chartCanvas = ref(null);
        const isLoading = ref(false);
        const ds_chinhanh = ref('');
        const selectedCN = ref('');
        const chartInstance = ref(null);
        const ds_congnotheokenh = ref('');
        const ds_congnotheochinhanh = ref('');
        const ds_congnotheokhuvuc = ref('');
        const ds_congnotheoasm = ref('');
        const ds_congnotheonkh = ref('');
        const ds_congnotheosale = ref('');
        const ds_congnotheokhachhang = ref('');
        const ds_congnochung = ref('');
        const tokenApi = localStorage.getItem('tokensApi');
        const getAutoComplete = () => {
            const axiosConfig = {
                headers: {
                    Authorization: `Bearer ${tokenApi}`,
                    'Content-Type': 'application/json; charset=utf-8',
                    'API': 'True'
                },
            };
            axios
                .get(`${baseApi}/report/tongquan/congnophaithu-autocomplete`, axiosConfig)
                .then((response) => {
                    company.value = response.data.ds_congty;
                    ds_khachhang.value = response.data.ds_khachhang;
                    ds_nhanvien.value = response.data.ds_nhanvien;
                    ds_vattu.value = response.data.ds_vattu
                    ds_chinhanh.value = response.data.ds_chinhanh;
                    ds_khuvuc.value = response.data.ds_khuvuc;
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        const formatNumber = (value) => {
            if (value !== undefined && value !== null) {
                return value.toLocaleString();
            } else {
                return '';
            }
        };
        const getInventory = () => {
            isLoading.value = true;
            const params = {
                list_cty: selectedCompany.value,
                tungay: selectedDate.value,
                denngay: selectedDateEnd.value,
            };
            console.log(params);
            if (selectedUser.value) {
                params.ma_nhanvien = selectedUser.value;
            }
            if (selectedCustomer.value) {
                params.ma_khachhang = selectedCustomer.value;
            }
            if (selectedKV.value) {
                params.ma_khuvuc = selectedKV.value;
            }
            const axiosConfig = {
                headers: {
                    Authorization: `Bearer ${tokenApi}`,
                    'Content-Type': 'application/json; charset=utf-8',
                    'API': 'True'
                },
            };
            axios
                .get(`${baseApi}/report/tongquan/congnophaithu`,{
                    params: params,
                    ...axiosConfig,
                })
                .then((response) => {
                    drawChart();
                    ds_congnochung.value = response.data.ds_congnochung;
                    ds_congnotheothang.value = response.data.ds_congnotheothang;
                    ds_congnotheoloai.value = response.data.ds_congnotheoloai;
                    ds_congnotheokenh.value = response.data.ds_congnotheokenh;
                    ds_congnotheochinhanh.value = response.data.ds_congnotheochinhanh;
                    ds_congnotheokhuvuc.value = response.data.ds_congnotheokhuvuc;
                    ds_congnotheoasm.value = response.data.ds_congnotheoasm,
                        ds_congnotheonkh.value = response.data.ds_congnotheonkh,
                        ds_congnotheosale.value = response.data.ds_congnotheosale,
                        ds_congnotheokhachhang.value = response.data.ds_congnotheokhachhang,
                        isLoading.value = false;
                })
                .catch((error) => {
                    isLoading.value = false;
                    console.log(error);
                });
        };
        const getCurrentYearDates = () => {
            const today = new Date();
            const currentYear = today.getFullYear();
            const firstDayOfYear = new Date(currentYear, 0, 1);
            const lastDayOfYear = new Date(currentYear, 11, 31);
            const formatDate = date => {
                const year = date.getFullYear();
                let month = date.getMonth() + 1;
                let day = date.getDate();
                month = month < 10 ? `0${month}` : month;
                day = day < 10 ? `0${day}` : day;

                return `${year}-${month}-${day}`;
            };
            selectedDate.value = formatDate(firstDayOfYear);
            selectedDateEnd.value = formatDate(lastDayOfYear);
        };
        const drawChart = () => {
            if (!chartCanvas.value || !ds_congnotheothang.value) return;
            const ctx = chartCanvas.value.getContext('2d');
            const labels = ds_congnotheothang.value.map(item => item.thang);
            const phatsinh_trongky = ds_congnotheothang.value.map(item => item.phatsinh_trongky);
            const thu_trongky = ds_congnotheothang.value.map(item => item.thu_trongky);
            const data = {
                labels: labels,
                datasets: [{
                        label: 'Phát sinh trong kỳ',
                        backgroundColor: '#FF6384',
                        data: phatsinh_trongky,
                    },
                    {
                        label: 'Thu trong kỳ',
                        backgroundColor: '#36A2EB',
                        data: thu_trongky,
                    },
                ],
            };

            if (chartInstance.value) {
                chartInstance.value.destroy();
            }
            chartInstance.value = new Chart(ctx, {
                type: 'bar',
                data: data,
                options: {
                    scales: {
                        y: {
                            beginAtZero: true,
                        },
                    },
                    plugins: {
                        tooltip: {
                            mode: 'index',
                            intersect: false,
                        },
                    },
                },
            });
        };
        onMounted(() => {
            getAutoComplete();
            getCurrentYearDates();
            getInventory();
        });
        watchEffect(() => {
            drawChart();
        });

        return {
            company,
            selectedCompany,
            selectedVt,
            selectedDate,
            ds_nhanvien,
            ds_vattu,
            ds_khachhang,
            selectedCustomer,
            ds_hinhthucxem,
            selectDatetime,
            selectedUser,
            selectedDateEnd,
            selectedMbC,
            doanhthu_theohinhthuc,
            chartInstance,
            ds_congnotheothang,
            chartCanvas,
            ds_chinhanh,
            selectedCN,
            isLoading,
            ds_khuvuc,
            selectedKV,
            getInventory,
            ds_congnotheoloai,
            ds_congnotheokenh,
            ds_congnotheochinhanh,
            ds_congnotheokhuvuc,
            ds_congnotheoasm,
            ds_congnotheonkh,
            ds_congnotheosale,
            ds_congnotheokhachhang,
            ds_congnochung,
            formatNumber,
        };
    }
};
</script>
