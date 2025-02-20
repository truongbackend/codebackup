<template>
<div class="row">
    <div class="col-md-6">
        <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Đồng bộ dữ liệu <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách đồng bộ sản phẩm trúng thầu</h4>
    </div>
</div>
<div class="card">
    <div class="card-body">
        <h6>Đồng bộ sản phẩm từ phần mềm</h6>
        <form action="javascript:void(0);">
            <div class="row">
                <div>
                    <button type="button" class="btn btn-primary me-2" @click="getImportProducts">
                        <span class=" bx bx-import"></span> Lấy dữ liệu
                    </button>
                    <button type="button" class="btn btn-primary me-2" @click="selectAllProducts">
                        <i class='bx bx-check-square'></i> Chọn tất cả
                    </button>
                    <button type="button" class="btn btn-danger me-2" @click="selectAllRemoveProducts">
                        <i class='bx bxs-checkbox-minus'></i> Xoá tất cả
                    </button>
                    <button type="button" class="btn btn-primary me-2" @click="filterProducts">
                        <i class='bx bx-filter-alt'></i> Lọc dữ liệu
                    </button>
                    <button type="submit" class="btn btn-primary me-2" @click="postImportProducts"> <i class='bx bx-export'></i> Đẩy dữ liệu</button>
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
                    <th class="text-nowrap">Mã sản phẩm</th>
                    <th class="text-nowrap">Tên sản phẩm</th>
                    <th class="text-nowrap">Đơn vị tính</th>
                    <th class="text-nowrap">Giá bán</th>
                    <th class="text-nowrap">Số lượng thầu</th>
                    <th class="text-nowrap">Tên khách hàng</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(product, index) in products" :key="index">
                    <td>
                        <div class="form-check d-flex ">
                            <input class="form-check-input" type="checkbox" id="defaultCheck1" v-model="selectedProducts" :value="product.ma_vt">
                        </div>
                    </td>
                    <td class="text-nowrap">{{ product.ma_vt }}</td>
                    <td class="text-nowrap formart">{{ product.ten_vt }}</td>
                    <td class="text-nowrap">{{ product.dvt }}</td>
                    <td class="text-nowrap">{{ product.gia_th }}</td>
                    <td class="text-nowrap">{{ product.so_luong_th }}</td>
                    <td class="text-nowrap formart">{{ product.ten_kh }}</td>
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
        const router = useRouter();
        const errors = ref({});
        const products = ref([]);
        const productsReturn = ref([]);
        const company_select = ref("");
        const selectedProducts = ref([]);
        const isLoading = ref(false);
        const axiosConfig = {
            headers: {
                Authorization: `Bearer ${tokenApi}`,
                'Content-Type': 'application/json; charset=utf-8',
                'API': 'True'
            },
        };
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
        const getImportProducts = () => {
            isLoading.value = true;
            axios
                .get(`${baseApi}/sync/sanpham-trungthau?ma_cty=${company_select.value}`, axiosConfig)
                .then((response) => {
                    isLoading.value = false;
                    products.value = response.data;
                    postProduct();
                })
                .catch((error) => {
                    isLoading.value = false;
                    console.log(error);
                });
        };
        const formatCustomerData = (products) => {
            return products.map(product => ({
                prd_code: product.ma_vt,
                ten_kh: product.ten_kh,
                expiration_dat: product.ngay_kt_hd,
                quantity: product.so_luong_th,
                customer_id: product.ma_sale,
                product_id: product.ma_vt,
                prd_sell_price: product.gia_th,
                expiration_date: product.ngay_kt_hd
            }));
        };
        const postProduct = () => {
            const formattedData = formatCustomerData(products.value);
            axios
                .post(`${baseUrl}/api/productImportWinning`, formattedData)
                .then((response) => {}).catch((error) => {
                    toast.error("Có lỗi khi import thất bại");
                });
        }
        const filterProducts = () => {
            isLoading.value = true;
            const selectedProductsCodes = selectedProducts.value.map(productsId => {
                const selectedProducts = products.value.find(products => products.ma_vt === productsId);
                return selectedProducts ? {
                    prd_code: selectedProducts.ma_vt,
                    customer_id: selectedProducts.ma_sale
                } : null;
            });
            axios
                .post(`${baseUrl}/api/productWinningFilter`, selectedProductsCodes)
                .then((response) => {
                    toast.success("Bạn đã lọc thành công");
                    productsReturn.value = response.data;
                    isLoading.value = false;
                    const searchValues = Object.values(productsReturn.value);
                    const foundCustomers = [];
                    searchValues.forEach(searchValue => {
                        const foundCustomer = products.value.find(product =>
                            product.ma_vt === searchValue.prd_code);
                        if (foundCustomer) {
                            foundCustomers.push(foundCustomer);
                        }
                    });
                    products.value = foundCustomers;
                })
                .catch((error) => {
                    isLoading.value = false;
                    toast.error("Không có sản phẩm nào được chọn");
                });
        }
        const selectAllProducts = () => {
            selectedProducts.value = products.value.map(products => products.ma_vt);
        };
        const selectAllRemoveProducts = () => {
            selectedProducts.value = [];
        };
        const formatPostProducts = (products) => {
            return products.map(product => ({
                prd_code: product.ma_vt,
                ten_kh: product.ten_kh,
                expiration_dat: product.ngay_kt_hd,
                quantity: product.so_luong_th,
                customer_id_product: product.ma_sale,
                product_code: product.ma_vt,
                prd_sell_price: product.gia_th,
                expiration_date: product.ngay_kt_hd
            }));
        };

        const postImportProducts = () => {
            isLoading.value = true;
            if (productsReturn.value.length === 0) {
                isLoading.value = false;
                toast.error("Vui lòng lọc dữ liệu trước khi đẩy");
                return; 
            }
            if (selectedProducts.value.length === 0) {
                toast.error("Không có khách hàng nào được chọn");
                isLoading.value = false;
                return;
            }
            let hasSelectedCustomer = false;
            const formattedSelectedProducts = formatPostProducts(
                selectedProducts.value.map(productId =>
                    products.value.find(product => product.ma_vt === productId))
                .filter(product => product !== undefined)
            );
            const promises = formattedSelectedProducts.map(formattedProduct => {
                hasSelectedCustomer = true;
                return axios.post(`${baseUrl}/api/importProductWinning`, formattedProduct);
            });
            if (!hasSelectedCustomer) {
                toast.error("Không có sản phẩm nào được chọn");
                isLoading.value = false;
                return;
            }
            Promise.all(promises)
                .then((responses) => {
                    products.value = "";
                    isLoading.value = false;
                    toast.success("Tất cả sản phẩm đã được import thành công");
                })

                .catch((error) => {
                    if (error.response && error.response.data && error.response.data.errors) {
                        const errorData = error.response.data.errors;
                        const errorMessage = Object.values(errorData).flat().join('\n');
                        toast.error(errorMessage);
                    } else {
                        toast.error("Không có sản phẩm nào được chọn");
                    }
                });
        };
        onMounted(async () => {
            await fetchUserData();
            getImportProducts();
            postProduct();
        });
        return {
            isLoading,
            products,
            selectedProducts,
            selectAllProducts,
            selectAllRemoveProducts,
            filterProducts,
            postImportProducts,
            getImportProducts,
            errors,
            productsReturn

        }
    }

}
</script>
