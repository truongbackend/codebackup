<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Báo cáo tổng hợp bán hàng , Công nợ theo ASM<i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách</h4>
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
                <label for="exampleFormControlSelect1" class="form-label">Sản phẩm</label>
                <model-list-select :list="ds_vattu" v-model="selectedVt" option-value="ma_vt" option-text="ten_vt" placeholder="Chọn mã vật tư"></model-list-select>
            </div>
        </div>
        <div class="row mt-3">
            <div class="col-md-4">
                <label for="exampleFormControlSelect1" class="form-label">Khách hàng</label>
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
    <div class="spinner-border spinner-border-lg text-success" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>
<div class="card mt-3">
    <div class="card-body">
        <div class="table-responsive text-nowrap table-scroll table-px">
            <table class="table table-bordered mb-4">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Tên chi nhánh</th>
                        <th>Mã sale</th>
                        <th>Tên sale</th>
                        <th>Tổng tiền thực hiện</th>
                        <th>Tổng tiền thu trong kỳ</th>
                        <th>Tổng tiền thu hiện tại</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(filterInventorys, index) in filterInventory" :key="index">
                        <td>{{ index + 1 }}</td>
                        <td>{{ filterInventorys.tenchinhanh }}</td>
                        <td>{{ filterInventorys.ma_nv5 }}</td>
                        <td>{{ filterInventorys.ten_nv5 }}</td>
                        <td>{{ formatNumber(filterInventorys.t_tien_thuc_hien) }}</td>
                        <td>{{ formatNumber(filterInventorys.thanh_toantrongky) }}</td>
                        <td>{{ formatNumber(filterInventorys.t_tien_conno) }}</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="alert alert-warning text-end" role="alert">
            Tổng tiền thực hiện: {{ formatNumber(totalThucHien) }},
            Tổng tiền thu trong kỳ: {{ formatNumber(totalThuTrongKy) }},
            Tổng tiền nợ hiện tại: {{ formatNumber(totalTienKh) }}
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-6">
        <div class="card mt-4">
            <div class="card-header justify-content-between text-center">
                <h5 class="card-title m-0">Top 10 nhân viên Doanh số cao nhất trong kỳ</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên chi nhánh</th>
                                <th>Mã sale</th>
                                <th>Tên sale</th>
                                <th>Tổng tiền thực hiện</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(onTopOrders, index) in onTopOrder" :key="index">
                                <td>{{ index + 1 }}</td>
                                <td>{{ onTopOrders.tenchinhanh }}</td>
                                <td>{{ onTopOrders.ma_nv5 }}</td>
                                <td>{{ onTopOrders.ten_nv5 }}</td>
                                <td>{{ formatNumber(onTopOrders.t_tien_thuc_hien) }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="alert alert-warning text-end mt-2" role="alert"> Tổng tiền thực hiện (Top 10): {{
                        formatNumber(totalThucHienTopOrder) }}</div>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card mt-4">
            <div class="card-header justify-content-between text-center">
                <h5 class="card-title m-0">Top 10 nhân viên thu công nợ cao nhất trong kỳ</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên chi nhánh</th>
                                <th>Mã sale</th>
                                <th>Tên sale</th>
                                <th>Tổng tiền thu trong kỳ</th>
                                <th>Tổng nợ hiện tại</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(onTopDebtss, index) in onTopDebts" :key="index">
                                <td>{{ index + 1 }}</td>
                                <td>{{ onTopDebtss.tenchinhanh }}</td>
                                <td>{{ onTopDebtss.ma_nv5 }}</td>
                                <td>{{ onTopDebtss.ten_nv5 }}</td>
                                <td>{{ formatNumber(onTopDebtss.thanh_toantrongky) }}</td>
                                <td>{{ formatNumber(onTopDebtss.t_tien_conno) }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="alert alert-warning text-end mt-2" role="alert">Tổng tiền thu trong kỳ (Top 10): {{
                        totalThuTrongKyTopDebts }},
                    Tổng tiền nợ hiện tại (Top 10): {{ formatNumber(totalTienConNo) }} </div>
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
        const company = ref([]);
        const ds_khachhang = ref([]);
        const ds_nhanvien = ref([]);
        const ds_vattu = ref([]);
        const globalState = inject('globalState');
        const baseApi = globalState.baseApi;
        const selectedCompany = ref('002');
        const onTopOrder = ref([]);
        const filterInventory = ref([]);
        const selectedVt = ref('');
        const selectedDate = ref('');
        const onTopDebts = ref([]);
        const selectedUsers = ref('');
        const selectedCustomer = ref('');
        const selectedDateEnd = ref('');
        const isLoading = ref(false);
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
                .get(`${baseApi}/report/banhangcongno/autocomplete`, axiosConfig)
                .then((response) => {
                    company.value = response.data.ds_congty;
                    ds_khachhang.value = response.data.ds_khachhang;
                    ds_nhanvien.value = response.data.ds_nhanvien;
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
            if (selectedCustomer.value) {
                params.ma_kh = selectedCustomer.value
            }
            if (selectedCustomer.value) {
                params.ma_kh = selectedCustomer.value
            }
            if (selectedUsers.value) {
                params.ma_nhanvien = selectedUsers.value
            }
            isLoading.value = true;
            axios
                .get(`${baseApi}/report/banhangcongno/theoasm`, {
                    params: params,
                    ...axiosConfig
                })
                .then((response) => {
                    isLoading.value = false;
                    filterInventory.value = response.data.ds_banhang;
                    onTopOrder.value = response.data.ds_topdoanhso;
                    onTopDebts.value = response.data.ds_topthucongno;
                })
                .catch((error) => {
                    isLoading.value = false;
                    console.log(error);
                });
        };
        const totalThucHien = computed(() => {
            return filterInventory.value.reduce((acc, item) => acc + parseFloat(item.t_tien_thuc_hien), 0);
        });

        const totalThucHienTopOrder = computed(() => {
            return onTopOrder.value.reduce((acc, item) => acc + parseFloat(item.t_tien_thuc_hien), 0);
        });

        const totalThuTrongKy = computed(() => {
            return filterInventory.value.reduce((acc, item) => acc + parseFloat(item.thanh_toantrongky), 0);
        });

        const totalThuTrongKyTopDebts = computed(() => {
            return onTopDebts.value.reduce((acc, item) => acc + parseFloat(item.thanh_toantrongky), 0);
        });

        const totalTienKh = computed(() => {
            return filterInventory.value.reduce((acc, item) => acc + parseFloat(item.tien_kh), 0);
        });

        const totalTienConNo = computed(() => {
            return onTopDebts.value.reduce((acc, item) => acc + parseFloat(item.t_tien_conno), 0);
        });
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
        });
        return {
            company,
            ds_khachhang,
            selectedCompany,
            selectedVt,
            selectedDateEnd,
            selectedDate,
            ds_nhanvien,
            ds_vattu,
            selectedCustomer,
            selectedUsers,
            filterInventory,
            onTopOrder,
            onTopDebts,
            totalThucHien,
            totalThucHienTopOrder,
            totalThuTrongKy,
            totalThuTrongKyTopDebts,
            totalTienKh,
            totalTienConNo,
            getInventory,
            isLoading,
            formatNumber,
        };
    }
};
</script>
