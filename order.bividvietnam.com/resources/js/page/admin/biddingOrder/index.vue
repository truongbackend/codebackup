<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Tổng quan bán hàng (theo chi nhánh và sản phẩm) <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách</h4>
<div class="card">
    <div class="card-body">
        <div class="row">
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Công ty</label>
                <model-list-select :list="company" v-model="selectedCompany" option-value="ma_cty" option-text="ten_cty" placeholder="Chọn công ty"></model-list-select>
            </div>
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">khách hàng</label>
                <model-list-select :list="ds_khachhang" v-model="selectedCustomer" option-value="ma_kh" option-text="ten_kh" placeholder="Chọn khách hàng"></model-list-select>
            </div>
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Nhân viên</label>
                <model-list-select :list="ds_nhanvien" v-model="selectedUser" option-value="ma_kh" option-text="ten_kh" placeholder="Chọn nhân viên"></model-list-select>
            </div>
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Mẫu báo cáo</label>
                <select v-model="selectedMbC" @change="filterByCustomer" class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                    <option value>Chọn mẫu báo cáo</option>
                    <option v-for="ds_maubaocaos in ds_maubaocao" :value="ds_maubaocaos.ma_mau" :key="ds_maubaocaos.ma_mau">
                        {{ ds_maubaocaos.ten_mau }}
                    </option>
                </select>
            </div>
        </div>
        <div class="row mt-3">
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Hình thức</label>
                <select v-model="selectDatetime" @change="filterByCustomer" class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                    <option value>Chọn hình thức</option>
                    <option v-for="ds_hinhthucxems in ds_hinhthucxem" :value="ds_hinhthucxems.ma_hinhthuc" :key="ds_hinhthucxems.ma_hinhthuc">{{ ds_hinhthucxems.ten_hinhthuc }}</option>
                </select>
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
<div class="row ">
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Kế hoạch năm nay</span>
                <h6 class="card-title mb-2">{{ formatNumber(doanhthu_chung.doanhso_kehoach)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Số lượng năm nay</span>
                <h6 class="card-title mb-2">{{ formatNumber(doanhthu_chung.soluong_namnay)}} </h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">DT năm trước</span>
                <h6 class="card-title mb-2">{{ formatNumber(doanhthu_chung.doanhso_namtruoc)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Tỉ lệ đạt được</span>
                <h6 class="card-title mb-2">{{ formatNumber(doanhthu_chung.tile_datduoc)}} %</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Số lượng cùng kỳ</span>
                <h6 class="card-title mb-2">{{ formatNumber(doanhthu_chung.soluong_cungky)}} </h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">DT cùng kỳ</span>
                <h6 class="card-title mb-2">{{ formatNumber(doanhthu_chung.doanhso_cungky)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Tăng trưởng cùng kỳ</span>
                <h6 class="card-title mb-2">{{ formatNumber(doanhthu_chung.tt_cungky)}} %</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">SL tặng và kiểm nghiệm</span>
                <h6 class="card-title mb-2">{{ formatNumber(doanhthu_chung.sl_tientang_kiemnghiem)}} </h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Tiền tặng và kiểm nghiệm</span>
                <h6 class="card-title mb-2">{{ formatNumber(doanhthu_chung.tientang_kiemnghiem)}} đ</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Danh thu năm trước</span>
                <h6 class="card-title mb-2">{{ formatNumber(doanhthu_chung.doanhso_namtruoc)}} %</h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">SL năm trước</span>
                <h6 class="card-title mb-2">{{ formatNumber(doanhthu_chung.soluong_namtruoc)}} </h6>
            </div>
        </div>
    </div>
    <div class="col-sm-2 col-md-2 mt-3">
        <div class="card">
            <div class="card-body"><span class="fw-semibold d-block mb-1">Tăng trưởng</span>
                <h6 class="card-title mb-2">{{ formatNumber(doanhthu_chung.tang_truong)}} %</h6>
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
                <h5 class="card-title m-0">Theo loại</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap scroll table-scroll table-px table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Loại</th>
                                <th>SL kế hoạch</th>
                                <th>Tiền kế hoạch</th>
                                <th>SL năm nay</th>
                                <th>Ds năm nay</th>
                                <th>TL đạt</th>
                                <th>Tiền tặng và kiểm nghiệm</th>
                                <th>Sl cùng kỳ</th>
                                <th>Ds cùng kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>SL Năm trước</th>
                                <th>Ds năm trước</th>
                                <th>Tăng trưởng</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(doanhthu_theoloais, index) in doanhthu_theoloai" :key="index">
                                <td>{{ doanhthu_theoloais.ten }}</td>
                                <td>{{ formatNumber(doanhthu_theoloais.soluong_kehoach) }}</td>
                                <td>{{ formatNumber(doanhthu_theoloais.doanhso_kehoach) }}</td>
                                <td>{{ formatNumber(doanhthu_theoloais.soluong_namnay) }}</td>
                                <td>{{ formatNumber(doanhthu_theoloais.doanhso_namnay) }}</td>
                                <td>{{ formatNumber(doanhthu_theoloais.tile_datduoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theoloais.tientang_kiemnghiem) }}</td>
                                <td>{{ formatNumber(doanhthu_theoloais.soluong_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theoloais.doanhso_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theoloais.tt_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theoloais.soluong_namtruoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theoloais.doanhso_namtruoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theoloais.tang_truong) }}</td>
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
                <h5 class="card-title m-0">Danh sách theo chi nhánh</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap table-scroll table-px table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Chi nhánh</th>
                                <th>SL kế hoạch</th>
                                <th>Tiền kế hoạch</th>
                                <th>SL năm nay</th>
                                <th>DS năm nay</th>
                                <th>TL đạt</th>
                                <th>Tiền tặng và kiểm nghiệm</th>
                                <th>Sl cùng kỳ</th>
                                <th>Ds cùng kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>SL Năm trước</th>
                                <th>Ds năm trước</th>
                                <th>Tăng trưởng</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(doanhthu_theochinhanhs, index) in doanhthu_theochinhanh" :key="index">
                                <td>{{ doanhthu_theochinhanhs.ten }}</td>
                                <td>{{ formatNumber(doanhthu_theochinhanhs.soluong_kehoach) }}</td>
                                <td>{{ formatNumber(doanhthu_theochinhanhs.doanhso_kehoach) }}</td>
                                <td>{{ formatNumber(doanhthu_theochinhanhs.soluong_namnay) }}</td>
                                <td>{{ formatNumber(doanhthu_theochinhanhs.doanhso_namnay) }}</td>
                                <td>{{ formatNumber(doanhthu_theochinhanhs.tile_datduoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theochinhanhs.tientang_kiemnghiem) }}</td>
                                <td>{{ formatNumber(doanhthu_theochinhanhs.soluong_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theochinhanhs.doanhso_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theochinhanhs.tt_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theochinhanhs.soluong_namtruoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theochinhanhs.doanhso_namtruoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theochinhanhs.tang_truong) }}</td>
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
                <h5 class="card-title m-0">Doanh số theo nhà sản xuất</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap scroll table-scroll table-px table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Tên nhà sản phẩm</th>
                                <th>SL kế hoạch </th>
                                <th>Tiền kế hoạch </th>
                                <th>SL NĂM NAY</th>
                                <th>DS NĂM NAY</th>
                                <th>TL ĐẠT</th>
                                <th>TIỀN TẶNG VÀ KIỂM NGHIỆM</th>
                                <th>SL CÙNG KỲ</th>
                                <th>DS CÙNG KỲ</th>
                                <th>TT CÙNG KỲ</th>
                                <th>SL NĂM TRƯỚC</th>
                                <th>DS NĂM TRƯỚC</th>
                                <th>TĂNG TRƯỞNG</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(doanhthu_theonsxs, index) in doanhthu_theonsx" :key="index">
                                <td>{{ doanhthu_theonsxs.ten }}</td>
                                <td>{{ formatNumber(doanhthu_theonsxs.soluong_kehoach) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsxs.doanhso_kehoach) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsxs.soluong_namnay) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsxs.doanhso_namnay) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsxs.tile_datduoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsxs.tientang_kiemnghiem) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsxs.soluong_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsxs.doanhso_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsxs.tt_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsxs.soluong_namtruoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsxs.doanhso_namtruoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsxs.tang_truong) }}</td>
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
                <h5 class="card-title m-0">Doanh số theo kênh</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap table-scroll table-px table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Loại</th>
                                <th>SL kế hoạch</th>
                                <th>Tiền kế hoạch</th>
                                <th>SL năm nay</th>
                                <th>DS năm nay</th>
                                <th>TL đạt</th>
                                <th>Tiền tặng và kiểm nghiệm</th>
                                <th>Sl cùng kỳ</th>
                                <th>Ds cùng kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>SL Năm trước</th>
                                <th>Ds năm trước</th>
                                <th>Tăng trưởng</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(doanhthu_theonkhs, index) in doanhthu_theonkh" :key="index">
                                <td>{{ doanhthu_theonkhs.ten }}</td>
                                <td>{{ formatNumber(doanhthu_theonkhs.soluong_kehoach) }}</td>
                                <td>{{ formatNumber(doanhthu_theonkhs.doanhso_kehoach) }}</td>
                                <td>{{ formatNumber(doanhthu_theonkhs.soluong_namnay) }}</td>
                                <td>{{ formatNumber(doanhthu_theonkhs.doanhso_namnay) }}</td>
                                <td>{{ formatNumber(doanhthu_theonkhs.tile_datduoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theonkhs.tientang_kiemnghiem) }}</td>
                                <td>{{ formatNumber(doanhthu_theonkhs.soluong_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theonkhs.doanhso_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theonkhs.tt_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theonkhs.soluong_namtruoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theonkhs.doanhso_namtruoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theonkhs.tang_truong) }}</td>
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
            <div class="card-header justify-content-between text-center ">
                <h5 class="card-title m-0">Doanh số theo sản phẩm</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap table-scroll table-px table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>nhóm khách hàng</th>
                                <th>SL kế hoạch</th>
                                <th>Tiền kế hoạch</th>
                                <th>SL năm nay</th>
                                <th>DS năm nay</th>
                                <th>TL đạt</th>
                                <th>Tiền tặng và kiểm nghiệm</th>
                                <th>Sl cùng kỳ</th>
                                <th>Ds cùng kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>SL Năm trước</th>
                                <th>Ds năm trước</th>
                                <th>Tăng trưởng</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(doanhthu_theonsps, index) in doanhthu_theonsp" :key="index">
                               <td>{{ doanhthu_theonsps.ten }}</td>
                                <td>{{ formatNumber(doanhthu_theonsps.soluong_kehoach) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsps.doanhso_kehoach) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsps.soluong_namnay) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsps.doanhso_namnay) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsps.tile_datduoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsps.tientang_kiemnghiem) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsps.soluong_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsps.doanhso_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsps.tt_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsps.soluong_namtruoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsps.doanhso_namtruoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theonsps.tang_truong) }}</td>
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
                <h5 class="card-title m-0">Doanh số theo nhóm sản phẩm</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap table-scroll table-px table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Tên nhóm sản phẩm</th>
                                <th>SL kế hoạch </th>
                                <th>Tiền kế hoạch </th>
                                <th>SL NĂM NAY</th>
                                <th>DS NĂM NAY</th>
                                <th>TL ĐẠT</th>
                                <th>TIỀN TẶNG VÀ KIỂM NGHIỆM</th>
                                <th>SL CÙNG KỲ</th>
                                <th>DS CÙNG KỲ</th>
                                <th>TT CÙNG KỲ</th>
                                <th>SL NĂM TRƯỚC</th>
                                <th>DS NĂM TRƯỚC</th>
                                <th>TĂNG TRƯỞNG</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(doanhthu_theonhanviens, index) in doanhthu_theonhanvien" :key="index">
                                <td>{{ doanhthu_theonhanviens.ten }}</td>
                                <td>{{ formatNumber(doanhthu_theonhanviens.soluong_kehoach) }}</td>
                                <td>{{ formatNumber(doanhthu_theonhanviens.doanhso_kehoach) }}</td>
                                <td>{{ formatNumber(doanhthu_theonhanviens.soluong_namnay) }}</td>
                                <td>{{ formatNumber(doanhthu_theonhanviens.doanhso_namnay) }}</td>
                                <td>{{ formatNumber(doanhthu_theonhanviens.tile_datduoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theonhanviens.tientang_kiemnghiem) }}</td>
                                <td>{{ formatNumber(doanhthu_theonhanviens.soluong_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theonhanviens.doanhso_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theonhanviens.tt_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theonhanviens.soluong_namtruoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theonhanviens.doanhso_namtruoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theonhanviens.tang_truong) }}</td>
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
                <h5 class="card-title m-0">Doanh số khách hàng</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap table-scroll table-px table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>khách hàng</th>
                                <th>SL kế hoạch</th>
                                <th>Tiền kế hoạch</th>
                                <th>SL năm nay</th>
                                <th>DS năm nay</th>
                                <th>TL đạt</th>
                                <th>Tiền tặng và kiểm nghiệm</th>
                                <th>Sl cùng kỳ</th>
                                <th>Ds cùng kỳ</th>
                                <th>TT cùng kỳ</th>
                                <th>SL Năm trước</th>
                                <th>Ds năm trước</th>
                                <th>Tăng trưởng</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(doanhthu_theokhachangs, index) in doanhthu_theokhachang" :key="index">
                                <td>{{ doanhthu_theokhachangs.ten }}</td>
                                <td>{{ formatNumber(doanhthu_theokhachangs.soluong_kehoach) }}</td>
                                <td>{{ formatNumber(doanhthu_theokhachangs.doanhso_kehoach) }}</td>
                                <td>{{ formatNumber(doanhthu_theokhachangs.soluong_namnay) }}</td>
                                <td>{{ formatNumber(doanhthu_theokhachangs.doanhso_namnay) }}</td>
                                <td>{{ formatNumber(doanhthu_theokhachangs.tile_datduoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theokhachangs.tientang_kiemnghiem) }}</td>
                                <td>{{ formatNumber(doanhthu_theokhachangs.soluong_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theokhachangs.doanhso_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theokhachangs.tt_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theokhachangs.soluong_namtruoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theokhachangs.doanhso_namtruoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theokhachangs.tang_truong) }}</td>
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
                <h5 class="card-title m-0">Doanh số theo sản phẩm</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap table-scroll table-px table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>sản phẩm</th>
                                <th>SL kế hoạch </th>
                                <th>Tiền kế hoạch </th>
                                <th>SL NĂM NAY</th>
                                <th>DS NĂM NAY</th>
                                <th>TL ĐẠT</th>
                                <th>TIỀN TẶNG VÀ KIỂM NGHIỆM</th>
                                <th>SL CÙNG KỲ</th>
                                <th>DS CÙNG KỲ</th>
                                <th>TT CÙNG KỲ</th>
                                <th>SL NĂM TRƯỚC</th>
                                <th>DS NĂM TRƯỚC</th>
                                <th>TĂNG TRƯỞNG</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(doanhthu_theosanphams, index) in doanhthu_theosanpham" :key="index">
                                <td>{{ doanhthu_theosanphams.ten }}</td>
                                <td>{{ formatNumber(doanhthu_theosanphams.soluong_kehoach) }}</td>
                                <td>{{ formatNumber(doanhthu_theosanphams.doanhso_kehoach) }}</td>
                                <td>{{ formatNumber(doanhthu_theosanphams.soluong_namnay) }}</td>
                                <td>{{ formatNumber(doanhthu_theosanphams.doanhso_namnay) }}</td>
                                <td>{{ formatNumber(doanhthu_theosanphams.tile_datduoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theosanphams.tientang_kiemnghiem) }}</td>
                                <td>{{ formatNumber(doanhthu_theosanphams.soluong_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theosanphams.doanhso_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theosanphams.tt_cungky) }}</td>
                                <td>{{ formatNumber(doanhthu_theosanphams.soluong_namtruoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theosanphams.doanhso_namtruoc) }}</td>
                                <td>{{ formatNumber(doanhthu_theosanphams.tang_truong) }}</td>
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
        const doanhthu_chung = ref([]);
        const selectedVt = ref('');
        const selectedCustomer = ref([]);
        const ds_khachhang = ref([]);
        const ds_hinhthucxem = ref('');
        const selectDatetime = ref('2');
        const ds_maubaocao = ref('');
        const doanhthu_theohinhthuc = ref('');
        const selectedDate = ref('');
        const selectedDateEnd = ref('');
        const selectedMbC = ref('');
        const doanhthu_theoloai = ref('');
        const doanhthu_theochinhanh = ref('');
        const doanhthu_theonsx = ref('');
        const doanhthu_theokenh = ref('');
        const doanhthu_theonkh = ref('');
        const doanhthu_theonhanvien = ref('');
        const doanhthu_theonsp = ref('');
        const doanhthu_theokhachang = ref('');
        const doanhthu_theosanpham = ref('');
        const chartCanvas = ref(null);
        const isLoading = ref(false);
        const chartData = ref('[]');
        const ds_chinhanh = ref('');
        const selectedCN = ref('');
        let dsCtbanhangData = [];
        let dstonthau = [];
        const chartInstance = ref(null);
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
                .get(`${baseApi}/report/tongquan/banhang-autocomplete`, axiosConfig)
                .then((response) => {
                    company.value = response.data.ds_congty;
                    ds_khachhang.value = response.data.ds_khachhang;
                    ds_hinhthucxem.value = response.data.ds_hinhthucxem;
                    ds_nhanvien.value = response.data.ds_nhanvien;
                    ds_maubaocao.value = response.data.ds_maubaocao;
                    ds_vattu.value = response.data.ds_vattu
                    ds_chinhanh.value = response.data.ds_chinhanh;
                    getInventory();
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
            if (selectDatetime.value) {
                params.ky_phantich = selectDatetime.value;
            }
            if (selectedVt.value) {
                params.ma_vt = selectedVt.value;
            }
            if (selectedCN.value) {
                params.ma_chinhanh = selectedCN.value;
            }
            axios
                .get(`${baseApi}/report/tongquan/banhang-theochinhanh`, {
                    params: params,
                    ...axiosConfig,
                })
                .then((response) => {
                    isLoading.value=false;
                    doanhthu_chung.value = response.data.doanhthu_chung;
                    doanhthu_theohinhthuc.value = response.data.doanhthu_theohinhthuc;
                    doanhthu_theoloai.value = response.data.doanhthu_theoloai;
                    doanhthu_theochinhanh.value = response.data.doanhthu_theochinhanh;
                    doanhthu_theonsx.value = response.data.doanhthu_theonsx;
                    doanhthu_theokenh.value = response.data.doanhthu_theokenh;
                    doanhthu_theonkh.value = response.data.doanhthu_theonkh;
                    doanhthu_theonsp.value = response.data.doanhthu_theonsp;
                    doanhthu_theonhanvien.value = response.data.doanhthu_theonhanvien;
                    doanhthu_theokhachang.value = response.data.doanhthu_theokhachang;
                    doanhthu_theosanpham.value = response.data.doanhthu_theosanpham;
                    drawChart();
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
            const ctx = chartCanvas.value.getContext('2d');
            const labels = doanhthu_theohinhthuc.value.map(item => item.ky_phantich);
            const doanhsoKehoachData = doanhthu_theohinhthuc.value.map(item => item.doanhso_kehoach);
            const doanhsoNamNayData = doanhthu_theohinhthuc.value.map(item => item.doanhso_namnay);
            const soluongNamTruocData = doanhthu_theohinhthuc.value.map(item => item.soluong_namtruoc);
            const data = {
                labels: labels,
                datasets: [{
                        label: 'Kế hoạch năm nay',
                        backgroundColor: '#FF6384',
                        data: doanhsoKehoachData,
                    },
                    {
                        label: 'Doanh số năm nay',
                        backgroundColor: '#36A2EB',
                        data: doanhsoNamNayData,
                    },
                    {
                        label: 'Số lượng năm trước',
                        backgroundColor: '#FFCE56',
                        data: soluongNamTruocData,
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
                        callbacks: {
                            label: function (tooltipItem, data) {
                                const datasetLabel = data.datasets[tooltipItem.datasetIndex].label;
                                const value = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];
                                const kyPhantich = doanhthu_theohinhthuc.value[tooltipItem.index].ky_phantich;
                                console.log(kyPhantich);
                                return `${datasetLabel}: ${value} - Ky Phantich: ${kyPhantich}`;
                            },
                        },
                    },
                },
            });
        };
        onMounted(() => {
            getAutoComplete();
            getInventory();
            getCurrentYearDates();
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
            doanhthu_chung,
            selectedDateEnd,
            selectedMbC,
            doanhthu_theohinhthuc,
            chartInstance,
            doanhthu_theoloai,
            doanhthu_theochinhanh,
            doanhthu_theonsx,
            doanhthu_theokenh,
            doanhthu_theonkh,
            doanhthu_theonhanvien,
            doanhthu_theonsp,
            doanhthu_theokhachang,
            doanhthu_theosanpham,
            chartCanvas,
            ds_chinhanh,
            selectedCN,
            isLoading,
            getInventory,
            formatNumber,
        };
    }
};
</script>
