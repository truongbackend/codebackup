<template>
<div class="row">
    <div class="col-md-6">
        <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Đồng bộ dữ liệu <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách đồng bộ khách hàng</h4>
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
                    <th class="text-nowrap">Mã KH</th>
                    <th class="text-nowrap">Tên KH</th>
                    <th class="text-nowrap">Điện thoại</th>
                    <th class="text-nowrap">Email</th>
                    <th class="text-nowrap">Địa chỉ</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(customers, index) in customer" :key="index">
                    <td>
                        <div class="form-check d-flex ">
                            <input class="form-check-input" type="checkbox" id="defaultCheck1" v-model="selectedCustomers" :value="customers.ma_kh">
                        </div>
                    </td>
                    <td class="text-nowrap">{{customers.ma_kh}}</td>
                    <td class="text-nowrap formart">{{customers.ten_kh}}</td>
                    <td class="text-nowrap">{{customers.tel}}</td>
                    <td class="text-nowrap formart">{{customers.email}}</td>
                    <td class="text-nowrap formart">{{customers.dia_chi}}</td>
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
import {
    useToast
} from "vue-toast-notification";
import {
    useRouter
} from "vue-router";
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
        const router = useRouter();
        const errors = ref({});
        const customer = ref({
            customer_code: "",
            customer_name: "",
            customer_email: "",
            customer_phone: "",
            customer_addr: "",
            customer_ship_addr: "",
            customer_store: "",
            notes: "",
            customer_image: "",
            created: Date(),
        });
        const isLoading = ref(false);
        const company_select = ref("");
        const customerReturn = ref([]);
        const dateCustomer = ref([]);
        const selectedCustomers = ref([]);
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
            axios
                .get(`${baseUrl}/api/getDateCustomer`)
                .then(response => {
                    dateCustomer.value = response.data[0];
                    let TuNgay; 

                    if (company_select.value == '001') {
                        TuNgay = dateCustomer.value.date_Customer_Bileje;
                    } else if (company_select.value == '002') {
                        TuNgay = dateCustomer.value.date_Customer;
                    } else {
                        TuNgay = dateCustomer.value.date_Customer_Dbl;
                    }

                    const today = new Date();
                    const DenNgay = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`;

                    isLoading.value = true;
                    axios
                        .get(`${baseApi}/sync/khach-hang?ma_cty=${company_select.value}&TuNgay=${TuNgay}&DenNgay=${DenNgay}`, axiosConfig)
                        .then(response => {
                            isLoading.value = false;
                            customer.value = response.data;
                            postCustomer();
                        })
                        .catch(error => {
                            isLoading.value = false;
                            console.log(error);
                        });
                })
                .catch(error => {
                    console.log(error);
                });
        };

        const filterCustomers = () => {
            isLoading.value = true;
            const selectedCustomerCodes = selectedCustomers.value.map(customerId => {
                const selectedCustomer = customer.value.find(customer => customer.ma_kh === customerId);
                return selectedCustomer ? selectedCustomer.ma_kh : null;
            });
            axios
                .post(`${baseUrl}/api/customersFilter`, selectedCustomerCodes)
                .then((response) => {
                    toast.success("Bạn đã lọc thành công");
                    customerReturn.value = response.data;
                    isLoading.value = false;
                    const searchValues = Object.values(customerReturn.value);
                    const foundCustomers = [];
                    searchValues.forEach(searchValue => {
                        const foundCustomer = customer.value.find(customer => customer.ma_kh.trim() === searchValue);
                        if (foundCustomer) {
                            foundCustomers.push(foundCustomer);
                        }
                    });
                    customer.value = foundCustomers;
                })
                .catch((error) => {
                    isLoading.value = false;
                    toast.error("Có lỗi khi import thất bại");
                });
        }
        const formatCustomerData = (customers) => {
            return customers.map(customer => ({
                customer_code: customer.ma_kh,
                customer_name: customer.ten_kh,
                customer_phone: customer.tel,
                customer_email: customer.email,
                customer_addr: customer.dia_chi,
                customer_ship_addr: customer.dia_chi,
                notes: customer.ghi_chu,
            }));
        };
        const postCustomer = () => {
            const formattedData = formatCustomerData(customer.value);
            axios
                .post(`${baseUrl}/api/customersImport`, formattedData)
                .then((response) => {}).catch((error) => {
                    toast.error("Có lỗi khi import thất bại");
                });
        }

        const selectAllCustomers = () => {
            selectedCustomers.value = customer.value.map(customer => customer.ma_kh);
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
            const formattedData = formatCustomerData(customer.value);
            let hasSelectedCustomer = false;
            const promises = selectedCustomers.value.map((customerId) => {
                const selectedCustomer = formattedData.find(customer => customer.customer_code === customerId);
                if (selectedCustomer) {
                    hasSelectedCustomer = true;
                    return axios.post(`${baseUrl}/api/customers`, selectedCustomer)
                        .then(response => ({
                            success: true,
                            customer: selectedCustomer
                        }))
                        .catch(error => ({
                            success: false,
                            error
                        }));
                }
                return Promise.resolve({
                    success: false
                });
            });
            if (!hasSelectedCustomer) {
                toast.error("Không có khách hàng nào được chọn");
                isLoading.value = false;
                return;
            }
            Promise.all(promises)
                .then(results => {
                    const successfulImports = results.filter(result => result.success);
                    if (successfulImports.length === 0) {
                        throw new Error("Không có khách hàng nào được import thành công");
                    }
                    const lastImportedCustomer = successfulImports[successfulImports.length - 1].customer;
                    const currentDate = new Date().toISOString().split('T')[0];
                    return axios.post(`${baseUrl}/api/importDateCustomer`, {
                        date: currentDate
                    });
                })
                .then(() => {
                    isLoading.value = false;
                    toast.success("Tất cả khách hàng đã được import thành công");
                    customer.value = "";
                })
                .catch(error => {
                    isLoading.value = false;
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
            customerReturn,
            dateCustomer

        }
    }
}
</script>
