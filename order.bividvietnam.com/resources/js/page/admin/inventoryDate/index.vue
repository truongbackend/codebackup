<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Báo cáo tồn kho Hạn sử dụng dưới 12 tháng<i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách</h4>
<div class="card">
    <div class="card-body">
        <div class="row">
            <div class="col-md-4">
                <label for="exampleFormControlSelect1" class="form-label">Công ty</label>
                <model-list-select :list="company" v-model="selectedCompany" option-value="ma_cty" option-text="ten_cty" placeholder="Chọn công ty"></model-list-select>
            </div>
            <div class="col-md-4">
                <label for="exampleFormControlSelect1" class="form-label">Nhóm vật tư</label>
                <model-list-select :list="ds_nhomvattu" v-model="selectedGroupVt" option-value="ma_nhvt" option-text="ten_nhvt" placeholder="Chọn nhóm vật tư"></model-list-select>
            </div>
            <div class="col-md-4">
                <label for="exampleFormControlSelect1" class="form-label">Mã vật tư</label>
                <model-list-select :list="ds_vattu" v-model="selectedVt" option-value="ma_vt" option-text="ten_vt" placeholder="Chọn mã vật tư"></model-list-select>
            </div>
        </div>
        <div class="row mt-3">
            <div class="col-md-3">
                <input class="form-check-input" v-model="checkboxHsd" type="checkbox" value="" id="defaultCheck3" checked="">
                <label class="form-check-label mf-2" for="defaultRadio1"> Chỉ hiển thị sản phẩm có hạn sử dụng </label>
            </div>
            <div class="col-md-9">
                <button type="button" class="btn btn-outline-danger float-end" @click="getInventory">
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
                                <th>No</th>
                                <th>Tên chi nhánh</th>
                                <th class="content-table-customer">tên kho hàng</th>
                                <th>loại</th>
                                <th>mã vật tư</th>
                                <th class="content-table-customer">tên vật tư - đóng gói - nsx </th>
                                <th>Đơn vị tính</th>
                                <th>Hạn sử dụng sản phẩm</th>
                                <th>lô hàng</th>
                                <th>hạn dùng </th>
                                <th>ngày nhập kho</th>
                                <th>số tháng còn lại</th>
                                <th>số ngày còn lại</th>
                                <th>số lượng</th>
                                <th>Tổng tiền</th>
                                <th>số lượng trung bình bán/tháng</th>
                                <th>Nhóm điều trị</th>
                                <th>tên nhóm vật tư</th>
                                <th>nhà sản xuất</th>
                                <th>tổng số lượng tồn thầu</th>
                                <th>tổng số lượng tồn thầu theo CN</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(filterInventorys, index) in filterInventory" :key="index">
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ index + 1 }}</td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ filterInventorys.tenchinhanh }}
                                </td>
                                <td class="content-table-customer" @click="handleMaVtClick(filterInventorys.ma_vt)"><a>{{
                                        filterInventorys.ten_kho }}</a></td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ filterInventorys.loai }}</td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)"><ins class="text-primary"><a href="javascript:void(0);">{{ filterInventorys.ma_vt }}</a></ins></td>
                                <td class="content-table-customer">{{ filterInventorys.ten_vt }}</td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ filterInventorys.dvt }}</td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ filterInventorys.han_dung_sp }}
                                </td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ filterInventorys.ma_lo }}</td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ filterInventorys.han_dung }}
                                </td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ filterInventorys.ngay_nhapkho }}
                                </td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ filterInventorys.so_thang_hethan
                                    }}</td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ filterInventorys.so_ngay_hethan
                                    }}</td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ filterInventorys.so_luong }}
                                </td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ formatNumber(filterInventorys.tien) }}</td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ formatNumber(filterInventorys.sl_ban_thang) }}
                                </td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ filterInventorys.ma_plvt3 }}
                                </td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ filterInventorys.ten_nhvt }}
                                </td>
                                
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ filterInventorys.ten_plvt2 }}
                                </td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ formatNumber(filterInventorys.t_SLTonThau) }}
                                </td>
                                <td @click="handleMaVtClick(filterInventorys.ma_vt)">{{ formatNumber(filterInventorys.t_SLTonThau_CN)}}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="row mt-4">
    <div class="col-md-12">
        <ul class="nav nav-pills flex-column flex-md-row mb-3">
            <li class="nav-item">
                <button type="button" class="nav-link active" role="tab" data-bs-toggle="tab" data-bs-target="#navs-pills-top-home" aria-controls="navs-pills-top-home" aria-selected="true">
                    Chi tiết tồn thầu
                </button>
            </li>
            <li class="nav-item">
                <button type="button" class="nav-link" role="tab" data-bs-toggle="tab" data-bs-target="#navs-pills-top-profile" aria-controls="navs-pills-top-profile" aria-selected="false">
                    Chi tiết bán hàng từng tháng của năm trước của tổng công ty
                </button>
            </li>
        </ul>
        <div class="card mb-4">
            <div class="tab-content">
                <div class="tab-pane fade show active" id="navs-pills-top-home" role="tabpanel">
                    <div class="card-body">
                        <div class="table-responsive text-nowrap">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>STT</th>
                                        <th>Số chứng từ</th>
                                        <th>Tên chi nhánh</th>
                                        <th>mã đối tượng</th>
                                        <th>tên đối tượng</th>
                                        <th>Ngày kết thúc</th>
                                        <th>số lượng tháng còn lại </th>
                                        <th>Số lượng thầu</th>
                                        <th>số lượng tồn thầu chia theo tháng</th>
                                        <th>giá trị thầu</th>
                                        <th>số lượng tồn thầu</th>
                                        <th>giá trị tồn thầu</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(ds_cttonthaus, index) in ds_cttonthaus" :key="index">
                                        <td>{{ index + 1 }}</td>
                                        <td>{{ ds_cttonthaus.so_ct }}</td>
                                        <td>{{ ds_cttonthaus.tenchinhanh }}</td>
                                        <td>{{ ds_cttonthaus.ma_kh }}</td>
                                        <td>{{ ds_cttonthaus.ten_kh }}</td>
                                        <td>{{ ds_cttonthaus.ngay_kt_hd }}</td>
                                        <td>{{ ds_cttonthaus.so_thang }}</td>
                                        <td>{{ formatNumber(ds_cttonthaus.slThau) }}</td>
                                        <td>{{ formatNumber(ds_cttonthaus.sl_thang) }}</td>
                                        <td>{{ formatNumber(ds_cttonthaus.tienThau) }}</td>
                                        <td>{{ formatNumber(ds_cttonthaus.slTonThau) }}</td>
                                        <td>{{ formatNumber(ds_cttonthaus.tienTonThau) }}</td>
                                    </tr>
                                </tbody>
                            </table>

                        </div>
                        <div class="alert alert-warning text-end mt-2" role="alert">
                            Số lượng thầu: {{ formatNumber(totalSLThau) }},
                            số lượng tồn thầu chia theo tháng: {{ formatNumber(totalTienThau) }},
                            giá trị thầu: {{ formatNumber(totalSLTonThau) }},
                            số lượng tồn thầu: {{ formatNumber(totalSLTonThau) }},
                            Giá trị tồn thầu: {{ formatNumber(totalTienTonThau) }}
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade show" id="navs-pills-top-profile" role="tabpanel">
                    <div class="card-body">
                        <div class="table-responsive text-nowrap">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>STT</th>
                                        <th>Tháng 1</th>
                                        <th>Tháng 2</th>
                                        <th>Tháng 3</th>
                                        <th>Tháng 4</th>
                                        <th>Tháng 5</th>
                                        <th>Tháng 6</th>
                                        <th>Tháng 7</th>
                                        <th>Tháng 8</th>
                                        <th>Tháng 9</th>
                                        <th>Tháng 10</th>
                                        <th>Tháng 11</th>
                                        <th>Tháng 12</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(ds_ctbanhangs, index) in ds_ctbanhangs" :key="index">
                                        <td>{{ index + 1 }}</td>
                                        <td>{{ formatNumber(ds_ctbanhangs.thang1) }}</td>
                                        <td>{{ formatNumber(ds_ctbanhangs.thang2) }}</td>
                                        <td>{{ formatNumber(ds_ctbanhangs.thang3) }}</td>
                                        <td>{{ formatNumber(ds_ctbanhangs.thang4) }}</td>
                                        <td>{{ formatNumber(ds_ctbanhangs.thang5) }}</td>
                                        <td>{{ formatNumber(ds_ctbanhangs.thang6) }}</td>
                                        <td>{{ formatNumber(ds_ctbanhangs.thang7) }}</td>
                                        <td>{{ formatNumber(ds_ctbanhangs.thang8) }}</td>
                                        <td>{{ formatNumber(ds_ctbanhangs.thang9) }}</td>
                                        <td>{{ formatNumber(ds_ctbanhangs.thang10) }}</td>
                                        <td>{{ formatNumber(ds_ctbanhangs.thang11) }}</td>
                                        <td>{{ formatNumber(ds_ctbanhangs.thang12) }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
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
        const company = ref([]);
        const ds_nhanvien = ref('');
        const ds_vattu = ref([]);
        const globalState = inject('globalState');
        const baseApi = globalState.baseApi;
        const selectedCompany = ref('002');
        const filterInventory = ref([]);
        const selectedVt = ref('');
        const selectedDate = ref('');
        const ds_nhomvattu = ref([]);
        const selectedUsers = ref('');
        const selectedGroupVt = ref('');
        const selectedDateEnd = ref('');
        const checkboxHsd = ref(true);
        const ds_ctbanhang = ref([]);
        const ds_cttonthau = ref([]);
        const ds_ctbanhangs = ref('');
        const ds_cttonthaus = ref('');
        let dsCtbanhangData = [];
        const tokenApi = localStorage.getItem('tokensApi');
        let dstonthau = [];
        const getAutoComplete = () => {
            const axiosConfig = {
                headers: {
                    Authorization: `Bearer ${tokenApi}`,
                    'Content-Type': 'application/json; charset=utf-8',
                    'API': 'True'
                },
            };
            axios
                .get(`${baseApi}/report/tonkho/autocomplete?loai=TonKhoHSDDuoi12Thang`, axiosConfig)
                .then((response) => {
                    company.value = response.data.ds_congty;
                    ds_nhomvattu.value = response.data.ds_nhomvattu;
                    ds_vattu.value = response.data.ds_vattu,
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
                hsd: checkboxHsd.value,
            };
            if (selectedVt.value) {
                params.ma_vt = selectedVt.value;
            }
            if (selectedGroupVt.value) {
                params.ma_nhvt = selectedGroupVt.value
            }
            axios
                .get(`${baseApi}/report/tonkho/hsdduoi12thang`, {
                    params: params,
                    ...axiosConfig
                })
                .then((response) => {
                    filterInventory.value = response.data.ds_tonkho;
                    console.log(filterInventory.value);
                    dsCtbanhangData = response.data.ds_ctbanhang;
                    ds_ctbanhang.value = dsCtbanhangData;
                    console.log(ds_ctbanhang.value);
                    dstonthau = response.data.ds_cttonthau;
                    ds_cttonthau.value = dstonthau;
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        const handleMaVtClick = (maVt) => {
            const foundItem = filterInventory.value.find(item => item.ma_vt === maVt);
            console.log(foundItem);

            if (foundItem) {
                const filteredDsCtbanhang = dsCtbanhangData.filter(item => item.ma_vt === foundItem.ma_vt);
                ds_ctbanhangs.value = filteredDsCtbanhang;
                const filteredDsCtbanhangloc = dstonthau.filter(item => item.ma_vt === foundItem.ma_vt);
                ds_cttonthaus.value = filteredDsCtbanhangloc;
            } else {
                console.log('Ma_vt not found in the inventory list');
            }
        };
        const totalSLThau = computed(() => {
            return ds_cttonthau.value.reduce((total, item) => total + parseFloat(item.SLThau), 0);
        });

        const totalSLThang = computed(() => {
            return ds_cttonthau.value.reduce((total, item) => total + parseFloat(item.sl_thang), 0);
        });

        const totalTienThau = computed(() => {
            return ds_cttonthau.value.reduce((total, item) => total + parseFloat(item.TienThau), 0);
        });

        const totalSLTonThau = computed(() => {
            return ds_cttonthau.value.reduce((total, item) => total + parseFloat(item.SLTonThau), 0);
        });

        const totalTienTonThau = computed(() => {
            return ds_cttonthau.value.reduce((total, item) => total + parseFloat(item.TienTonThau), 0);
        });

        onMounted(() => {
            getAutoComplete();
            getInventory();
        });
        return {
            handleMaVtClick,
            company,
            selectedCompany,
            selectedVt,
            selectedDateEnd,
            selectedDate,
            ds_nhanvien,
            ds_vattu,
            selectedGroupVt,
            selectedUsers,
            filterInventory,
            ds_nhomvattu,
            checkboxHsd,
            ds_ctbanhang,
            ds_cttonthau,
            dstonthau,
            totalSLThau,
            totalSLThang,
            totalTienThau,
            totalSLTonThau,
            totalTienTonThau,
            getInventory,
            ds_cttonthaus,
            ds_ctbanhangs,
            formatNumber,
        };
    }
};
</script>
