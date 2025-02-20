<template>
<div class="row">
    <div class="col-md-6">
        <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Đồng bộ dữ liệu <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách đồng bộ công nợ theo khách hàng</h4>
    </div>
</div>
<div class="card">
    <div class="card-body">
        <h6>Đồng bộ khách hàng từ phần mềm</h6>
        <form action="javascript:void(0);">
            <div class="row">
                <div>
                    <button type="button" class="btn btn-primary me-2" @click="getImportCustomer">
                        <span class=" bx bx-import"></span> Lấy dữ liệu
                    </button>

                    <button type="button" class="btn btn-primary me-2" @click="selectAllCustomers">
                        <i class='bx bx-check-square'></i> Chọn tất cả
                    </button>
                    <button type="button" class="btn btn-danger me-2" @click="selectAllRemoveCustomers">
                        <i class='bx bxs-checkbox-minus'></i> Xoá tất cả
                    </button>
                    <button type="button" class="btn btn-primary me-2" @click="filterCustomers">
                        <i class='bx bx-filter-alt'></i> Lọc dữ liệu
                    </button>
                    <button type="submit" class="btn btn-primary me-2" @click="postImportCustomer"> <i class='bx bx-export'></i> Đẩy dữ liệu</button>
                </div>
            </div>
        </form>
    </div>
    <div class="text-center" v-if="isLoading">
        <div class="spinner-border spinner-border-lg text-success" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>
    <div class="table-responsive">
        <table class="table table-striped table-borderless border-bottom">
            <thead>
                <tr>
                    <th class="text-nowrap">#</th>
                    <th class="text-nowrap">Mã hóa đơn</th>
                    <th class="text-nowrap">TÊN KHÁCH HÀNG</th>
                    <th class="text-nowrap">Địa chỉ</th>
                    <th class="text-nowrap">Mã hóa đơn</th>
                    <th class="text-nowrap">Tiền còn lại</th>
                    <th class="text-nowrap">Ngày thanh toán gân nhất</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(customers, index) in customer" :key="index">
                    <td>
                        <div class="form-check d-flex ">
                            <input class="form-check-input" type="checkbox" id="defaultCheck1" v-model="selectedCustomers" :value="customers.so_ct">
                        </div>
                    </td>
                    <td class="text-nowrap">{{customers.so_ct}}</td>
                    <td class="text-nowrap">{{customers.ten_kh}}</td>
                    <td class="text-nowrap">{{customers.dia_chi}}</td>
                    <td class="text-nowrap">{{customers.ma_hd}}</td>
                    <td class="text-nowrap">{{customers.tien_con_tt}}</td>
                    <td class="text-nowrap">{{customers.ngay_tt_gannhat}}</td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="card-body">
        <form action="javascript:void(0);">
            <div class="row">
                <div class="mt-4">
                </div>
            </div>
        </form>
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
import { useToast } from "vue-toast-notification";
import { useRouter } from "vue-router";
import {
    inject
} from 'vue';
export default {
    setup() {
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const baseApi = globalState.baseApi;
        const tokenApi = localStorage.getItem('tokensApi');
        const toast = useToast();
        const selectedCustomers = ref([]);
        const router = useRouter();
        const errors = ref({});
        const company_select = ref("");
        const customer = ref({
            output_code: "",
            order_id: "",
            customer_id: "",
            store_id: "",
            paid: "",
            unpaid: "",
            debt_status: "",
            company_id: "",
            paiddate: "",
        });
        const isLoading = ref(false);
        const customerReturn = ref([]);
        const fetchUserData = async () => {
            try {
                const token = localStorage.getItem('token');
                if (!token) {
                    throw new Error('Token not found');
                }
                const response = await axios.get(`${baseUrl}/api/profile`, {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                });
                company_select.value = response.data.company_select.toString().padStart(3, '0');
            } catch (error) {
                console.error(error);
                toast.error('Người dùng chưa đăng nhập');
            }
        };
        const axiosConfig = {
            headers: {
                Authorization: `Bearer ${tokenApi}`,
                'Content-Type': 'application/json; charset=utf-8',
                'API': 'True'
            },
        };
        const getImportCustomer = () => {
            isLoading.value = true;
            axios
                .get(`${baseApi}/sync/congno-khachhang?ma_cty=${company_select.value}`, axiosConfig)
                .then((response) => {
                    isLoading.value = false;
                    customer.value = response.data;
                    postCustomerDebts();
                })
                .catch((error) => {
                    isLoading.value = false;
                    console.log(error);
                });
        };
        const formatCustomerData = (customers) => {
            return customers.map(customer => ({
                output_code: customer.so_ct,
                ten_kh: customer.ten_kh,
                customer_id: customer.ma_kh,
                paiddate: customer.ngay_ct,
                expdate: customer.ngay_tt_dktt,
                paid: customer.tien_con_tt,
            }));
        };
        const postCustomerDebts = () => {
            const formattedData = formatCustomerData(customer.value);
            axios
                .post(`${baseUrl}/api/debtCustomer`, formattedData)
                .then((response) => {}).catch((error) => {
                    toast.error("Có lỗi khi import thất bại");
                });
        }
        const filterCustomers = () => {
            isLoading.value = true;
            const selectedCustomerData = selectedCustomers.value.map(customerId => {
                const selectedCustomer = customer.value.find(customer => customer.so_ct === customerId)
                console.log(selectedCustomer);
                return selectedCustomer ? {
                    output_code: selectedCustomer.so_ct,
                    customer_id: selectedCustomer.ma_kh,
                } : null;
            });
            axios.post(`${baseUrl}/api/debtCustomerfilter`, selectedCustomerData)
                .then((response) => {
                    toast.success("Bạn đã lọc thành công");
                    customerReturn.value = response.data;
                    isLoading.value = false;
                    const searchValues = Object.values(customerReturn.value);
                    const foundCustomers = [];
                    searchValues.forEach(searchValue => {
                        const foundCustomer = customer.value.find(customer =>
                            customer.ma_kh === searchValue.customer_id && customer.so_ct === searchValue.output_code);
                        if (foundCustomer) {
                            foundCustomers.push(foundCustomer);
                        }
                    });
                    customer.value = foundCustomers;
                })
                .catch((error) => {
                    isLoading.value = false;
                });
        }
        const selectAllCustomers = () => {
            selectedCustomers.value = customer.value.map(customer => customer.so_ct);
        };
        const selectAllRemoveCustomers = () => {
            selectedCustomers.value = [];
        };
        const postImportCustomer = () => {
            isLoading.value = true;
            if (customerReturn.value.length === 0) {
                isLoading.value = false;
                toast.error("Vui lòng lọc dữ liệu trước khi đẩy");
                return;
            }
            if (selectedCustomers.value.length === 0) {
                toast.error("Không có khách hàng nào được chọn");
                isLoading.value = false;
                return;
            }
            let hasSelectedCustomer = false;
            const promises = selectedCustomers.value.map((customerId) => {
                const selectedCustomer = customer.value.find((customer) => customer.so_ct === customerId);

                if (selectedCustomer) {
                    hasSelectedCustomer = true;
                    const formattedCustomerData = formatCustomerData([selectedCustomer]);
                    return axios.post(`${baseUrl}/api/importDebtCustomer`, formattedCustomerData);
                }
                return Promise.resolve();
            });
            if (!hasSelectedCustomer) {
                toast.error("Không có khách hàng nào được chọn");
                isLoading.value = false;
                return;
            }
            Promise.all(promises)
                .then((responses) => {
                    isLoading.value = false;
                    toast.success("Tất cả khách hàng đã được import thành công");
                    customer.value = "";
                })
                .catch((error) => {
                    if (error.response && error.response.data && error.response.data.errors) {
                        const errorData = error.response.data.errors;
                        const errorMessage = Object.values(errorData).flat().join('\n');
                        toast.error(errorMessage);
                    } else {
                        toast.error("Có lỗi khi import thất bại");
                    }
                });
        };
        onMounted(async () => {
            await fetchUserData();
            getImportCustomer();
        });
        return {
            isLoading,
            customer,
            selectedCustomers,
            selectAllCustomers,
            selectAllRemoveCustomers,
            filterCustomers,
            postImportCustomer,
            getImportCustomer,
            errors,
            customerReturn

        }
    }
}
</script>
