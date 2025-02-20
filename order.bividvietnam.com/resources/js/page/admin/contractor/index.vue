<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Tổng quan thầu<i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách</h4>
<div class="card">
    <div class="card-body">
        <div class="row">
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Công ty</label>
                <model-list-select :list="company" v-model="selectedCompany" option-value="ma_cty" option-text="ten_cty" placeholder="Chọn công ty"></model-list-select>
            </div>
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Sản phẩm</label>
                <model-list-select :list="ds_vattu" v-model="selectedVt" option-value="ma_vt" option-text="ten_vt" placeholder="Chọn sản phẩm"></model-list-select>
            </div>
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Từ ngày</label>
                <input v-model="selectedDate" class="form-control" type="date" value="2021-06-18" id="html5-date-input">
            </div>
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Đến ngày</label>
                <input v-model="selectedDateEnd" class="form-control" type="date" value="2021-06-18" id="html5-date-input">
            </div>
        </div>
        <div class="row">
            <div class="col-md-3 mt-3">
                <button type="button" class="btn btn-outline-danger" @click="getInventory">
                    <i class='bx bx-search-alt'></i> Xem kết quả
                </button>
            </div>
        </div>
    </div>
</div>
<div class="text-center" v-if="isLoading">
    <div class="spinner-border spinner-border-lg text-success" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>
