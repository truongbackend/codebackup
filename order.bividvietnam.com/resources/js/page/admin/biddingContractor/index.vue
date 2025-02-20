<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Theo dõi tham gia thầu<i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách</h4>
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
                <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#loadContent" @click="getInventory">
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
    <div class="row mt-3">
        <div class="col-sm-6 col-lg-3 mb-4">
            <div class="card card-border-shadow-primary h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center mb-2 pb-1">
                        <div class="avatar me-2"><span class="avatar-initial rounded bg-label-primary"><i class="bx bxs-truck"></i></span></div>
                        <h4 class="ms-1 mb-0">Số lượng mời thầu</h4>
                    </div>
                    <p class="mb-1">{{ formatNumber(ds_thamgiathauchung.soluong_moithau) }} </p>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-lg-3 mb-4">
            <div class="card card-border-shadow-warning h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center mb-2 pb-1">
                        <div class="avatar me-2"><span class="avatar-initial rounded bg-label-warning"><i class="bx bx-cart"></i></span></div>
                        <h4 class="ms-1 mb-0">Giá trị mời thầu</h4>
                    </div>
                    <p class="mb-1">{{ formatNumber(ds_thamgiathauchung.giatri_moithau) }} đ</p>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-lg-3 mb-4">
            <div class="card card-border-shadow-danger h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center mb-2 pb-1">
                        <div class="avatar me-2"><span class="avatar-initial rounded bg-label-danger"><i class="bx bx-error"></i></span></div>
                        <h4 class="ms-1 mb-0">SL Trúng thầu </h4>
                    </div>
                    <p class="mb-1">{{ formatNumber(ds_thamgiathauchung.soluong_trungthautrongky) }} </p>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-lg-3 mb-4">
            <div class="card card-border-shadow-info h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center mb-2 pb-1">
                        <div class="avatar me-2"><span class="avatar-initial rounded bg-label-info"><i class="bx bx-user"></i></span></div>
                        <h4 class="ms-1 mb-0">Gía trị trúng thầu</h4>
                    </div>
                    <p class="mb-1">{{ formatNumber(ds_thamgiathauchung.giatri_trungthautrongky) }} đ</p>
                </div>
            </div>
        </div>

    </div>
    <div class="row mt-4">
        <canvas ref="chartCanvas"></canvas>
    </div>
    <div class="row">
        <div class="col-md-4">
            <div class="card mt-4">
                <div class="card-header justify-content-between text-center">
                    <h5 class="card-title m-0">Theo chi nhánh</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive text-nowrap table-scroll table-px">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Tên chi nhánh</th>
                                    <th>Giá trị mời thầu</th>
                                    <th>Gía Trị trúng thầu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(ds_thamgiathautheochinhanhs, index) in ds_thamgiathautheochinhanh" :key="index">
                                    <td>{{ ds_thamgiathautheochinhanhs.ten }}</td>
                                    <td>{{ formatNumber(ds_thamgiathautheochinhanhs.giatri_moithau) }}</td>
                                    <td>{{ formatNumber(ds_thamgiathautheochinhanhs.giatri_trungthau) }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
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
                                    <th>Gía Trị trúng thầu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(ds_thamgiathautheokhachhangs, index) in ds_thamgiathautheokhachhang" :key="index">
                                    <td>{{ ds_thamgiathautheokhachhangs.ten }}</td>
                                    <td>{{ formatNumber(ds_thamgiathautheokhachhangs.giatri_moithau) }}</td>
                                    <td>{{ formatNumber(ds_thamgiathautheokhachhangs.giatri_trungthau) }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
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
                                    <th>SL mời thầu </th>
                                    <th>SL trúng thầu </th>
                                    <th>Gía Trị trúng thầu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(ds_thamgiathautheosanphams, index) in ds_thamgiathautheosanpham" :key="index">
                                    <td>{{ ds_thamgiathautheosanphams.ten }}</td>
                                    <td>{{ formatNumber(ds_thamgiathautheosanphams.giatri_moithau) }}</td>
                                    <td>{{ formatNumber(ds_thamgiathautheosanphams.giatri_trungthau) }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-4">
            <div class="card mt-4">
                <div class="card-header justify-content-between text-center">
                    <h5 class="card-title m-0">Theo chi nhánh</h5>
                </div>
                <div class="table-responsive text-nowrap table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th rowspan="2"></th>
                                <th v-for="(ds_thamgiathautheochinhanh_theonams, index) in ds_thamgiathautheochinhanh_theonam" :key="index" colspan="2">{{ ds_thamgiathautheochinhanh_theonams.thang }}</th>
                            </tr>
                            <tr>
                                <th v-for="(ds_thamgiathautheochinhanh_theonams, index) in ds_thamgiathautheochinhanh_theonam" :key="index">Giá trị mời thầu</th>
                                <th v-for="(ds_thamgiathautheochinhanh_theonams, index) in ds_thamgiathautheochinhanh_theonam" :key="index">Giá trị trúng thầu</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_thamgiathautheochinhanh_theonams, index) in ds_thamgiathautheochinhanh_theonam" :key="index">
                                <td>{{ ds_thamgiathautheochinhanh_theonams.ten }}</td>
                                <td v-for="(ds_thamgiathautheochinhanh_theonams, index) in ds_thamgiathautheochinhanh_theonam" :key="index">{{ formatNumber(ds_thamgiathautheochinhanh_theonams.giatri_moithau) }}</td>
                                <td v-for="(ds_thamgiathautheochinhanh_theonams, index) in ds_thamgiathautheochinhanh_theonam" :key="index">{{ formatNumber(ds_thamgiathautheochinhanh_theonams.giatri_trungthau) }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card mt-4">
                <div class="card-header justify-content-between text-center">
                    <h5 class="card-title m-0">Theo khách hàng</h5>
                </div>
                <div class="table-responsive text-nowrap table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th rowspan="2"></th>
                                <th v-for="(ds_thamgiathautheokhachhang_theonams, index) in ds_thamgiathautheokhachhang_theonam" :key="index" colspan="2">{{ ds_thamgiathautheokhachhang_theonams.thang }}</th>
                            </tr>
                            <tr>
                                <th v-for="(ds_thamgiathautheokhachhang_theonams, index) in ds_thamgiathautheokhachhang_theonam" :key="index">Giá trị mời thầu</th>
                                <th v-for="(ds_thamgiathautheokhachhang_theonams, index) in ds_thamgiathautheokhachhang_theonam" :key="index">Giá trị trúng thầu</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_thamgiathautheokhachhang_theonams, index) in ds_thamgiathautheokhachhang_theonam" :key="index">
                                <td>{{ ds_thamgiathautheokhachhang_theonams.ten }}</td>
                                <td v-for="(ds_thamgiathautheokhachhang_theonams, index) in ds_thamgiathautheokhachhang_theonam" :key="index">{{ formatNumber(ds_thamgiathautheokhachhang_theonams.giatri_moithau) }}</td>
                                <td v-for="(ds_thamgiathautheokhachhang_theonams, index) in ds_thamgiathautheokhachhang_theonam" :key="index">{{ formatNumber(ds_thamgiathautheokhachhang_theonams.giatri_trungthau) }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card mt-4">
                <div class="card-header justify-content-between text-center">
                    <h5 class="card-title m-0">Theo sản phẩm</h5>
                </div>
                <div class="table-responsive text-nowrap table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th rowspan="2"></th>
                                <th v-for="(ds_thamgiathautheosanpham_theonams, index) in ds_thamgiathautheosanpham_theonam" :key="index" colspan="2">{{ ds_thamgiathautheosanpham_theonams.thang }}</th>
                            </tr>
                            <tr>
                                <th v-for="(ds_thamgiathautheosanpham_theonams, index) in ds_thamgiathautheosanpham_theonam" :key="index">Giá trị mời thầu</th>
                                <th v-for="(ds_thamgiathautheosanpham_theonams, index) in ds_thamgiathautheosanpham_theonam" :key="index">Giá trị trúng thầu</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(ds_thamgiathautheosanpham_theonams, index) in ds_thamgiathautheosanpham_theonam" :key="index">
                                <td>{{ ds_thamgiathautheosanpham_theonams.ten }}</td>
                                <td v-for="(ds_thamgiathautheosanpham_theonams, index) in ds_thamgiathautheosanpham_theonam" :key="index">{{ formatNumber(ds_thamgiathautheosanpham_theonams.giatri_moithau) }}</td>
                                <td v-for="(ds_thamgiathautheosanpham_theonams, index) in ds_thamgiathautheosanpham_theonam" :key="index">{{ formatNumber(ds_thamgiathautheosanpham_theonams.giatri_trungthau) }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-8">
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
                                    <th>Tên chi nhánh </th>
                                    <th>Tên nhân viên</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Ngày trúng thầu</th>
                                    <th>Ngày bắt đầu thầu</th>
                                    <th>Ngày kết thúc thầu</th>
                                    <th>Số tháng còn thầu</th>
                                    <th>Số lượng thầu</th>
                                    <th>Tiền thầu</th>
                                    <th>Số tiền thầu</th>
                                    <th>Tiền tồn thầu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(ds_tonthaus, index) in ds_tonthau" :key="index">
                                    <td>{{ ds_tonthaus.thang_conlai }}</td>
                                    <td>{{ ds_tonthaus.ten_chinhanh }}</td>
                                    <td>{{ ds_tonthaus.ten_nv }}</td>
                                    <td>{{ ds_tonthaus.ma_nv }}</td>
                                    <td>{{ ds_tonthaus.ten_kh }}</td>
                                    <td>{{ ds_tonthaus.ma_vt }}</td>
                                    <td>{{ ds_tonthaus.ten_vt }}</td>
                                    <td>{{ ds_tonthaus.ten_nhvt }}</td>
                                    <td>{{ ds_tonthaus.ten_nhkh }}</td>
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
        <div class="col-md-4">
            <div class="card mt-4">
                <div class="card-header justify-content-between text-center">
                    <h5 class="card-title m-0">Danh sách khách hàng chưa tham gia thầu</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive text-nowrap table-scroll table-px">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Chi nhánh</th>
                                    <th>Tên khách hàng </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(ds_khachhangchuathamgias, index) in ds_khachhangchuathamgia" :key="index">
                                    <td>{{ ds_khachhangchuathamgias.ten_chinhanh }}</td>
                                    <td>{{ ds_khachhangchuathamgias.ten_khachhang }}</td>
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
        const ds_marketingchung = ref([]);
        const selectedVt = ref('');
        const selectedCustomer = ref('');
        const ds_khachhang = ref('');
        const ds_hinhthucxem = ref('');
        const selectDatetime = ref('2');
        const ds_maubaocao = ref('');
        const selectedDate = ref('');
        const selectedDateEnd = ref('');
        const selectedMbC = ref('');
        const chartCanvas = ref(null);
        const isLoading = ref(false);
        const selectedCN = ref('');
        const chartInstance = ref(null);
        const ds_thamgiathauchung = ref('');
        const ds_thamgiathautheothang = ref('');
        const ds_thamgiathautheochinhanh = ref('');
        const ds_thamgiathautheokhachhang = ref('');
        const ds_thamgiathautheosanpham = ref('');
        const ds_thamgiathautheochinhanh_theonam = ref('');
        const ds_thamgiathautheokhachhang_theonam = ref('');
        const ds_thamgiathautheosanpham_theonam = ref('');
        const ds_khachhangchuathamgia = ref('');
        const tokenApi = localStorage.getItem('tokensApi');
        const ds_tonthau = ref('');
        const loadcontent = ref(true);
        const getAutoComplete = () => {
            const axiosConfig = {
                headers: {
                    Authorization: `Bearer ${tokenApi}`,
                    'Content-Type': 'application/json; charset=utf-8',
                    'API': 'True'
                },
            };
            axios
                .get(`${baseApi}/report/theodoi/thamgiathau-autocomplete`, axiosConfig)
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
                .get(`${baseApi}/report/theodoi/thamgiathau`, {
                    params: params,
                    ...axiosConfig,
                })
                .then((response) => {
                    ds_thamgiathauchung.value = response.data.ds_thamgiathauchung;
                    ds_thamgiathautheothang.value = response.data.ds_thamgiathautheothang;
                    ds_thamgiathautheochinhanh.value = response.data.ds_thamgiathautheochinhanh;
                    ds_thamgiathautheokhachhang.value = response.data.ds_thamgiathautheokhachhang;
                    ds_thamgiathautheosanpham.value = response.data.ds_thamgiathautheosanpham;
                    ds_thamgiathautheochinhanh_theonam.value = response.data.ds_thamgiathautheochinhanh_theonam;
                    ds_thamgiathautheokhachhang_theonam.value = response.data.ds_thamgiathautheokhachhang_theonam;
                    ds_thamgiathautheosanpham_theonam.value = response.data.ds_thamgiathautheosanpham_theonam;
                    ds_khachhangchuathamgia.value = response.data.ds_khachhangchuathamgia;
                    ds_tonthau.value = response.data.ds_tonthau;
                    isLoading.value = false;
                })
                .catch((error) => {
                    isLoading.value = false;
                    console.log(error);
                });
        };
        const drawChart = () => {
            if (!chartCanvas.value || !ds_thamgiathautheothang.value) return;
            const ctx = chartCanvas.value.getContext('2d');
            const labels = ds_thamgiathautheothang.value.map(item => item.thang);
            const giatri_moithau = ds_thamgiathautheothang.value.map(item => item.giatri_moithau);
            const giatri_trungthau = ds_thamgiathautheothang.value.map(item => item.giatri_trungthau);
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
            chartInstance,
            chartCanvas,
            selectedCN,
            isLoading,
            getInventory,
            ds_thamgiathauchung,
            ds_thamgiathautheothang,
            ds_thamgiathautheochinhanh,
            ds_thamgiathautheokhachhang,
            ds_thamgiathautheosanpham,
            ds_thamgiathautheochinhanh_theonam,
            ds_thamgiathautheokhachhang_theonam,
            ds_thamgiathautheosanpham_theonam,
            ds_tonthau,
            ds_khachhangchuathamgia,
            formatNumber
        };
    }
};
</script>
