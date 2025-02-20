<template>
<div class="row">
    <div class="col-md-6">
        <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Đồng bộ dữ liệu <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách đồng bộ sản phẩm</h4>
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
                    <th class="text-nowrap">Mã SP</th>
                    <th class="text-nowrap">Tên SP</th>
                    <th class="text-nowrap">HOẠT CHẤT</th>
                    <th class="text-nowrap">NỒNG ĐỘ/HÀM LƯỢNG</th>
                    <th class="text-nowrap">Gía bán</th>
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
                    <td class="text-nowrap formart">{{ product.hoatchat }}</td>
                    <td class="text-nowrap">{{ product.prd_active }}</td>
                    <td class="text-nowrap">{{ product.giakekhai }}</td>
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
        const selectedProducts = ref([]);
        const company_select = ref("");
        const isLoading = ref(false);
        const dateProduct = ref([]);
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
            axios
            .get(`${baseUrl}/api/getDateCustomer`)
                .then(response => {
                    dateProduct.value = response.data[0];
                    const TuNgay = dateProduct.value.date_Product;
                    console.log(dateProduct.value);
                    const today = new Date();
                    const DenNgay = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`;
                    isLoading.value = true;
                    axios
            isLoading.value = true;
            axios
                .get(`${baseApi}/sync/san-pham?ma_cty=${company_select.value}&TuNgay=${TuNgay}&DenNgay=${DenNgay}`, axiosConfig)
                .then((response) => {
                    isLoading.value = false;
                    products.value = response.data;
                    postProduct();
                })
                .catch((error) => {
                    isLoading.value = false;
                    console.log(error);
                });
            })
                .catch(error => {
                    console.log(error);
                });
        };
        const formatPostProducts = (products) => {
            return products.map(product => ({
                prd_code: product.ma_vt,
                prd_name: product.ten_vt,
                prd_content: product.mo_ta,
                prd_sell_price: product.giakekhai,
                prd_descriptions: product.mo_ta,
                prd_active:product.hoatchat
            }));
        };
        const postProduct = () => {
            const formattedData = formatPostProducts(products.value);
            axios
                .post(`${baseUrl}/api/productImport`, formattedData)
                .then((response) => {}).catch((error) => {
                    toast.error("Có lỗi khi import thất bại");
                });
        }
        const filterProducts = () => {
            isLoading.value = true;
            const selectedProductsCodes = selectedProducts.value.map(productsId => {
                const selectedProducts = products.value.find(products => products.ma_vt === productsId);
                return selectedProducts ? selectedProducts.ma_vt : null;
            });
            axios
                .post(`${baseUrl}/api/productsFilter`, selectedProductsCodes)
                .then((response) => {
                    toast.success("Bạn đã lọc thành công");
                    productsReturn.value = response.data;
                    isLoading.value = false;
                    const searchValues = Object.values(productsReturn.value);
                    const foundProducts = [];
                    searchValues.forEach(searchValue => {
                        const foundProduct = products.value.find(products => products.ma_vt.trim() === searchValue);
                        if (foundProduct) {
                            foundProducts.push(foundProduct);
                        }
                    });
                    products.value = foundProducts;
                })
                .catch((error) => {
                    isLoading.value = false;
                });
        }
        const selectAllProducts = () => {
            selectedProducts.value = products.value.map(products => products.ma_vt);
        };
        const selectAllRemoveProducts = () => {
            selectedProducts.value = [];
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
            const formattedData = formatPostProducts(products.value);
            let hasSelectedCustomer = false;
            const promises = selectedProducts.value.map((productId) => {
                const selectedProduct = formattedData.find((product) => product.prd_code === productId)
                if (selectedProduct) {
                    hasSelectedCustomer = true;
                    return axios.post(`${baseUrl}/api/products`, selectedProduct);
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
                    toast.success("Tất cả sản phẩm đã được import thành công");
                    products.value ="";
                    const currentDate = new Date().toISOString().split('T')[0];
                    return axios.post(`${baseUrl}/api/importDateCustomer`, {
                        dateProduct: currentDate
                    });
                })
                .catch((error) => {
                    if (selectedProducts.value.length === 0) {
                        toast.error("Vui lòng chọn ít nhất một sản phẩm để import");
                    } else {
                        toast.error("Có lỗi khi import sản phẩm");
                    }
                });
        };
        onMounted(async () => {
            await fetchUserData();
            getImportProducts();
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
            productsReturn,
            dateProduct
        }
    }
}
</script>
