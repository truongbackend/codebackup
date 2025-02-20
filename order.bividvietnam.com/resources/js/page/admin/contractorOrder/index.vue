<template>
<h4 class="fw-bold py-3 mb-4">
    <span class="text-muted fw-light">Theo dõi tham gia bán hàng<i class="bx bx-chevron-right" style="font-size: 40px;"></i></span>
    Danh sách
</h4>
<div class="row">
    <div class="col-md-4">
        <div class="card mb-4">
            <div class="card-body">
                <div class="mb-3 row">
                    <label for="html5-text-input" class="col-md-6 col-form-label">Xem kết quả</label>
                    <div class="col-md-6">
                        <button type="button" class="btn btn-outline-danger float-end" @click="onClickData">
                            <i class="bx bx-search-alt"></i> Xem kết quả
                        </button>
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="html5-text-input" class="col-md-3 col-form-label">Từ ngày</label>
                    <div class="col-md-9">
                        <input v-model="selectedDate" class="form-control" type="date" value="2021-06-18" id="html5-date-input" />
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="html5-search-input" class="col-md-3 col-form-label">Đến ngày</label>
                    <div class="col-md-9">
                        <input v-model="selectedDateEnd" class="form-control" type="date" value="2021-06-18" id="html5-date-input" />
                    </div>
                </div>
                <div class="col-md">
                    <small class="text-light fw-semibold d-block">Tùy chọn dữ liệu</small>
                    <div class="form-check form-check-inline mt-2">
                        <input v-model="selectedStore" class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio1" value="0">
                        <label class="form-check-label" for="inlineRadio1">Khu vực</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input v-model="selectedStore" class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio2" value="1">
                        <label class="form-check-label" for="inlineRadio2">Tỉnh</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input v-model="selectedStore" class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio3" value="2">
                        <label class="form-check-label" for="inlineRadio3">Nhân viên </label>
                    </div>
                </div>
                <div class="col-md">
                    <small class="text-light fw-semibold d-block">Nhóm hàng</small>
                    <div class="form-check form-check-inline mt-2">
                        <input v-model="selectedCustomer" class="form-check-input" type="radio" name="inlineRadioCustomer" id="inlineRadio1" value="0">
                        <label class="form-check-label" for="inlineRadio">Tất cả</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input v-model="selectedCustomer" class="form-check-input" type="radio" name="inlineRadioCustomer" id="inlineRadio2" value="1">
                        <label class="form-check-label" for="inlineRadio2">Dược</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input v-model="selectedCustomer" class="form-check-input" type="radio" name="inlineRadioCustomer" id="inlineRadio3" value="2">
                        <label class="form-check-label" for="inlineRadio3">Nha khoa </label>
                    </div>
                </div>
                <div class="col-md">
                    <small class="text-light fw-semibold d-block">Hình thức kinh doanh</small>
                    <div class="form-check form-check-inline mt-2">
                        <input v-model="selectedOrder" class="form-check-input" type="radio" name="inlineRadioOrder" id="inlineRadio1" value="1">
                        <label class="form-check-label" for="inlineRadio1">Đơn hàng</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input v-model="selectedOrder" class="form-check-input" type="radio" name="inlineRadioOrder" id="inlineRadio2" value="0">
                        <label class="form-check-label" for="inlineRadio2">Theo hóa đơn</label>
                    </div>
                </div>
                <div class="table-responsive text-nowrap mt-4" id="horizontal-home" v-if="selectedStore === '0'">
                    <table v-if="selectedStore === '0'" class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Chọn</th>
                                <th>Mã khu vực</th>
                                <th>Tên khu vực</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(item, index) in dsKhuvuc" :key="index">
                                <td><input class="form-check-input" type="checkbox" :id="'inlineCheckbox_' + index" :value="item.makhuvuc" v-model="selectedCheckBox"></td>
                                <td>{{ item.makhuvuc }}</td>
                                <td>{{ item.tenkhuvuc }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="table-responsive text-nowrap mt-4" id="horizontal-home" v-if="selectedStore === '1'">
                    <table v-if="selectedStore === '1'" class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Chọn</th>
                                <th>Mã tỉnh</th>
                                <th>Tên tỉnh</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(item, index) in dsTinh" :key="index">
                                <td><input class="form-check-input" type="checkbox" :id="'inlineCheckbox_' + index" :value="item.matinh" v-model="selectedCheckBox"></td>
                                <td>{{ item.matinh }}</td>
                                <td>{{ item.tentinh }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="table-responsive text-nowrap mt-4" id="horizontal-home" v-if="selectedStore === '2'">
                    <table v-if="selectedStore === '2'" class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Nhân viên</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_NhanViens, index) in ds_NhanVien" :key="index">
                                <td>
                                    <label class="text-info list-group-item" data-bs-toggle="collapse" :data-bs-target="'#collapseKhuVuc_' + index" aria-expanded="false" :aria-controls="'collapseKhuVuc_' + index">
                                        {{ ds_NhanViens.khuvuc }}
                                    </label>

                                    <div class="collapse" :id="'collapseKhuVuc_' + index">
                                        <ul v-for="(asmItem, asmIndex) in ds_NhanViens.ds_asm" :key="asmIndex">
                                            <li>
                                                <label class="text-danger list-group-item" data-bs-toggle="collapse" :data-bs-target="'#collapseASM_' + index + '_' + asmIndex" aria-expanded="false" :aria-controls="'collapseASM_' + index + '_' + asmIndex">
                                                    {{ asmItem.asm }}
                                                </label>

                                                <ul class="collapse" :id="'collapseASM_' + index + '_' + asmIndex">
                                                    <li v-for="(sasles, saslesIndex) in asmItem.ds_nhanvien" :key="saslesIndex">
                                                        <label class="list-group-item">
                                                            <input class="form-check-input" type="checkbox" :id="'inlineCheckbox_' + index + '_' + asmIndex + '_' + saslesIndex" :value="sasles.ma_nv5" v-model="selectedCheckBox">
                                                            {{ sasles.sasle }}
                                                        </label>
                                                    </li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-8" v-if="selectedStore === '0'">
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="mb-0 text-center">{{ds_thongtinchung.caption}}</h5>
                <h5 class="text-primary mt-3">Tính tới thời điểm hiện tại</h5>
                <div class="row">
                    <div class="col-md-4">
                        <p class="card-text">
                            -Số lượng nhân viên: {{ds_thongtinchung.soNV}}
                        </p>
                        <p class="card-text">
                            -Tổng khách hàng: {{ds_thongtinchung.sumKH}}
                        </p>
                    </div>
                    <div class="col-md-4">
                        <p class="card-text">
                            -Số lượng ASM: {{ds_thongtinchung.soASM}}
                        </p>
                        <p class="card-text">
                            -Số khách hàng phát sinh giao dịch: {{ds_thongtinchung.khGiaoDich}}
                        </p>
                    </div>
                    <div class="col-md-4">
                        <p class="card-text">
                            -Số lượng Sales: {{ds_thongtinchung.soSale}}
                        </p>
                    </div>
                </div>
                <h5 class="text-primary mt-3">Thông tin thầu</h5>
                <div class="table-responsive text-nowrap table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th></th>
                                <th colspan="8" class="text-center">Kỳ này</th>
                                <th colspan="8" class="text-center">Cùng kỳ năm trước</th>
                            </tr>
                            <tr>
                                <th>Tháng</th>
                                <th>Sl thầu</th>
                                <th>Tiền thầu</th>
                                <th>SL thực hiện </th>
                                <th>Tiền thực hiện </th>
                                <th>SL bỏ thầu</th>
                                <th>Tiền bỏ thầu</th>
                                <th>SL tồn thầu</th>
                                <th>Tiền tồn thầu</th>
                                <th>Sl thực hiện Ck</th>
                                <th>Tiền thực hiện Ck</th>
                                <th>SL thực hiện Ck </th>
                                <th>Tiền thực hiện Ck </th>
                            </tr>
                        </thead>
                        <tbody v-for="ds_thongtinthaus in ds_thongtinthau">
                            <tr>
                                <td colspan="12"><strong>{{ds_thongtinthaus.khu_vuc}}</strong></td>
                            </tr>
                            <tr v-for="ds_chitiet in ds_thongtinthaus.ds_chitiet">
                                <td>{{ds_chitiet.thang}}</td>
                                <td>{{formatNumber(ds_chitiet.slThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.slThucHien)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienThucHien)}}</td>
                                <td>{{formatNumber(ds_chitiet.slBoThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienBoThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.slTonThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienTonThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.slThucHienCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienThucHienCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.slBoThauCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienBoThauCungKy)}}</td>
                            </tr>
                            <tr class="alert alert-info">
                                <td>TC</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLThucHien)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienThucHien)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLBoThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienBoThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLTonThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienTonThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLThucHienCungKy)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienThucHienCungKy)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLBoThauCungKy)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienBoThauCungKy)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-3">Tổng cộng</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th></th>
                                <th colspan="8" class="text-center">Kỳ này</th>
                                <th colspan="8" class="text-center">Cùng kỳ năm trước</th>
                            </tr>
                            <tr>
                                <th>Tháng</th>
                                <th>Sl thầu</th>
                                <th>Tiền thầu</th>
                                <th>SL thực hiện </th>
                                <th>Tiền thực hiện </th>
                                <th>SL bỏ thầu</th>
                                <th>Tiền bỏ thầu</th>
                                <th>SL tồn thầu</th>
                                <th>Tiền tồn thầu</th>
                                <th>Sl thực hiện Ck</th>
                                <th>Tiền thực hiện Ck</th>
                                <th>SL thực hiện Ck </th>
                                <th>Tiền thực hiện Ck </th>
                            </tr>

                        </thead>
                        <tbody>
                            <tr class="alert alert-info">
                                <td></td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLThucHien)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienThucHien)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLBoThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienBoThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLTonThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienTonThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLThucHienCungKy)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienThucHienCungKy)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLBoThauCungKy)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienBoThauCungKy)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-3">Doanh số theo kênh</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th colspan="2"></th>
                                <th colspan="5" class="text-center">Kỳ này</th>
                                <th colspan="5" class="text-center">Cùng kỳ năm trước</th>
                            </tr>
                            <tr>
                                <th>Tháng</th>
                                <th>Nhân viên</th>
                                <th>Sl chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện </th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ </th>
                                <th>SL chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện</th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ</th>
                            </tr>
                        </thead>
                        <tbody v-for="ds_doanhsotheokenhs in ds_doanhsotheokenh">
                            <tr>
                                <td colspan="12"><strong>{{ds_doanhsotheokenhs.kenh}}</strong></td>
                            </tr>
                            <tr v-for="ds_chitiet in ds_doanhsotheokenhs.ds_chitiet">
                                <td>{{ds_chitiet.thang}}</td>
                                <td>{{ds_chitiet.maKhuVuc}}</td>
                                <td>{{formatNumber(ds_chitiet.slChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.slDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.dsDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tyle_trong)}}</td>
                                <td>{{formatNumber(ds_chitiet.slChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.slDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.dsDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tyle_cung)}}</td>
                            </tr>
                            <tr class="alert alert-info">
                                <td colspan="2">Tổng</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumSLChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumTienChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumSLDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumDSDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumtyle_trong)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumSLChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumTienChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumSLDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumDSDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumtyle_cung)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-4"> Tổng cộng</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th colspan="2"></th>
                                <th colspan="5" class="text-center">Kỳ này</th>
                                <th colspan="5" class="text-center">Cùng kỳ năm trước</th>
                            </tr>
                            <tr>
                                <th>Tháng</th>
                                <th>Nhân viên</th>
                                <th>Sl chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện </th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ </th>
                                <th>SL chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện</th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="alert alert-info">
                                <td colspan="2">Tổng Doanh số theo kênh</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumSLChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumTienChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumSLDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumDSDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumtyle_trong)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumSLChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumTienChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumSLDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumDSDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumtyle_cung)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-4"> Tổng hợp công nợ</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Tổng nợ</th>
                                <th>Đã trả</th>
                                <th class="text-danger">Còn nợ</th>
                                <th>Trong hạn</th>
                                <th>Quá hạn &lt; 30</th>
                                <th>Quá hạn &gt;= 30</th>
                                <th>Quá hạn &gt;= 60</th>
                                <th>Quá hạn &gt;= 90</th>
                                <th>Quá hạn &gt;= 120</th>
                            </tr>
                        </thead>
                        <tbody v-for="ds_tonghopcongnos in ds_tonghopcongno">
                            <tr>
                                <td colspan="9"><strong>{{ds_tonghopcongnos.khu_vuc}}</strong></td>
                            </tr>
                            <tr v-for="ds_chitiet in ds_tonghopcongnos.ds_chitiet">
                                <td>{{formatNumber(ds_chitiet.tien_hoadon)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_thanhtoan)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_conlai)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_tronghan)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_qua30)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_qua60)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_qua90)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_qua120)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_quahon120)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-4"> Tổng cộng</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Tổng nợ</th>
                                <th>Đã trả</th>
                                <th class="text-danger">Còn nợ</th>
                                <th>Trong hạn</th>
                                <th>Quá hạn &lt; 30</th>
                                <th>Quá hạn &gt;= 30</th>
                                <th>Quá hạn &gt;= 60</th>
                                <th>Quá hạn &gt;= 90</th>
                                <th>Quá hạn &gt;= 120</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_thanhtoan)}}</td>
                                <td class="text-danger">{{formatNumber(tc_tonghopcongno.sumtien_conlai)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_tronghan)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_duoi30)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_tren30)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_qua60)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_qua90)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_qua120)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-8" v-if="selectedStore === '1'">
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="mb-0 text-center">{{ds_thongtinchung.caption}}</h5>
                <h5 class="text-primary mt-3">Tính tới thời điểm hiện tại</h5>
                <div class="row">
                    <div class="col-md-4">
                        <p class="card-text">
                            -Số lượng nhân viên: {{ds_thongtinchung.soNV}}
                        </p>
                        <p class="card-text">
                            -Tổng khách hàng: {{ds_thongtinchung.sumKH}}
                        </p>
                    </div>
                    <div class="col-md-4">
                        <p class="card-text">
                            -Số lượng ASM: {{ds_thongtinchung.soASM}}
                        </p>
                        <p class="card-text">
                            -Số khách hàng phát sinh giao dịch: {{ds_thongtinchung.khGiaoDich}}
                        </p>
                    </div>
                    <div class="col-md-4">
                        <p class="card-text">
                            -Số lượng Sales: {{ds_thongtinchung.soSale}}
                        </p>
                    </div>
                </div>
                <h5 class="text-primary mt-3">Thông tin thầu</h5>
                <div class="table-responsive text-nowrap table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th></th>
                                <th colspan="8" class="text-center">Kỳ này</th>
                                <th colspan="8" class="text-center">Cùng kỳ năm trước</th>
                            </tr>
                            <tr>
                                <th>Tháng</th>
                                <th>Sl thầu</th>
                                <th>Tiền thầu</th>
                                <th>SL thực hiện </th>
                                <th>Tiền thực hiện </th>
                                <th>SL bỏ thầu</th>
                                <th>Tiền bỏ thầu</th>
                                <th>SL tồn thầu</th>
                                <th>Tiền tồn thầu</th>
                                <th>Sl thực hiện Ck</th>
                                <th>Tiền thực hiện Ck</th>
                                <th>SL thực hiện Ck </th>
                                <th>Tiền thực hiện Ck </th>
                            </tr>

                        </thead>
                        <tbody v-for="ds_thongtinthaus in ds_thongtinthau">
                            <tr>
                                <td colspan="12"><strong>{{ds_thongtinthaus.khu_vuc}}</strong></td>
                            </tr>
                            <tr v-for="ds_chitiet in ds_thongtinthaus.ds_chitiet">
                                <td>{{ds_chitiet.thang}}</td>
                                <td>{{formatNumber(ds_chitiet.slThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.slThucHien)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienThucHien)}}</td>
                                <td>{{formatNumber(ds_chitiet.slBoThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienBoThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.slTonThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienTonThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.slThucHienCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienThucHienCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.slBoThauCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienBoThauCungKy)}}</td>
                            </tr>
                            <tr class="alert alert-info">
                                <td>TC</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLThucHien)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienThucHien)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLBoThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienBoThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLTonThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienTonThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLThucHienCungKy)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienThucHienCungKy)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLBoThauCungKy)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienBoThauCungKy)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-3">Tổng cộng</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th></th>
                                <th colspan="8" class="text-center">Kỳ này</th>
                                <th colspan="8" class="text-center">Cùng kỳ năm trước</th>
                            </tr>
                            <tr>
                                <th>Tháng</th>
                                <th>Sl thầu</th>
                                <th>Tiền thầu</th>
                                <th>SL thực hiện </th>
                                <th>Tiền thực hiện </th>
                                <th>SL bỏ thầu</th>
                                <th>Tiền bỏ thầu</th>
                                <th>SL tồn thầu</th>
                                <th>Tiền tồn thầu</th>
                                <th>Sl thực hiện Ck</th>
                                <th>Tiền thực hiện Ck</th>
                                <th>SL thực hiện Ck </th>
                                <th>Tiền thực hiện Ck </th>
                            </tr>

                        </thead>
                        <tbody>
                            <tr class="alert alert-info">
                                <td></td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLThucHien)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienThucHien)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLBoThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienBoThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLTonThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienTonThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLThucHienCungKy)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienThucHienCungKy)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLBoThauCungKy)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienBoThauCungKy)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-3">Doanh số theo kênh</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th colspan="2"></th>
                                <th colspan="5" class="text-center">Kỳ này</th>
                                <th colspan="5" class="text-center">Cùng kỳ năm trước</th>
                            </tr>
                            <tr>
                                <th>Tháng</th>
                                <th>Nhân viên</th>
                                <th>Sl chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện </th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ </th>
                                <th>SL chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện</th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ</th>
                            </tr>
                        </thead>
                        <tbody v-for="ds_doanhsotheokenhs in ds_doanhsotheokenh">
                            <tr>
                                <td colspan="12"><strong>{{ds_doanhsotheokenhs.kenh}}</strong></td>
                            </tr>
                            <tr v-for="ds_chitiet in ds_doanhsotheokenhs.ds_chitiet">
                                <td>{{ds_chitiet.thang}}</td>
                                <td>{{ds_chitiet.maKhuVuc}}</td>
                                <td>{{formatNumber(ds_chitiet.slChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(s_chitiet.tienChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.slDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.dsDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tyle_trong)}}</td>
                                <td>{{formatNumber(ds_chitiet.slChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.slDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.dsDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tyle_cung)}}</td>
                            </tr>
                            <tr class="alert alert-info">
                                <td colspan="2">Tổng</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumSLChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumTienChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumSLDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumDSDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumtyle_trong)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumSLChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumTienChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumSLDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumDSDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumtyle_cung)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-4"> Tổng cộng</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th colspan="2"></th>
                                <th colspan="5" class="text-center">Kỳ này</th>
                                <th colspan="5" class="text-center">Cùng kỳ năm trước</th>
                            </tr>
                            <tr>
                                <th>Tháng</th>
                                <th>Nhân viên</th>
                                <th>Sl chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện </th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ </th>
                                <th>SL chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện</th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="alert alert-info">
                                <td colspan="2">Tổng Doanh số theo kênh</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumSLChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumTienChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumSLDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumDSDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumtyle_trong)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumSLChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumTienChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumSLDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumDSDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumtyle_cung)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-4"> Tổng hợp công nợ</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Tổng nợ</th>
                                <th>Đã trả</th>
                                <th class="text-danger">Còn nợ</th>
                                <th>Trong hạn</th>
                                <th>Quá hạn &lt; 30</th>
                                <th>Quá hạn &gt;= 30</th>
                                <th>Quá hạn &gt;= 60</th>
                                <th>Quá hạn &gt;= 90</th>
                                <th>Quá hạn &gt;= 120</th>
                            </tr>
                        </thead>
                        <tbody v-for="ds_tonghopcongnos in ds_tonghopcongno">
                            <tr>
                                <td colspan="9"><strong>{{ds_tonghopcongnos.khu_vuc}}</strong></td>
                            </tr>
                            <tr v-for="ds_chitiet in ds_tonghopcongnos.ds_chitiet">
                                <td>{{formatNumber(ds_chitiet.tien_hoadon)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_thanhtoan)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_conlai)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_tronghan)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_qua30)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_qua60)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_qua90)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_qua120)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_quahon120)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-4"> Tổng cộng</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Tổng nợ</th>
                                <th>Đã trả</th>
                                <th class="text-danger">Còn nợ</th>
                                <th>Trong hạn</th>
                                <th>Quá hạn &lt; 30</th>
                                <th>Quá hạn &gt;= 30</th>
                                <th>Quá hạn &gt;= 60</th>
                                <th>Quá hạn &gt;= 90</th>
                                <th>Quá hạn &gt;= 120</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_thanhtoan)}}</td>
                                <td class="text-danger">{{formatNumber(tc_tonghopcongno.sumtien_conlai)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_tronghan)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_duoi30)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_tren30)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_qua60)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_qua90)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_qua120)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-8" v-if="selectedStore === '2'">
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="mb-0 text-center">Báo cáo Doanh số theo nhân viên</h5>
                <h5 class="text-primary mt-3">Tính tới thời điểm hiện tại</h5>
                <div class="row">
                    <div class="col-md-4">
                        <p class="card-text">
                            -Tổng khách hàng: {{ds_thongtinchung.sumKH}}
                        </p>
                    </div>
                    <div class="col-md-4">
                        <p class="card-text">
                            -Số khách hàng phát sinh giao dịch: {{ds_thongtinchung.khGiaoDich}}
                        </p>
                    </div>
                </div>
                <h5 class="text-primary mt-3">Thông tin thầu</h5>
                <div class="table-responsive text-nowrap table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th></th>
                                <th colspan="8" class="text-center">Kỳ này</th>
                                <th colspan="8" class="text-center">Cùng kỳ năm trước</th>
                            </tr>
                            <tr>
                                <th>Tháng</th>
                                <th>Sl thầu</th>
                                <th>Tiền thầu</th>
                                <th>SL thực hiện </th>
                                <th>Tiền thực hiện </th>
                                <th>SL bỏ thầu</th>
                                <th>Tiền bỏ thầu</th>
                                <th>SL tồn thầu</th>
                                <th>Tiền tồn thầu</th>
                                <th>Sl thực hiện Ck</th>
                                <th>Tiền thực hiện Ck</th>
                                <th>SL thực hiện Ck </th>
                                <th>Tiền thực hiện Ck </th>
                            </tr>

                        </thead>
                        <tbody v-for="ds_thongtinthaus in ds_thongtinthau">
                            <tr>
                                <td colspan="12"><strong>{{ds_thongtinthaus.khu_vuc}}</strong></td>
                            </tr>
                            <tr v-for="ds_chitiet in ds_thongtinthaus.ds_chitiet">
                                <td>{{ds_chitiet.thang}}</td>
                                <td>{{formatNumber(ds_chitiet.slThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.slThucHien)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienThucHien)}}</td>
                                <td>{{formatNumber(ds_chitiet.slBoThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienBoThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.slTonThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienTonThau)}}</td>
                                <td>{{formatNumber(ds_chitiet.slThucHienCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienThucHienCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.slBoThauCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienBoThauCungKy)}}</td>
                            </tr>
                            <tr class="alert alert-info">
                                <td>TC</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLThucHien)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienThucHien)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLBoThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienBoThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLTonThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienTonThau)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLThucHienCungKy)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienThucHienCungKy)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumSLBoThauCungKy)}}</td>
                                <td>{{formatNumber(ds_thongtinthaus.tong_cong.sumTienBoThauCungKy)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-3">Tổng cộng</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th></th>
                                <th colspan="8" class="text-center">Kỳ này</th>
                                <th colspan="8" class="text-center">Cùng kỳ năm trước</th>
                            </tr>
                            <tr>
                                <th>Tháng</th>
                                <th>Sl thầu</th>
                                <th>Tiền thầu</th>
                                <th>SL thực hiện </th>
                                <th>Tiền thực hiện </th>
                                <th>SL bỏ thầu</th>
                                <th>Tiền bỏ thầu</th>
                                <th>SL tồn thầu</th>
                                <th>Tiền tồn thầu</th>
                                <th>Sl thực hiện Ck</th>
                                <th>Tiền thực hiện Ck</th>
                                <th>SL thực hiện Ck </th>
                                <th>Tiền thực hiện Ck </th>
                            </tr>

                        </thead>
                        <tbody>
                            <tr class="alert alert-info">
                                <td></td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLThucHien)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienThucHien)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLBoThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienBoThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLTonThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienTonThau)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLThucHienCungKy)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienThucHienCungKy)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumSLBoThauCungKy)}}</td>
                                <td>{{formatNumber(tc_thongtinthau.sumTienBoThauCungKy)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-3">Doanh số theo kênh</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th colspan="2"></th>
                                <th colspan="5" class="text-center">Kỳ này</th>
                                <th colspan="5" class="text-center">Cùng kỳ năm trước</th>
                            </tr>
                            <tr>
                                <th>Tháng</th>
                                <th>Nhân viên</th>
                                <th>Sl chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện </th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ </th>
                                <th>SL chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện</th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ</th>
                            </tr>
                        </thead>
                        <tbody v-for="ds_doanhsotheokenhs in ds_doanhsotheokenh">
                            <tr>
                                <td colspan="12"><strong>{{ds_doanhsotheokenhs.kenh}}</strong></td>
                            </tr>
                            <tr v-for="ds_chitiet in ds_doanhsotheokenhs.ds_chitiet">
                                <td>{{ds_chitiet.thang}}</td>
                                <td>{{ds_chitiet.maKhuVuc}}</td>
                                <td>{{formatNumber(ds_chitiet.slChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.slDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.dsDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tyle_trong)}}</td>
                                <td>{{formatNumber(ds_chitiet.slChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.slDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.dsDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tyle_cung)}}</td>
                            </tr>
                            <tr class="alert alert-info">
                                <td colspan="2">Tổng</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumSLChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumTienChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumSLDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumDSDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumtyle_trong)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumSLChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumTienChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumSLDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumDSDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokenhs.tong_cong.sumtyle_cung)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-4"> Tổng cộng</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th colspan="2"></th>
                                <th colspan="5" class="text-center">Kỳ này</th>
                                <th colspan="5" class="text-center">Cùng kỳ năm trước</th>
                            </tr>
                            <tr>
                                <th>Tháng</th>
                                <th>Nhân viên</th>
                                <th>Sl chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện </th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ </th>
                                <th>SL chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện</th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="alert alert-info">
                                <td colspan="2">Tổng Doanh số theo kênh</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumSLChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumTienChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumSLDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumDSDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumtyle_trong)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumSLChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumTienChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumSLDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumDSDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokenh.sumtyle_cung)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-4"> Doanh số theo khách hàng</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th colspan="2"></th>
                                <th colspan="5" class="text-center">Kỳ này</th>
                                <th colspan="5" class="text-center">Cùng kỳ năm trước</th>
                            </tr>
                            <tr>
                                <th>Tháng</th>
                                <th>Khách hàng</th>
                                <th>Sl chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện </th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ </th>
                                <th>SL chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện</th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ</th>
                            </tr>
                        </thead>
                        <tbody v-for="ds_doanhsotheokhachhangs in ds_doanhsotheokhachhang">
                            <tr>
                                <td colspan="12"><strong>{{ds_doanhsotheokhachhangs.khach_hang}}</strong></td>
                            </tr>
                            <tr v-for="ds_chitiet in ds_doanhsotheokhachhangs.ds_chitiet">
                                <td>{{ds_chitiet.thang}}</td>
                                <td>{{ds_chitiet.maKhuVuc}}</td>
                                <td>{{formatNumber(ds_chitiet.slChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.slDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.dsDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tyle_trong)}}</td>
                                <td>{{formatNumber(ds_chitiet.slChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.slDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.dsDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tyle_cung)}}</td>
                            </tr>
                            <tr class="alert alert-info">
                                <td colspan="2">Tổng</td>
                                <td>{{formatNumber(ds_doanhsotheokhachhangs.tong_cong.sumSLChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokhachhangs.tong_cong.sumTienChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokhachhangs.tong_cong.sumSLDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokhachhangs.tong_cong.sumDSDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokhachhangs.tong_cong.sumtyle_trong)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokhachhangs.tong_cong.sumSLChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokhachhangs.tong_cong.sumTienChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokhachhangs.tong_cong.sumSLDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokhachhangs.tong_cong.sumDSDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheokhachhangs.tong_cong.sumtyle_cung)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-4"> Tổng cộng danh sách khách hàng</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th colspan="2"></th>
                                <th colspan="5" class="text-center">Kỳ này</th>
                                <th colspan="5" class="text-center">Cùng kỳ năm trước</th>
                            </tr>
                            <tr>
                                <th>Tháng</th>
                                <th>Khách hàng</th>
                                <th>Sl chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện </th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ </th>
                                <th>SL chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện</th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="2">Tổng Doanh số theo khách hàng</td>
                                <td>{{formatNumber(tc_doanhsotheokhachhang.sumSLChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokhachhang.sumTienChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokhachhang.sumSLDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokhachhang.sumDSDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokhachhang.sumtyle_trong)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokhachhang.sumSLChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokhachhang.sumTienChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokhachhang.sumSLDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokhachhang.sumDSDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheokhachhang.sumtyle_cung)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-4"> Doanh số theo sản phẩm</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th colspan="2"></th>
                                <th colspan="5" class="text-center">Kỳ này</th>
                                <th colspan="5" class="text-center">Cùng kỳ năm trước</th>
                            </tr>
                            <tr>
                                <th>Tháng</th>
                                <th>Sản phẩm</th>
                                <th>Sl chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện </th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ </th>
                                <th>SL chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện</th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ</th>
                            </tr>
                        </thead>
                        <tbody v-for="ds_doanhsotheosanphams in ds_doanhsotheosanpham">
                            <tr>
                                <td colspan="12"><strong>{{ds_doanhsotheosanphams.san_pham}}</strong></td>
                            </tr>
                            <tr v-for="ds_chitiet in ds_doanhsotheosanphams.ds_chitiet">
                                <td>{{ds_chitiet.thang}}</td>
                                <td>{{ds_chitiet.maKhuVuc}}</td>
                                <td>{{formatNumber(ds_chitiet.slChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.slDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.dsDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tyle_trong)}}</td>
                                <td>{{formatNumber(ds_chitiet.slChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tienChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.slDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.dsDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_chitiet.tyle_cung)}}</td>
                            </tr>
                            <tr class="alert alert-info">
                                <td colspan="2">Tổng</td>
                                <td>{{formatNumber(ds_doanhsotheosanphams.tong_cong.sumSLChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheosanphams.tong_cong.sumTienChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheosanphams.tong_cong.sumSLDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheosanphams.tong_cong.sumDSDuocTrongKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheosanphams.tong_cong.sumtyle_trong)}}</td>
                                <td>{{formatNumber(ds_doanhsotheosanphams.tong_cong.sumSLChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheosanphams.tong_cong.sumTienChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheosanphams.tong_cong.sumSLDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheosanphams.tong_cong.sumDSDuocCungKy)}}</td>
                                <td>{{formatNumber(ds_doanhsotheosanphams.tong_cong.sumtyle_cung)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-4"> Tổng cộng danh sách sản phẩm</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th colspan="2"></th>
                                <th colspan="5" class="text-center">Kỳ này</th>
                                <th colspan="5" class="text-center">Cùng kỳ năm trước</th>
                            </tr>
                            <tr>
                                <th>Tháng</th>
                                <th>Sản phẩm</th>
                                <th>Sl chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện </th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ </th>
                                <th>SL chỉ tiêu</th>
                                <th>Tiền chỉ tiêu</th>
                                <th>SL thực hiện</th>
                                <th>Tiền thực hiện</th>
                                <th>Tỷ lệ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="2">Tổng Doanh số theo sản phẩm</td>
                                <td>{{formatNumber(tc_doanhsotheosanpham.sumSLChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheosanpham.sumTienChiTieuDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheosanpham.sumSLDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheosanpham.sumDSDuocTrongKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheosanpham.sumtyle_trong)}}</td>
                                <td>{{formatNumber(tc_doanhsotheosanpham.sumSLChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheosanpham.sumTienChiTieuDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheosanpham.sumSLDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheosanpham.sumDSDuocCungKy)}}</td>
                                <td>{{formatNumber(tc_doanhsotheosanpham.sumtyle_cung)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-4"> Tổng hợp công nợ</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Tổng nợ</th>
                                <th>Đã trả</th>
                                <th class="text-danger">Còn nợ</th>
                                <th>Trong hạn</th>
                                <th>Quá hạn &lt; 30</th>
                                <th>Quá hạn &gt;= 30</th>
                                <th>Quá hạn &gt;= 60</th>
                                <th>Quá hạn &gt;= 90</th>
                                <th>Quá hạn &gt;= 120</th>
                            </tr>
                        </thead>
                        <tbody v-for="ds_tonghopcongnos in ds_tonghopcongno">
                            <tr>
                                <td colspan="9"><strong>{{ds_tonghopcongnos.khu_vuc}}</strong></td>
                            </tr>
                            <tr v-for="ds_chitiet in ds_tonghopcongnos.ds_chitiet">
                                <td>{{formatNumber(ds_chitiet.tien_hoadon)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_thanhtoan)}}</td>
                                <td class="text-danger">{{formatNumber(ds_chitiet.tien_conlai)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_tronghan)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_qua30)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_qua60)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_qua90)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_qua120)}}</td>
                                <td>{{formatNumber(ds_chitiet.tien_hoadon_quahon120)}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <h5 class="text-primary mt-4"> Tổng cộng</h5>
                <div class="table-responsive text-nowrap table-scroll">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Tổng nợ</th>
                                <th>Đã trả</th>
                                <th class="text-danger">Còn nợ</th>
                                <th>Trong hạn</th>
                                <th>Quá hạn &lt; 30</th>
                                <th>Quá hạn &gt;= 30</th>
                                <th>Quá hạn &gt;= 60</th>
                                <th>Quá hạn &gt;= 90</th>
                                <th>Quá hạn &gt;= 120</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_thanhtoan)}}</td>
                                <td class="text-danger">{{formatNumber(tc_tonghopcongno.sumtien_conlai)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_tronghan)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_duoi30)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_tren30)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_qua60)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_qua90)}}</td>
                                <td>{{formatNumber(tc_tonghopcongno.sumtien_hoadon_qua120)}}</td>
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
import axios from "axios";
import { defineComponent, ref, onMounted, watchEffect } from "vue";
import { inject } from "vue";
import { TreeViewComponent } from '@syncfusion/ej2-vue-navigations';
export default {
    components: {
        TreeViewComponent,
    },
    setup() {
        const globalState = inject("globalState");
        const baseApi = globalState.baseApi;
        const selectedDate = ref("");
        const selectedDateEnd = ref("");
        const ds_xemsolieu = ref("");
        const ds_khuvuc = ref("");
        const selectedStore = ref('0');
        const selectedCustomer = ref('0');
        const selectedOrder = ref('1');
        const dsKhuvuc = ref([]);
        const dsTinh = ref([]);
        const dsNhanVien = ref([]);
        const ds_NhanVien = ref([]);
        const selectedCheckBox = ref([]);
        const ds_thongtinchung = ref('');
        const ds_thongtinthau = ref('');
        const tongDs_thongtinthau = ref('');
        const tc_thongtinthau = ref('');
        const ds_doanhsotheokenh = ref('');
        const tc_doanhsotheokenh = ref('');
        const ds_tonghopcongno = ref('');
        const tc_tonghopcongno = ref('');
        const ds_doanhsotheokhachhang = ref('');
        const tc_doanhsotheokhachhang = ref('');
        const ds_doanhsotheosanpham = ref('');
        const tc_doanhsotheosanpham = ref('');
        const tokenApi = localStorage.getItem('tokensApi');
        const axiosConfig = {
            headers: {
                Authorization: `Bearer ${tokenApi}`,
                'Content-Type': 'application/json; charset=utf-8',
                'API': 'True'
            },
        };
        const getAutoComplete = () => {
            axios
                .get(`${baseApi}/report/theodoi/doanhsobanhang-autocomplete`, axiosConfig)
                .then((response) => {
                    ds_xemsolieu.value = response.data.ds_xemsolieu;
                    ds_khuvuc.value = ds_xemsolieu.value['ds_khuvuc'];
                    const tinhData = ds_xemsolieu.value['ds_tinh'];
                    const nhanVienData = ds_xemsolieu.value['ds_nhanvien'];
                    if (selectedStore.value === '0') {
                        dsKhuvuc.value = ds_khuvuc.value['ds_chitiet'];
                        selectedCheckBox.value = dsKhuvuc.value.map(item => item.makhuvuc);
                    } else if (selectedStore.value === '1') {
                        dsTinh.value = tinhData['ds_chitiet'];
                        selectedCheckBox.value = dsTinh.value.map(item => item.matinh);
                    } else if (selectedStore.value === '2') {
                        ds_NhanVien.value = nhanVienData['ds_chitiet'];
                        const selectedValues = [];
                        ds_NhanVien.value.forEach(ds_NhanViens => {
                            ds_NhanViens.ds_asm.forEach(asmItem => {
                                asmItem.ds_nhanvien.forEach(sasles => {
                                    selectedValues.push(sasles.ma_nv5);
                                });
                            });
                        });
                        selectedCheckBox.value = selectedValues;
                    }
                })
                .catch((error) => {
                    console.error(error);
                });
        };
        const formatNumber = (value) => {
            if (value !== undefined && value !== null) {
                return value.toLocaleString();
            } else {
                return '';
            }
        };
        const getCurrentYearDates = () => {
            const today = new Date();
            const currentYear = today.getFullYear();
            const firstDayOfYear = new Date(currentYear, 0, 1);
            const lastDayOfYear = new Date(currentYear, 11, 31);
            const oneMonthAgo = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate());
            const formatDate = (date) => {
                const year = date.getFullYear();
                let month = date.getMonth() + 1;
                let day = date.getDate();
                month = month < 10 ? `0${month}` : month;
                day = day < 10 ? `0${day}` : day;
                return `${year}-${month}-${day}`;
            };
            selectedDate.value = formatDate(oneMonthAgo);
            selectedDateEnd.value = formatDate(today);
        };
        const getInventory = () => {
            if (Array.isArray(dsKhuvuc)) {
                const combinedValues = dsKhuvuc.map(item => item.makhuvuc);
            }
            const combinedValues = ',' + selectedCheckBox.value.join(',') + ',';
            const axiosConfig = {
                headers: {
                    Authorization: `Bearer ${tokenApi}`,
                    'Content-Type': 'application/json; charset=utf-8',
                    'API': 'True'
                },
            };
            const params = {
                loai_xem: selectedStore.value,
                loai_nhomhang: selectedCustomer.value,
                loai_hinhthuc: selectedOrder.value,
                list_ma: combinedValues,
            };
            if (selectedDate.value) {
                params.tungay = selectedDate.value;
            }
            if (selectedDateEnd.value) {
                params.denngay = selectedDateEnd.value;
            }
            axios
                .get(`${baseApi}/report/theodoi/doanhsobanhang`, {
                    params: params,
                    ...axiosConfig,
                })
                .then((response) => {
                    ds_thongtinchung.value = response.data.ds_thongtinchung;
                    ds_thongtinthau.value = response.data.ds_thongtinthau;
                    tc_thongtinthau.value = response.data.tc_thongtinthau;
                    ds_doanhsotheokenh.value = response.data.ds_doanhsotheokenh;
                    tc_doanhsotheokenh.value = response.data.tc_doanhsotheokenh;
                    ds_tonghopcongno.value = response.data.ds_tonghopcongno;
                    tc_tonghopcongno.value = response.data.tc_tonghopcongno;
                    ds_doanhsotheokhachhang.value = response.data.ds_doanhsotheokhachhang;
                    tc_doanhsotheokhachhang.value = response.data.tc_doanhsotheokhachhang;
                    ds_doanhsotheosanpham.value = response.data.ds_doanhsotheosanpham;
                    tc_doanhsotheosanpham.value = response.data.tc_doanhsotheosanpham;
                })
                .catch((error) => {
                    console.log(error);
                });
        }

        onMounted(() => {
            getAutoComplete();
            getCurrentYearDates();

        });
        watchEffect(() => {
            if (selectedStore.value === '0' || selectedStore.value === '1' || selectedStore.value === '2') {
                getAutoComplete();
            }
        });
        const onClickData = () => {
            getInventory();
        };
        return {
            onClickData,
            selectedDate,
            selectedDateEnd,
            ds_xemsolieu,
            selectedStore,
            dsKhuvuc,
            dsTinh,
            dsNhanVien,
            ds_NhanVien,
            selectedCustomer,
            selectedOrder,
            selectedCheckBox,
            ds_thongtinchung,
            ds_thongtinthau,
            tongDs_thongtinthau,
            tc_thongtinthau,
            ds_doanhsotheokenh,
            tc_doanhsotheokenh,
            ds_tonghopcongno,
            tc_tonghopcongno,
            ds_doanhsotheokhachhang,
            tc_doanhsotheokhachhang,
            ds_doanhsotheosanpham,
            tc_doanhsotheosanpham,
            formatNumber,
        };
    },
};
</script>