<div class="content">
    <div class="row ">
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Số lượng mời thầu</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.soluong_moithau) }} </h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Gía trị mời thầu</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.giatri_moithau) }} đ</h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Tỉ lệ SL trúng thầu </span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.tile_soluongtrungthau) }} %</h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Tỉ lệ GT trúng thầu</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.tile_soluongtrungthauchenhlech) }} %</h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Mời thầu TT cùng kỳ</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.moithau_ttcungky) }} %</h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Mời thầu TT cùng kỳ</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.moithau_ttnamtruoc) }} %</h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Số lượng mời thầu</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.soluong_moithau) }}</h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Số lượng TT trong kỳ</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.soluong_trungthautrongky) }} </h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Giá trị mời thầu trong kỳ</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.giatri_trungthautrongky) }} đ</h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Trúng thầu TT cùng kỳ</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.trungthau_ttcungky) }} %</h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Trúng thầu TT năm trước</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.trungthau_ttnamtruoc) }} %</h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Số lượng thực hiện</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.soluong_thuchien) }} </h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Giá trị thực hiện</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.giatri_thuchien) }} đ</h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Số lượng tồn thầu cuối kỳ</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.soluong_tonthaucuoiky) }} </h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Giá trị tồn thầu cuối kỳ</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.giatri_tonthaucuoiky) }} đ</h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Số lượng tồn thầu cùng kỳ</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.giatri_tonthaucungky) }}</h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Giá trị tồn thầu cùng kỳ</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.giatri_tonthaucungky) }} đ</h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Số lượng bỏ thầu</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.soluong_bothau) }}</h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Giá trị bỏ thầu</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.giatri_bothau) }} đ</h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">Giá trị bỏ thầu TT cùng kỳ</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.giatri_bothaucungky) }} %</h6>
                </div>
            </div>
        </div>
        <div class="col-sm-2 col-md-2 mt-3">
            <div class="card">
                <div class="card-body">
                    <span class="fw-semibold d-block mb-1">GT bỏ thầu TT năm trước</span>
                    <h6 class="card-title mb-2"> {{ formatNumber(ds_thauchung.giatri_bothaunamtruoc) }} %</h6>
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
                    <h5 class="card-title m-0">Theo chi nhánh</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive text-nowrap table-scroll table-px">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Chi nhánh</th>
                                    <th>Giá trị mời thầu</th>
                                    <th>TL SL trúng thầu</th>
                                    <th>TL trúng thầu</th>
                                    <th>Giá trị trúng thầu</th>
                                    <th>Giá trị thầu</th>
                                    <th>Giá trị thực hiện</th>
                                    <th>Giá trị tồn thầu</th>
                                    <th>Giá trị bỏ thầu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(ds_thautheochinhanhs, index) in ds_thautheochinhanh" :key="index">
                                    <td>{{ formatNumber(ds_thautheochinhanhs.ten) }}</td>
                                    <td>{{ formatNumber(ds_thautheochinhanhs.giatri_moithau) }}</td>
                                    <td>{{ formatNumber(ds_thautheochinhanhs.tile_soluongtrungthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheochinhanhs.tile_giatritrungthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheochinhanhs.giatri_trungthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheochinhanhs.giatri_thau) }}</td>
                                    <td>{{ formatNumber(ds_thautheochinhanhs.giatri_thuchien) }}</td>
                                    <td>{{ formatNumber(ds_thautheochinhanhs.giatri_tonthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheochinhanhs.giatri_bothau) }}</td>
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
                    <h5 class="card-title m-0">Theo nhóm khách hàng</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive text-nowrap table-scroll table-px">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Tên khách hàng</th>
                                    <th>Giá trị mời thầu</th>
                                    <th>TL SL trúng thầu</th>
                                    <th>TL trúng thầu</th>
                                    <th>Giá trị trúng thầu</th>
                                    <th>Giá trị thầu</th>
                                    <th>Giá trị thực hiện</th>
                                    <th>Giá trị tồn thầu</th>
                                    <th>Giá trị bỏ thầu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(ds_thautheonkhs, index) in ds_thautheonkh" :key="index">
                                    <td>{{ ds_thautheonkhs.ten }}</td>
                                    <td>{{ formatNumber(ds_thautheonkhs.giatri_moithau) }}</td>
                                    <td>{{ formatNumber(ds_thautheonkhs.tile_soluongtrungthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheonkhs.tile_giatritrungthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheonkhs.giatri_trungthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheonkhs.giatri_thau) }}</td>
                                    <td>{{ formatNumber(ds_thautheonkhs.giatri_thuchien) }}</td>
                                    <td>{{ formatNumber(ds_thautheonkhs.giatri_tonthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheonkhs.giatri_bothau) }}</td>
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
                    <h5 class="card-title m-0">Theo nhóm sản phẩm</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive text-nowrap table-scroll table-px">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Tên sản phẩm</th>
                                    <th>Giá trị mời thầu</th>
                                    <th>TL SL trúng thầu</th>
                                    <th>TL trúng thầu</th>
                                    <th>Giá trị trúng thầu</th>
                                    <th>Giá trị thầu</th>
                                    <th>Giá trị thực hiện</th>
                                    <th>Giá trị tồn thầu</th>
                                    <th>Giá trị bỏ thầu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(ds_thautheonsps, index) in ds_thautheonsp" :key="index">
                                    <td>{{ ds_thautheonsps.ten }}</td>
                                    <td>{{ formatNumber(ds_thautheonsps.giatri_moithau) }}</td>
                                    <td>{{ formatNumber(ds_thautheonsps.tile_soluongtrungthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheonsps.tile_giatritrungthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheonsps.giatri_trungthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheonsps.giatri_thau) }}</td>
                                    <td>{{ formatNumber(ds_thautheonsps.giatri_thuchien) }}</td>
                                    <td>{{ formatNumber(ds_thautheonsps.giatri_tonthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheonsps.giatri_bothau) }}</td>
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
                    <h5 class="card-title m-0">Theo nhân viên</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive text-nowrap table-scroll table-px">
                        <table class="table table-bordered ">
                            <thead>
                                <tr>
                                    <th>Tên nhân viên</th>
                                    <th>Giá trị thầu</th>
                                    <th>Giá trị thực hiện </th>
                                    <th>Giá trị tồn thầu</th>
                                    <th>Giá trị bỏ thầu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(ds_thautheonhanviens, index) in ds_thautheonhanvien" :key="index">
                                    <td>{{ ds_thautheonhanviens.ten }}</td>
                                    <td>{{ formatNumber(ds_thautheonhanviens.giatri_thau) }}</td>
                                    <td>{{ formatNumber(ds_thautheonhanviens.giatri_thuchien) }}</td>
                                    <td>{{ formatNumber(ds_thautheonhanviens.giatri_bothau) }}</td>
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
                    <h5 class="card-title m-0">Theo khách hàng</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive text-nowrap table-scroll table-px">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Tên khách hàng</th>
                                    <th>Giá trị mời thầu</th>
                                    <th>TL SL trúng thầu</th>
                                    <th>TL trúng thầu</th>
                                    <th>Giá trị trúng thầu</th>
                                    <th>Giá trị thầu</th>
                                    <th>Giá trị thực hiện</th>
                                    <th>Giá trị tồn thầu</th>
                                    <th>Giá trị bỏ thầu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(ds_thautheokhachhangs, index) in ds_thautheokhachhang" :key="index">
                                    <td>{{ ds_thautheokhachhangs.ten }}</td>
                                    <td>{{ formatNumber(ds_thautheokhachhangs.giatri_moithau) }}</td>
                                    <td>{{ formatNumber(ds_thautheokhachhangs.tile_soluongtrungthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheokhachhangs.tile_giatritrungthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheokhachhangs.giatri_trungthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheokhachhangs.giatri_thau) }}</td>
                                    <td>{{ formatNumber(ds_thautheokhachhangs.giatri_thuchien) }}</td>
                                    <td>{{ formatNumber(ds_thautheokhachhangs.giatri_tonthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheokhachhangs.giatri_bothau) }}</td>
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
                    <h5 class="card-title m-0">Theo sản phẩm</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive text-nowrap table-scroll table-px">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Tên sản phẩm</th>
                                    <th>Giá trị mời thầu</th>
                                    <th>TL SL trúng thầu</th>
                                    <th>TL trúng thầu</th>
                                    <th>Giá trị trúng thầu</th>
                                    <th>Giá trị thầu</th>
                                    <th>Giá trị thực hiện</th>
                                    <th>Giá trị tồn thầu</th>
                                    <th>Giá trị bỏ thầu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(ds_thautheosanphams, index) in ds_thautheosanpham" :key="index">
                                    <td>{{ ds_thautheosanphams.ten }}</td>
                                    <td>{{ formatNumber(ds_thautheosanphams.giatri_moithau) }}</td>
                                    <td>{{ formatNumber(ds_thautheosanphams.tile_soluongtrungthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheosanphams.tile_giatritrungthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheosanphams.giatri_trungthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheosanphams.giatri_thau) }}</td>
                                    <td>{{ formatNumber(ds_thautheosanphams.giatri_thuchien) }}</td>
                                    <td>{{ formatNumber(ds_thautheosanphams.giatri_tonthau) }}</td>
                                    <td>{{ formatNumber(ds_thautheosanphams.giatri_bothau) }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md">
            <div class="card mt-4">
                <div class="card-header justify-content-between text-center">
                    <h5 class="card-title m-0">Tồn thầu</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive text-nowrap table-scroll table-px">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Số tháng còn lại</th>
                                    <th>Tên chi nhánh</th>
                                    <th>Tên khách hàng</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Ngày trúng thầu</th>
                                    <th>Ngày bắt đầu</th>
                                    <th>Ngày kết thúc</th>
                                    <th>Số tháng còn thầu</th>
                                    <th>Số lượng thầu</th>
                                    <th>Tiền thầu</th>
                                    <th>Số tồn thầu</th>
                                    <th>Tiền tồn thầu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(ds_tonthaus, index) in ds_tonthau" :key="index">
                                    <td>{{ ds_tonthaus.thang_conlai }}</td>
                                    <td>{{ ds_tonthaus.ten_chinhanh }}</td>
                                    <td>{{ ds_tonthaus.ten_nv }}</td>
                                    <td>{{ ds_tonthaus.ten_vt }}</td>
                                    <td>{{ ds_tonthaus.ngay_trung_thau }}</td>
                                    <td>{{ ds_tonthaus.ngay_trung_thau }}</td>
                                    <td>{{ ds_tonthaus.ngay_th_hd }}</td>
                                    <td>{{ ds_tonthaus.ngay_kt_hd }}</td>
                                    <td>{{ formatNumber(ds_tonthaus.slThau) }}</td>
                                    <td>{{ formatNumber(ds_tonthaus.tienThau) }}</td>
                                    <td>{{ formatNumber(ds_tonthaus.slTonThau) }}</td>
                                    <td>{{ formatNumber(ds_tonthaus.tienTonThau) }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
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
        const ds_nhanvien = ref('');
        const ds_vattu = ref([]);
        const globalState = inject('globalState');
        const baseApi = globalState.baseApi;
        const selectedCompany = ref('002');
        const filterInventory = ref([]);
        const selectedVt = ref('');
        const selectedDate = ref('');
        const selectedDateEnd = ref('');
        const selectedCustomer = ref('');
        const ds_khachhang = ref('');
        const ds_hinhthucxem = ref('');
        const selectDatetime = ref('');
        const ds_maubaocao = ref('');
        const ds_thautheothang = ref('');
        const chartCanvas = ref(null);
        const chartInstance = ref(null);
        let dsCtbanhangData = [];
        let dstonthau = [];
        const ds_thautheochinhanh = ref('');
        const ds_thautheonkh = ref('');
        const ds_thautheonsp = ref('');
        const ds_thautheonhanvien = ref('');
        const ds_thautheokhachhang = ref('');
        const ds_thautheosanpham = ref('');
        const ds_tonthau = ref('');
        const ds_thauchung = ref('');
        const isLoading = ref(false);
        const tokenApi = localStorage.getItem('tokensApi');
        const getAutoComplete = async () => {
            const axiosConfig = {
                headers: {
                    Authorization: `Bearer ${tokenApi}`,
                    'Content-Type': 'application/json; charset=utf-8',
                    'API': 'True'
                },
            };
            try {
                const response = await axios.get(`${baseApi}/report/tongquan/thau-autocomplete`, axiosConfig);
                company.value = response.data.ds_congty;
                ds_khachhang.value = response.data.ds_khachhang;
                ds_hinhthucxem.value = response.data.ds_hinhthucxem;
                ds_nhanvien.value = response.data.ds_nhanvien;
                ds_maubaocao.value = response.data.ds_maubaocao;
                ds_vattu.value = response.data.ds_vattu;
                getInventory();
            } catch (error) {
                console.log("ERROR : getAutoComplete")
                console.log(error);
            }
        };
        const formatNumber = (value) => {
            if (value !== undefined && value !== null) {
                return value.toLocaleString();
            } else {
                return '';
            }
        };
        const getInventory = () => {
            const axiosConfig = {
                headers: {
                    Authorization: `Bearer ${tokenApi}`,
                    'Content-Type': 'application/json; charset=utf-8',
                    'API': 'True'
                },
            };
            const params = {
                list_cty: selectedCompany.value,
                tungay: selectedDate.value,
                denngay: selectedDateEnd.value,
            };
            if (selectedVt.value) {
                params.ma_vt = selectedVt.value;
            }
            isLoading.value = true;
            axios
                .get(`${baseApi}/report/tongquan/thau`, {
                    params: params,
                    ...axiosConfig,
                })
                .then((response) => {
                    isLoading.value = false;
                    ds_thautheothang.value = response.data.ds_thautheothang;
                    ds_thautheochinhanh.value = response.data.ds_thautheochinhanh;
                    ds_thautheonkh.value = response.data.ds_thautheonkh;
                    ds_thautheonsp.value = response.data.ds_thautheonsp;
                    ds_thautheonhanvien.value = response.data.ds_thautheonhanvien;
                    ds_thautheokhachhang.value = response.data.ds_thautheokhachhang;
                    ds_thautheosanpham.value = response.data.ds_thautheosanpham;
                    ds_tonthau.value = response.data.ds_tonthau;
                    ds_thauchung.value = response.data.ds_thauchung
                })
                .catch((error) => {
                    isLoading.value = false;
                    console.log(error);
                });
        };
        const drawChart = () => {
            if (!chartCanvas.value || !ds_thautheothang.value) return;
            const ctx = chartCanvas.value.getContext('2d');
            const labels = ds_thautheothang.value.map(item => item.ten);
            const giatri_moithau = ds_thautheothang.value.map(item => item.giatri_moithau);
            const giatri_trungthau = ds_thautheothang.value.map(item => item.giatri_trungthau);
            const giatri_thau = ds_thautheothang.value.map(item => item.giatri_thau);
            const giatri_thuchien = ds_thautheothang.value.map(item => item.giatri_thuchien);
            const giatri_tonthau = ds_thautheothang.value.map(item => item.giatri_tonthau);
            const giatri_bothau = ds_thautheothang.value.map(item => item.giatri_bothau);
            const data = {
                labels: labels,
                datasets: [{
                        label: 'Gía trị mời thầu',
                        backgroundColor: '#FFCE56',
                        data: giatri_moithau,
                    },
                    {
                        label: 'Gía trị trúng thầu',
                        backgroundColor: '#FF6384',
                        data: giatri_trungthau,
                    },
                    {
                        label: 'Gía trị thầu',
                        backgroundColor: '#36A2EB',
                        data: giatri_thau,
                    },
                    {
                        label: 'Gía trị thực hiện',
                        backgroundColor: '#4BC0C0',
                        data: giatri_thuchien,
                    },
                    {
                        label: 'Gía trị tồn thầu',
                        backgroundColor: '#9966FF',
                        data: giatri_tonthau,
                    },
                    {
                        label: 'Gía trị bỏ thầu',
                        backgroundColor: '#FF9F40',
                        data: giatri_bothau,
                    },
                ],
            };
            try {
                if (chartInstance.value) {
                    chartInstance.value.destroy();
                }
                chartInstance.value = new Chart(ctx, {
                    type: 'bar',
                    data: data,
                    options: {
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true,
                                },
                            }],
                        },
                        tooltips: {
                            mode: 'index',
                            intersect: false,
                        },
                    },
                });
            } catch (error) {
                console.error('Error creating the chart:', error);
            }
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
        onMounted(() => {
            getAutoComplete();
            getInventory();
            getCurrentYearDates();
            drawChart();
        });
        watchEffect(() => {
            drawChart();
        });

        return {
            isLoading,
            getInventory,
            company,
            selectedCompany,
            selectedVt,
            selectedDate,
            ds_nhanvien,
            ds_vattu,
            filterInventory,
            ds_khachhang,
            selectedCustomer,
            ds_hinhthucxem,
            selectDatetime,
            selectedUser,
            ds_maubaocao,
            ds_thautheothang,
            chartCanvas,
            selectedDateEnd,
            chartInstance,
            ds_thautheochinhanh,
            ds_thautheonkh,
            ds_thautheonsp,
            ds_thautheonhanvien,
            ds_thautheokhachhang,
            ds_thautheosanpham,
            ds_tonthau,
            ds_thauchung,
            formatNumber,
        };
    }
};
</script>
