<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Báo cáo hàng huỷ<i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách</h4>
<div class="card">
    <div class="card-body">
        <div class="row">
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Công ty</label>
                <model-list-select :list="company" v-model="selectedCompany" option-value="ma_cty" option-text="ten_cty" placeholder="Chọn công ty"></model-list-select>
            </div>
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Nhóm vật tư</label>
                <model-list-select :list="ds_vattu" v-model="selectedVt" option-value="ma_vt" option-text="ten_vt" placeholder="Chọn mã vật tư"></model-list-select>
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

<div class="row">
    <div class="col-md">
        <div class="card mt-4">
            <div class="card-body">
                <div class="table-responsive text-nowrap table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên chi nhánh</th>
                                <th>mã vật tư</th>
                                <th>tên vật tư - đóng gói - nsx </th>
                                <th>Đơn vị tính</th>
                                <th>Hạn sử dụng sp</th>
                                <th>số lô batch No.</th>
                                <th>Hạn dùng EXP.data</th>
                                <th>Số ngày còn lại</th>
                                <th>Ngày nhập kho</th>
                                <th>Số lượng</th>
                                <th>Đơn giá</th>
                                <th>Tổng tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(filterInventorys, index) in filterInventory" :key="index">
                                <td>{{ index + 1 }}</td>
                                <td>{{ filterInventorys.tenchinhanh }}</td>
                                <td>{{ filterInventorys.ma_vt }}</td>
                                <td class="content-table-customer">{{ filterInventorys.ten_vt }}</td>
                                <td>{{ filterInventorys.e_dvt_qd }}</td>
                                <td>{{ filterInventorys.han_dung_sp }}</td>
                                <td>{{ filterInventorys.e_malo }}</td>
                                <td>{{ filterInventorys.e_han_dung }}</td>
                                <td>{{ filterInventorys.so_ngay_cl }}</td>
                                <td>{{ filterInventorys.ngay_nhapkho }}</td>
                                <td>{{ formatNumber(filterInventorys.so_luong) }}</td>
                                <td>{{ formatNumber(filterInventorys.don_gia) }}</td>
                                <td>{{ formatNumber(filterInventorys.tien) }}</td>
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
import { defineComponent, ref, onMounted, watchEffect } from 'vue';
import { inject } from 'vue';
import { ModelListSelect } from 'vue-search-select';
export default {
    components: {
        ModelListSelect,
    },
    setup() {
        const company = ref([]);
        const ds_vattu = ref([]);
        const globalState = inject('globalState');
        const baseApi = globalState.baseApi;
        const selectedCompany = ref('002');
        const selectedVt = ref('');
        const selectedDate = ref('');
        const selectedDateEnd = ref('');
        const filterInventory = ref([]);
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
                .get(`${baseApi}/report/hanghuy/autocomplete`, axiosConfig)
                .then((response) => {
                    company.value = response.data.ds_congty;
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
            axios
                .get(`${baseApi}/report/hanghuy`, {
                    params: params,
                    ...axiosConfig
                })
                .then((response) => {
                    filterInventory.value = response.data;
                    console.log(filterInventory.value);
                })
                .catch((error) => {
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

        onMounted(() => {
            getAutoComplete();
            getInventory();
            getCurrentYearDates();
        });
        return {
            company,
            ds_vattu,
            selectedCompany,
            selectedVt,
            selectedDateEnd,
            selectedDate,
            filterInventory,
            getInventory,
            formatNumber,
        };
    },
};
</script>
