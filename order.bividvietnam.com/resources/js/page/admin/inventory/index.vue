<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Báo cáo tồn kho<i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách</h4>
<div class="card">
    <div class="card-body">
        <div class="row">
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Công ty</label>
                <model-list-select :list="company" v-model="selectedCompany" option-value="ma_cty" option-text="ten_cty" placeholder="Chọn công ty"></model-list-select>
            </div>
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Mẫu báo cáo</label>
                <select v-model="selectedMbc" class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                    <option value="">Chọn vật tư</option>
                    <option v-for="ds_maubaocaos in ds_maubaocao" :value="ds_maubaocaos.ma_mau" :key="ds_maubaocaos.ma_mau">
                        {{ ds_maubaocaos.ten_mau }}
                    </option>
                </select>
            </div>
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Nhóm vật tư</label>
                <model-list-select :list="ds_nhomvattu" v-model="selectedGroupVt" option-value="ma_nhvt" option-text="ten_nhvt" placeholder="Chọn nhóm vật tư"></model-list-select>
            </div>
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Mã vật tư</label>
                <model-list-select :list="ds_vattu" v-model="selectedVt" option-value="ma_vt" option-text="ten_vt" placeholder="Chọn mã vật tư"></model-list-select>
            </div>
        </div>
        <div class="row mt-3">
            <div class="col-md-3">
                <input class="form-check-input" v-model="checkboxHsd" type="checkbox" value="" id="defaultCheck3" checked="">
                <label class="form-check-label" for="defaultRadio1">
                    <p class="ml-2">sản phẩm có hạn sử dụng </p>
                </label>
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
            <div class="card-body" v-if="selectedMbc !== '02' && filterInventory.length > 0">
                <div class="table-responsive text-nowrap table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>tên chi nhánh</th>
                                <th>Tên kho hàng</th>
                                <th>loại</th>
                                <th>mã vật tư</th>
                                <th>tên vật tư - đóng gói - nsx </th>
                                <th>Đơn vị tính</th>
                                <th>lô hàng</th>
                                <th>hạn dùng </th>
                                <th>ngày nhập kho</th>
                                <th>số tháng còn lại</th>
                                <th>số ngày còn lại</th>
                                <th>số lượng</th>
                                <th>Tổng tiền</th>
                                <th>số lượng trung bình bán/tháng</th>
                                <th>tên nhvt</th>
                                <th>nha sản xuất</th>
                                <th>nhóm điều trị</th>
                                <th>tổng số lượng tồn thầu</th>
                                <th>tổng số lượng tồn thầu theo CN</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(filterInventorys, index) in filterInventory" :key="index">
                                <td>{{ index + 1 }}</td>
                                <td>{{ filterInventorys.tenchinhanh }}</td>
                                <td>{{ filterInventorys.ten_kho }}</td>
                                <td>{{ filterInventorys.loai }}</td>
                                <td @click="handleMaVtFilterClick(filterInventorys.ma_vt)"><ins class="text-primary" > <a href="javascript:void(0);">{{ filterInventorys.ma_vt }}</a></ins></td>
                                <td>{{ filterInventorys.ten_vt }}</td>
                                <td>{{ filterInventorys.dvt }}</td>
                                <td>{{ filterInventorys.ma_lo }}</td>
                                <td>{{ filterInventorys.han_dung }}</td>
                                <td>{{ filterInventorys.ngay_nhapkho }}</td>
                                <td>{{ formatNumber(filterInventorys.so_thang_hethan) }}</td>
                                <td>{{ filterInventorys.so_ngay_hethan }}</td>
                                <td>{{ formatNumber(filterInventorys.so_luong) }}</td>
                                <td>{{ formatNumber(filterInventorys.tien) }}</td>
                                <td>{{ formatNumber(filterInventorys.sl_ban_thang) }}</td>
                                <td>{{ filterInventorys.ten_nhvt }}</td>
                                <td>{{ filterInventorys.ten_plvt2 }}</td>
                                <td>{{ filterInventorys.ma_plvt3 }}</td>
                                <td>{{ formatNumber(filterInventorys.t_SLTonThau) }}</td>
                                <td>{{ formatNumber(filterInventorys.t_SLTonThau_CN) }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card-body" v-if="selectedMbc !== '01' && filterProduct.length > 0">
                <div class="table-responsive text-nowrap table-scroll table-px">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>tên nhvt</th>
                                <th>nhóm hàng</th>
                                <th>mã vật tư</th>
                                <th>tên vật tư - đóng gói - nsx </th>
                                <th>Đơn vị tính </th>
                                <th>hạn sử dụng sp </th>
                                <th>số lượng</th>
                                <th>Tổng tiền</th>
                                <th>số lượng trung bình bán/tháng</th>
                                <th>số tháng bán hết hang tồn kho theo trung bình sl bán</th>
                                <th>Số lượng tồn thầu</th>
                                <th>Số lượng đặt hàng chưa nhập kho</th>
                                <th>NHÀ SẢN xuất</th>
                                <th>nhà sản xuất</th>
                                <th>Nhóm điều trị</th>
                                <th>Loại</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(filterProducts, index) in filterProduct" :key="index">
                                <td>{{ index + 1 }}</td>
                                <td>{{ filterProducts.ten_nhvt }}</td>
                                <td>{{ filterProducts.ten_plvt1 }}</td>
                                <td @click="handleMaVtClick(filterProducts.ma_vt)"> <ins class="text-primary"><a href="javascript:void(0);">{{ filterProducts.ma_vt }}</a></ins></td>
                                <td>{{ filterProducts.ten_vt }}</td>
                                <td>{{ filterProducts.dvt }}</td>
                                <td>{{ filterProducts.han_dung_sp }}</td>
                                <td>{{ formatNumber(filterProducts.so_luong) }}</td>
                                <td>{{ formatNumber(filterProducts.tien) }}</td>
                                <td>{{ formatNumber(filterProducts.sl_ban_thang) }}</td>
                                <td>{{ formatNumber(filterProducts.so_thang_ban) }}</td>
                                <td>{{ formatNumber(filterProducts.t_soluongtonthau) }}</td>
                                <td>{{ formatNumber(filterProducts.so_luong_dat) }}</td>
                                <td>{{ filterProducts.ma_plvt2 }}</td>
                                <td>{{ filterProducts.ten_plvt2 }}</td>
                                <td>{{ filterProducts.ma_plvt3 }}</td>
                                <td>{{ filterProducts.loai}}</td>
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
                        <div class="table-responsive text-nowrap table-scroll table-px">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>STT</th>
                                        <th>Tên chi nhánh</th>
                                        <th>mã vật tư</th>
                                        <th>mã đối tượng</th>
                                        <th>Tên đối tượng</th>
                                        <th>Số lượng thầu chia theo tháng </th>
                                        <th>Số lượng thầu</th>
                                        <th>Gía trị thầu</th>
                                        <th>số lượng tồn thầu</th>
                                        <th>giá trị tồn thầu</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(ds_cttonthaus, index) in ds_cttonthauclick" :key="index">
                                        <td>{{ index + 1 }}</td>
                                        <td>{{ ds_cttonthaus.tenchinhanh }}</td>
                                        <td>{{ ds_cttonthaus.ma_vt }}</td>
                                        <td>{{ ds_cttonthaus.ma_kh }}</td>
                                        <td>{{ ds_cttonthaus.ten_kh }}</td>
                                        <td>{{ ds_cttonthaus.sl_thang }}</td>
                                        <td>{{ formatNumber(ds_cttonthaus.slThau) }}</td>
                                        <td>{{ formatNumber(ds_cttonthaus.tienThau) }}</td>
                                        <td>{{ formatNumber(ds_cttonthaus.slTonThau) }}</td>
                                        <td>{{ formatNumber(ds_cttonthaus.tienTonThau) }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="alert alert-warning text-end mt-2" role="alert">Số lượng tồn thầu chia theo
                            tháng: {{ sumSLThang }}, Số lượng thầu: {{ soluongthau }}, Giá trị thầu: {{ giatrithau }} , Số lượng
                            tồn thầu : {{ soluongtonthau }} , Giá trị tồn thầu:{{ giatritonthau }}</div>
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
                                    <tr v-for="(ds_ctbanhangs, index) in ds_ctbanhangclick" :key="index">
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
        const ds_vattu = ref([]);
        const globalState = inject('globalState');
        const baseApi = globalState.baseApi;
        const selectedCompany = ref('002');
        const ds_maubaocao = ref('');
        const ds_nhomvattu = ref([]);
        const filterInventory = ref([]);
        const selectedGroupVt = ref('');
        const checkboxHsd = ref(true);
        const selectedMbc = ref('02');
        const filterProduct = ref('');
        const selectedVt = ref('');
        const selectedDate = ref('');
        const selectedDateEnd = ref('');
        const ds_cttonthauclick = ref('');
        const ds_ctbanhang = ref([]);
        const ds_ctbanhangclick = ref('');
        const ds_cttonthau = ref([]);
        const tokenApi = localStorage.getItem('tokensApi');
        let dsCtbanhangData = [];
        let dstonthau = [];
        const axiosConfig = {
            headers: {
                Authorization: `Bearer ${tokenApi}`,
                'Content-Type': 'application/json; charset=utf-8',
                'API': 'True'
            },
        };
        const getAutoComplete = () => {
            axios
                .get(`${baseApi}/report/tonkho/autocomplete?loai=TonKho`, axiosConfig)
                .then((response) => {
                    company.value = response.data.ds_congty;
                    ds_maubaocao.value = response.data.ds_maubaocao;
                    ds_nhomvattu.value = response.data.ds_nhomvattu;
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
                hsd: checkboxHsd.value,
            };
            if (selectedVt.value) {
                params.ma_vt = selectedVt.value;
            }
            if (selectedGroupVt.value) {
                params.ma_nhvt = selectedGroupVt.value
            }

            const endpoint = selectedMbc.value === '01' ? 'theolo' : 'theosanpham';
            axios.get(`${baseApi}/report/tonkho/${endpoint}`, {
                    params: params,
                    ...axiosConfig,
                })
                .then((response) => {
                    if (selectedMbc.value === '01') {
                        filterInventory.value = response.data.ds_tonkho;
                        dsCtbanhangData = response.data.ds_ctbanhang;
                        ds_ctbanhang.value = dsCtbanhangData;
                        dstonthau = response.data.ds_cttonthau;
                        ds_cttonthau.value = dstonthau;
                    } else {
                        filterProduct.value = response.data.ds_tonkho;
                        dsCtbanhangData = response.data.ds_ctbanhang;
                        ds_ctbanhang.value = dsCtbanhangData;
                        dstonthau = response.data.ds_cttonthau;
                        ds_cttonthau.value = dstonthau;
                    }
                })
                .catch((error) => {
                    console.error(error);
                });
        };
        const handleMaVtClick = (maVt) => {
            const foundItem = filterProduct.value.find(item => item.ma_vt === maVt);
            if (foundItem) {
                const filteredDsCtbanhang = dsCtbanhangData.filter(item => item.ma_vt === foundItem.ma_vt);
                ds_ctbanhang.value = filteredDsCtbanhang;
                const filteredDsCttonthau = dstonthau.filter(item => item.ma_vt === foundItem.ma_vt);
                ds_cttonthauclick.value = filteredDsCttonthau;
            } else {
                console.log('Ma_vt not found in the inventory list');
            }
        };
        const handleMaVtFilterClick = (maVt) => {
            const foundItem = filterInventory.value.find(item => item.ma_vt === maVt);
            if (foundItem) {
                const filteredDsCtbanhang = dsCtbanhangData.filter(item => item.ma_vt === foundItem.ma_vt);
                ds_ctbanhangclick.value = filteredDsCtbanhang;
                const filteredDsCttonthau = dstonthau.filter(item => item.ma_vt === foundItem.ma_vt);
                ds_cttonthauclick.value = filteredDsCttonthau;
            } else {
                console.log('Ma_vt not found in the inventory list');
            }
        };

        function convertToNumber(value) {
            return parseFloat(value);
        }
        const sumSLThang = computed(() => {
            if (Array.isArray(ds_cttonthau.value)) {
                return ds_cttonthau.value.reduce((acc, curr) => {
                    return acc + convertToNumber(curr.sl_thang);
                }, 0);
            }
            return 0;
        });
        const soluongthau = computed(() => {
            if (Array.isArray(ds_cttonthau.value)) {
                return ds_cttonthau.value.reduce((acc, curr) => {
                    return acc + convertToNumber(curr.SLThau);
                }, 0);
            }
            return 0;
        });
        const giatrithau = computed(() => {
            if (Array.isArray(ds_cttonthau.value)) {
                return ds_cttonthau.value.reduce((acc, curr) => {
                    return acc + convertToNumber(curr.TienThau);
                }, 0);
            }
            return 0;
        });
        const soluongtonthau = computed(() => {
            if (Array.isArray(ds_cttonthau.value)) {
                return ds_cttonthau.value.reduce((acc, curr) => {
                    return acc + convertToNumber(curr.SLTonThau);
                }, 0);
            }
            return 0;
        });
        const giatritonthau = computed(() => {
            if (Array.isArray(ds_cttonthau.value)) {
                return ds_cttonthau.value.reduce((acc, curr) => {
                    return acc + convertToNumber(curr.TienTonThau);
                }, 0);
            }
            return 0;
        });
        onMounted(() => {
            getAutoComplete();
        });
        return {
            handleMaVtClick,
            handleMaVtFilterClick,
            company,
            ds_vattu,
            selectedCompany,
            selectedVt,
            selectedDateEnd,
            selectedDate,
            ds_maubaocao,
            ds_nhomvattu,
            selectedGroupVt,
            filterInventory,
            checkboxHsd,
            selectedMbc,
            filterProduct,
            ds_ctbanhang,
            ds_cttonthau,
            dstonthau,
            soluongthau,
            sumSLThang,
            giatrithau,
            soluongtonthau,
            giatritonthau,
            ds_cttonthauclick,
            ds_ctbanhangclick,
            getInventory,
            formatNumber,
        };
    }
};
</script>
