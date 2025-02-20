<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Tổng quan marketing <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách</h4>
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
                <div class="table-responsive text-nowrap scroll table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Chi nhánh</th>
                                <th>SL KH Bán</th>
                                <th>TT năm trước</th>
                                <th>Tỷ lệ đạt KH(SL)</th>
                                <th>DS KH bán</th>
                                <th>TT năm trước</th>
                                <th>Tỷ lệ đạt kh(ds)</th>
                                <th>CP kế hoạch MKT</th>
                                <th>CP MKT Thực có</th>
                                <th>CP MKT quyết toán</th>
                                <th>Tỷ lệ sử dụng CP MKT so với KH</th>
                                <th>CP KH THẦU</th>
                                <th>CP thầu thực có</th>
                                <th>CP thầu quyết toán</th>
                                <th>Tỷ lệ quyết toán Cp thầu với Kh</th>
                                <th>Giá trị trúng thầu</th>
                                <th>Giá trị thực hiện</th>
                                <th>Tỷ lệ đạt Kh</th>
                                <th>Giá trị tồn thầu </th>
                                <th>Giá trị bỏ thầu </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_marketingtheochinhanhcaps, index) in ds_marketingtheochinhanhcap" :key="index">
                                <td>{{ ds_marketingtheochinhanhcaps.ten}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.soluong_khban)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.tangtruong_slnamtruoc)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.tile_soluongkhdat)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.doanhso_khban)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.tangtruong_dsnamtruoc)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.tile_doanhsokhdat)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.chiphi_kehoachmkt)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.chiphi_mktthucco)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.chiphi_mktdaquyettoan)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.tile_quyettoancpmktsovoikh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.chiphi_khthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.chiphi_thauthucco)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.chiphi_thauquyettoan)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.tile_quyettoancpthausovoikh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.giatri_trungthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.giatri_thuchien)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.tile_datkh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.giatri_tonthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheochinhanhcaps.giatri_bothau)}}</td>
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
                <div class="table-responsive text-nowrap scroll table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Nhân viên</th>
                                <th>SL KH Bán</th>
                                <th>TT năm trước</th>
                                <th>Tỷ lệ đạt KH(SL)</th>
                                <th>DS KH bán</th>
                                <th>TT năm trước</th>
                                <th>Tỷ lệ đạt kh(ds)</th>
                                <th>CP kế hoạch MKT</th>
                                <th>CP MKT Thực có</th>
                                <th>CP MKT quyết toán</th>
                                <th>Tỷ lệ sử dụng CP MKT so với KH</th>
                                <th>CP KH THẦU</th>
                                <th>CP thầu thực có</th>
                                <th>CP thầu quyết toán</th>
                                <th>Tỷ lệ quyết toán Cp thầu với Kh</th>
                                <th>Giá trị trúng thầu</th>
                                <th>Giá trị thực hiện</th>
                                <th>Tỷ lệ đạt Kh</th>
                                <th>Giá trị tồn thầu </th>
                                <th>Giá trị bỏ thầu </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_marketingtheonhanviens, index) in ds_marketingtheonhanvien" :key="index">
                                <td>{{ ds_marketingtheonhanviens.ten}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.soluong_khban)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.tangtruong_slnamtruoc)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.tile_soluongkhdat)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.doanhso_khban)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.tangtruong_dsnamtruoc)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.tile_doanhsokhdat)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.chiphi_kehoachmkt)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.chiphi_mktthucco)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.chiphi_mktdaquyettoan)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.tile_quyettoancpmktsovoikh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.chiphi_khthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.chiphi_thauthucco)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.chiphi_thauquyettoan)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.tile_quyettoancpthausovoikh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.giatri_trungthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.giatri_thuchien)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.tile_datkh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.giatri_tonthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonhanviens.giatri_bothau)}}</td>
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
                <div class="table-responsive text-nowrap scroll table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Tên khách hàng</th>
                                <th>SL KH Bán</th>
                                <th>TT năm trước</th>
                                <th>Tỷ lệ đạt KH(SL)</th>
                                <th>DS KH bán</th>
                                <th>TT năm trước</th>
                                <th>Tỷ lệ đạt kh(ds)</th>
                                <th>CP kế hoạch MKT</th>
                                <th>CP MKT Thực có</th>
                                <th>CP MKT quyết toán</th>
                                <th>Tỷ lệ sử dụng CP MKT so với KH</th>
                                <th>CP KH THẦU</th>
                                <th>CP thầu thực có</th>
                                <th>CP thầu quyết toán</th>
                                <th>Tỷ lệ quyết toán Cp thầu với Kh</th>
                                <th>Giá trị trúng thầu</th>
                                <th>Giá trị thực hiện</th>
                                <th>Tỷ lệ đạt Kh</th>
                                <th>Giá trị tồn thầu </th>
                                <th>Giá trị bỏ thầu </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_marketingtheokhachhangs, index) in ds_marketingtheokhachhang" :key="index">
                                <td>{{ ds_marketingtheokhachhangs.ten}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.soluong_khban)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.tangtruong_slnamtruoc)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.tile_soluongkhdat)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.doanhso_khban)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.tangtruong_dsnamtruoc)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.tile_doanhsokhdat)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.chiphi_kehoachmkt)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.chiphi_mktthucco)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.chiphi_mktdaquyettoan)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.tile_quyettoancpmktsovoikh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.chiphi_khthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.chiphi_thauthucco)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.chiphi_thauquyettoan)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.tile_quyettoancpthausovoikh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.giatri_trungthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.giatri_thuchien)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.tile_datkh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.giatri_tonthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheokhachhangs.giatri_bothau)}}</td>
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
                <div class="table-responsive text-nowrap scroll table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Tên khách hàng</th>
                                <th>SL KH Bán</th>
                                <th>TT năm trước</th>
                                <th>Tỷ lệ đạt KH(SL)</th>
                                <th>DS KH bán</th>
                                <th>TT năm trước</th>
                                <th>Tỷ lệ đạt kh(ds)</th>
                                <th>CP kế hoạch MKT</th>
                                <th>CP MKT Thực có</th>
                                <th>CP MKT quyết toán</th>
                                <th>Tỷ lệ sử dụng CP MKT so với KH</th>
                                <th>CP KH THẦU</th>
                                <th>CP thầu thực có</th>
                                <th>CP thầu quyết toán</th>
                                <th>Tỷ lệ quyết toán Cp thầu với Kh</th>
                                <th>Giá trị trúng thầu</th>
                                <th>Giá trị thực hiện</th>
                                <th>Tỷ lệ đạt Kh</th>
                                <th>Giá trị tồn thầu </th>
                                <th>Giá trị bỏ thầu </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_marketingtheonkhs, index) in ds_marketingtheonkh" :key="index">
                                <td>{{ ds_marketingtheonkhs.ten}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.soluong_khban)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.tangtruong_slnamtruoc)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.tile_soluongkhdat)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.doanhso_khban)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.tangtruong_dsnamtruoc)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.tile_doanhsokhdat)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.chiphi_kehoachmkt)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.chiphi_mktthucco)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.chiphi_mktdaquyettoan)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.tile_quyettoancpmktsovoikh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.chiphi_khthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.chiphi_thauthucco)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.chiphi_thauquyettoan)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.tile_quyettoancpthausovoikh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.giatri_trungthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.giatri_thuchien)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.tile_datkh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.giatri_tonthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonkhs.giatri_bothau)}}</td>
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
                <div class="table-responsive text-nowrap scroll table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Tên nhóm sản phẩm</th>
                                <th>SL KH Bán</th>
                                <th>TT năm trước</th>
                                <th>Tỷ lệ đạt KH(SL)</th>
                                <th>DS KH bán</th>
                                <th>TT năm trước</th>
                                <th>Tỷ lệ đạt kh(ds)</th>
                                <th>CP kế hoạch MKT</th>
                                <th>CP MKT Thực có</th>
                                <th>CP MKT quyết toán</th>
                                <th>Tỷ lệ sử dụng CP MKT so với KH</th>
                                <th>CP KH THẦU</th>
                                <th>CP thầu thực có</th>
                                <th>CP thầu quyết toán</th>
                                <th>Tỷ lệ quyết toán Cp thầu với Kh</th>
                                <th>Giá trị trúng thầu</th>
                                <th>Giá trị thực hiện</th>
                                <th>Tỷ lệ đạt Kh</th>
                                <th>Giá trị tồn thầu </th>
                                <th>Giá trị bỏ thầu </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_marketingtheonsps, index) in ds_marketingtheonsp" :key="index">
                                <td>{{ ds_marketingtheonsps.ten}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.soluong_khban)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.tangtruong_slnamtruoc)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.tile_soluongkhdat)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.doanhso_khban)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.tangtruong_dsnamtruoc)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.tile_doanhsokhdat)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.chiphi_kehoachmkt)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.chiphi_mktthucco)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.chiphi_mktdaquyettoan)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.tile_quyettoancpmktsovoikh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.chiphi_khthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.chiphi_thauthucco)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.chiphi_thauquyettoan)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.tile_quyettoancpthausovoikh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.giatri_trungthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.giatri_thuchien)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.tile_datkh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.giatri_tonthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheonsps.giatri_bothau)}}</td>
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
                <div class="table-responsive text-nowrap scroll table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Tên sản phẩm</th>
                                <th>SL KH Bán</th>
                                <th>TT năm trước</th>
                                <th>Tỷ lệ đạt KH(SL)</th>
                                <th>DS KH bán</th>
                                <th>TT năm trước</th>
                                <th>Tỷ lệ đạt kh(ds)</th>
                                <th>CP kế hoạch MKT</th>
                                <th>CP MKT Thực có</th>
                                <th>CP MKT quyết toán</th>
                                <th>Tỷ lệ sử dụng CP MKT so với KH</th>
                                <th>CP KH THẦU</th>
                                <th>CP thầu thực có</th>
                                <th>CP thầu quyết toán</th>
                                <th>Tỷ lệ quyết toán Cp thầu với Kh</th>
                                <th>Giá trị trúng thầu</th>
                                <th>Giá trị thực hiện</th>
                                <th>Tỷ lệ đạt Kh</th>
                                <th>Giá trị tồn thầu </th>
                                <th>Giá trị bỏ thầu </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_marketingtheosanphams, index) in ds_marketingtheosanpham" :key="index">
                                <td>{{ ds_marketingtheosanphams.ten}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.soluong_khban)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.tangtruong_slnamtruoc)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.tile_soluongkhdat)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.doanhso_khban)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.tangtruong_dsnamtruoc)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.tile_doanhsokhdat)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.chiphi_kehoachmkt)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.chiphi_mktthucco)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.chiphi_mktdaquyettoan)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.tile_quyettoancpmktsovoikh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.chiphi_khthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.chiphi_thauthucco)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.chiphi_thauquyettoan)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.tile_quyettoancpthausovoikh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.giatri_trungthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.giatri_thuchien)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.tile_datkh)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.giatri_tonthau)}}</td>
                                <td>{{ formatNumber(ds_marketingtheosanphams.giatri_bothau)}}</td>
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
        const ds_nhanvien = ref('');
        const ds_vattu = ref([]);
        const globalState = inject('globalState');
        const baseApi = globalState.baseApi;
        const selectedCompany = ref('002');
        const ds_marketingchung = ref([]);
        const selectedVt = ref('');
        const selectedCustomer = ref('');
        const ds_khachhang = ref('');
        const ds_hinhthucxem = ref('');
        const selectDatetime = ref('2');
        const ds_maubaocao = ref('');
        const ds_marketingtheothang = ref('');
        const selectedDate = ref('');
        const selectedDateEnd = ref('');
        const selectedMbC = ref('');
        const ds_marketingtheochinhanh = ref('');
        const ds_marketingtheonhanvien = ref('');
        const ds_marketingtheonkh = ref('');
        const ds_marketingtheochinhanhcap = ref('');
        const ds_marketingtheokhachhang = ref('');
        const ds_marketingtheosanpham = ref('');
        const ds_marketingtheonsp = ref('');
        const chartCanvas = ref(null);
        const isLoading = ref(false);
        const chartData = ref('[]');
        const selectedCN = ref('');
        let dsCtbanhangData = [];
        let dstonthau = [];
        const tokenApi = localStorage.getItem('tokensApi');
        const chartInstance = ref(null);
        const getAutoComplete = () => {
            const axiosConfig = {
                headers: {
                    Authorization: `Bearer ${tokenApi}`,
                    'Content-Type': 'application/json; charset=utf-8',
                    'API': 'True'
                },
            };
            axios
                .get(`${baseApi}/report/tongquan/banhang-autocomplete`, axiosConfig)
                .then((response) => {
                    company.value = response.data.ds_congty;
                    ds_khachhang.value = response.data.ds_khachhang;
                    ds_hinhthucxem.value = response.data.ds_hinhthucxem;
                    ds_maubaocao.value = response.data.ds_maubaocao;
                    ds_vattu.value = response.data.ds_vattu;
                    getInventory();
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        const formatNumber = (value) => {
            if (value !== undefined && value !== null) {
                return new Intl.NumberFormat('vi-VN').format(value);
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
            isLoading.value = true;
            const params = {
                list_cty: selectedCompany.value,
                tungay: selectedDate.value,
                denngay: selectedDateEnd.value,
            };
            if (selectedUser.value) {
                params.ma_nhanvien = selectedUser.value;
            }
            if (selectedCustomer.value) {
                params.ma_khachhang = selectedCustomer.value;
            }
            if (selectedVt.value) {
                params.ma_vt = selectedVt.value;
            }
            if (selectedCN.value) {
                params.ma_chinhanh = selectedCN.value;
            }
            axios
                .get(`${baseApi}/report/tongquan/marketing`, {
                    params: params,
                    ...axiosConfig
                })
                .then((response) => {
                    ds_marketingchung.value = response.data.ds_marketingchung;
                    ds_marketingtheothang.value = response.data.ds_marketingtheothang;
                    ds_marketingtheonhanvien.value = response.data.ds_marketingtheonhanvien;
                    ds_marketingtheonkh.value = response.data.ds_marketingtheonkh;
                    ds_marketingtheokhachhang.value = response.data.ds_marketingtheokhachhang;
                    ds_marketingtheonsp.value = response.data.ds_marketingtheonsp;
                    ds_marketingtheosanpham.value = response.data.ds_marketingtheosanpham;
                    ds_marketingtheochinhanhcap.value = response.data.ds_marketingtheochinhanh;
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
            if (!chartCanvas.value || !ds_marketingtheothang.value) return;
            const ctx = chartCanvas.value.getContext('2d');
            const labels = ds_marketingtheothang.value.map(item => item.thang);
            const kehoachbanhang = ds_marketingtheothang.value.map(item => item.kehoachbanhang);
            const chiphi_mktdaquyettoan = ds_marketingtheothang.value.map(item => item.chiphi_mktdaquyettoan);
            const chiphi_thaudaquyettoan = ds_marketingtheothang.value.map(item => item.chiphi_thaudaquyettoan);
            const giatri_trungthau = ds_marketingtheothang.value.map(item => item.giatri_trungthau);
            const giatri_thuchien = ds_marketingtheothang.value.map(item => item.giatri_thuchien);
            const giatri_bothau = ds_marketingtheothang.value.map(item => item.giatri_bothau);
            const data = {
                labels: labels,
                datasets: [{
                        label: 'Gía trị kế hoạch bán hàng',
                        backgroundColor: '#FFCE56',
                        data: kehoachbanhang,
                    },
                    {
                        label: 'CP MKT đã QT',
                        backgroundColor: '#FF6384',
                        data: chiphi_mktdaquyettoan,
                    },
                    {
                        label: 'CP thầu đã QT',
                        backgroundColor: '#36A2EB',
                        data: chiphi_thaudaquyettoan,
                    },
                    {
                        label: 'Gía trị trúng thầu',
                        backgroundColor: '#4BC0C0',
                        data: giatri_trungthau,
                    },
                    {
                        label: 'Gía trị thực hiện',
                        backgroundColor: '#9966FF',
                        data: giatri_thuchien,
                    },
                    {
                        label: 'Gía trị tồn thầu',
                        backgroundColor: '#FF9F40',
                        data: giatri_bothau,
                    },
                ],

            };
            new Chart(ctx, {
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
        };
        onMounted(() => {
            getAutoComplete();
            getInventory();
            getCurrentYearDates();
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
            ds_maubaocao,
            ds_marketingchung,
            selectedDateEnd,
            selectedMbC,
            ds_marketingtheothang,
            chartInstance,
            chartCanvas,
            selectedCN,
            isLoading,
            ds_marketingtheonhanvien,
            ds_marketingtheonkh,
            ds_marketingtheokhachhang,
            ds_marketingtheonsp,
            ds_marketingtheosanpham,
            ds_marketingtheochinhanhcap,
            getInventory,
            formatNumber
        };
    }
};
</script>
