<template>
<div class="row">
    <div class="col-md-6">
        <h4 class="fw-bold"><span class="text-muted fw-light">Đặt hàng <i class='bx bx-chevron-right' style="font-size: 40px;"></i></span> Mua hàng</h4>
    </div>
    <div class="col-md-6" v-if="hasPermission('customer.create')">
        <router-link :to="{ name: 'admin-users-create' }">
            <button type="button" class="btn btn-primary float-end"> <i class='bx bx-plus'></i>Thêm khách hàng</button>
        </router-link>
    </div>
</div>
<div class="row">
    <div class="col-xxl">
        <div class="card mb-4">
            <div class="card-body">
                <form>
                    <div class="row mb-3">
                        <label for="customerSelect" class="col-sm-2 col-form-label">Mã khách hàng</label>
                        <div class="col-sm-10">
                            <select disabled v-model="selectedCustomer" class="form-select" id="customerSelect" aria-label="Default select example">
                                <option value="">Chọn mã khách hàng</option>
                                <option v-for="customerItem in customer" :value="customerItem.ID" :key="customerItem.id">{{ customerItem.customer_code }}</option>
                            </select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="customerNameSelect" class="col-sm-2 col-form-label">Tên khách hàng</label>
                        <div class="col-sm-10">
                            <model-list-select :list="customer" v-model="selectedCustomer" option-value="ID" option-text="customer_name" placeholder="Chọn khách hàng"></model-list-select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="customerNameSelect" class="col-sm-2 col-form-label">Địa chỉ</label>
                        <div class="col-sm-10">
                            <select disabled v-model="selectedCustomer" class="form-select" id="customerNameSelect" aria-label="Default select example">
                                <option value="">Chọn địa chỉ</option>
                                <option v-for="customerItem in customer" :value="customerItem.ID" :key="customerItem.id">{{ customerItem.customer_ship_addr }}</option>
                            </select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="orderNote">Ghi chú</label>
                        <div class="col-sm-10">
                            <textarea id="notes" class="form-control" v-model="notes" placeholder="Ghi chú đơn hàng"></textarea>
                        </div>
                    </div>
                </form>
                <div class="row mb-0">
                    <h5 class="col-10 mb-0">Chi tiết đơn hàng</h5>
                    <div class="end-content mb-3 text-end ">
                        <button type="button" class="btn btn-primary text-end" data-bs-toggle="modal" data-bs-target="#modalScrollable">
                            Chọn sản phẩm
                        </button>
                    </div>
                </div>
                <div class="row mb-3 table-responsive text-nowrap">
                    <table class="table table-bordered md-3">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã sản phẩm</th>
                                <th>Tên sản phẩm</th>
                                <th>Giá bán</th>
                                <td>Số lượng</td>
                                <td>Thành tiền</td>
                                <td></td>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(product, index) in selectedProducts" :key="product.id">
                                <td>{{ index + 1 }}</td>
                                <td v-if="product.prd_code">{{ product.prd_code }}</td>
                                <td v-else>{{ findProductID(product) }}</td>
                                <td>
                                    <template v-if="product.prd_name">{{ product.prd_name }}</template>
                                    <template v-else>
                                        {{ findProductName(product) }}
                                    </template>
                                </td>
                                <td>{{ product.prd_sell_price }}</td>
                                <td><input class="form-control" min="0" pattern="\d*" v-model="product.quantity" type="number" @input="updateQuantity(product, $event)" id="html5-number-input"></td>
                                <td>{{ (product.prd_sell_price * product.quantity).toLocaleString() }}</td>
                                <td><button type="button" class="btn btn-danger" @click="removeProduct(product.ID)">Xóa</button></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="row mb-3">
                    <div class="modal fade" id="modalScrollable" tabindex="-1" aria-hidden="true" ref="modalRef">
                        <div class="modal-dialog modal-xl modal-dialog-scrollable" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title col-md-8" id="modalScrollableTitle">Chọn sản phẩm</h5>
                                    <input class="form-control" v-model="searchKeyword" @input="searchProducts" type="search" placeholder="Nhập tên sản phẩm hoặc mã sản phẩm" id="html5-search-input">
                                    <button type="button" class="btn-close close-model-order" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body model-order">
                                    <div class="row">
                                        <div class="col mb-3">
                                            <div class="demo-inline-spacing mt-3">
                                                <div class="list-group list-group-horizontal-md text-md-center">
                                                    <a class="list-group-item list-group-item-action active" id="home-list-item" data-bs-toggle="list" href="#trong-thau">Sản phẩm trúng thầu</a>
                                                    <a class="list-group-item list-group-item-action " id="profile-list-item" data-bs-toggle="list" href="#ngoai-thau">Sản phẩm ngoài thầu</a>
                                                </div>
                                                <div class="tab-content px-0 mt-0">
                                                    <div class="tab-pane fade show active" id="trong-thau">
                                                        <table class="table table-bordered">
                                                            <thead>
                                                                <tr>
                                                                    <th></th>
                                                                    <th>Mã sản phâm</th>
                                                                    <th>Tên sản phẩm</th>
                                                                    <th>Còn lại</th>
                                                                    <th>Giá bán</th>
                                                                    <th>Ngày hết hạn</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr v-if="customer_bids_products && customer_bids_products.length > 0" v-for="customer_bids_product in customer_bids_products">
                                                                    <td><input class="form-check-input" type="checkbox" :value="customer_bids_product.ID" @change="toggleProductCustomer(customer_bids_product.ID, $event)" /></td>
                                                                    <td>{{ products.find(x => x.ID === customer_bids_product.product_id)?.prd_code }}</td>
                                                                    <td class="name-product-order">{{ products.find(x => x.ID === customer_bids_product.product_id)?.prd_name }}</td>
                                                                    <td>{{ customer_bids_product.remain }}</td>
                                                                    <td>{{ formatNumber(customer_bids_product.prd_sell_price) }}</td>
                                                                    <td>{{ customer_bids_product.expiration_date }}</td>
                                                                </tr>
                                                                <tr v-else>
                                                                    <td colspan="6">Không có dữ liệu.</td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                    <div class="tab-pane fade" id="ngoai-thau">
                                                        <table class="table table-bordered">
                                                            <thead>
                                                                <tr>
                                                                    <th></th>
                                                                    <th>Mã sản phâm</th>
                                                                    <th>Tên sản phẩm</th>
                                                                    <th>ĐVT</th>
                                                                    <th>Giá bán</th>
                                                                    <th>Hoạt chất</th>
                                                                    <th>Nồng độ/ Hàm lượng</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr v-for="(product, index) in products" :key="product.id">
                                                                    <td>
                                                                        <input class="form-check-input" type="checkbox" :value="product.ID" @change="toggleProductSelection(product.ID, $event)" />
                                                                    </td>
                                                                    <td>{{ product.prd_code }}</td>
                                                                    <td class="name-product-order">{{ product.prd_name }}</td>
                                                                    <td>{{ product_unit.find(x => x.ID === product.prd_unit_id)?.prd_unit_name }}</td>
                                                                    <td>{{ formatNumber(product.prd_sell_price) }}</td>
                                                                    <td>{{ (product.prd_active) }}</td>
                                                                    <td>{{ (product.prd_content) }}</td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer modal-button">
                                    <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">
                                        Đóng
                                    </button>
                                    <button type="button" @click="confirmSelection" class="btn btn-primary">Đồng ý</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="alert alert-warning text-end" role="alert">Số lượng: {{ calculateTotalQuantity }} , Tiền hàng: {{ calculateTotalAmount.toLocaleString() }} , Tổng tiền: {{ calculateTotalPrice.toLocaleString() }}
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="mt-2">
                        <button @click="sendOrder" type="button" class="btn btn-primary me-2" :disabled="isSaving">Gửi</button>
                        <router-link :to="{ name: 'admin-order' }">
                            <button type="reset" class="btn btn-danger">Hủy</button>
                        </router-link>
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
    watch,
    computed,
    onMounted,
    watchEffect
} from 'vue';
import {
    useRouter
} from "vue-router";
import {
    fetchUserPermission
} from '@/utils/permission.js';
import {
    inject
} from 'vue';
import {
    useToast
} from 'vue-toast-notification';

import { ModelListSelect } from 'vue-search-select';
export default defineComponent({
    components: {
        ModelListSelect,
    },
    setup() {
        const router = useRouter();
        const userPermission = ref([]);
        const findProductName = (product) => {
            const foundProduct = products.value.find(item => item.ID === product.product_id);
            return foundProduct ? foundProduct.prd_name : 'Tên sản phẩm không khả dụng';
        };
        const findProductID = (product) => {
            const foundProductID = products.value.find(item => item.ID === product.product_id);
            return foundProductID ? foundProductID.prd_code : 'Tên sản phẩm không khả dụng';
        }
        const isSaving = ref(false);
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const currentPage = ref(1);
        const customer = ref([]);
        const products = ref([]);
        const selectedCustomer = ref('');
        const selectedProduct = ref('');
        const customer_bids_products = ref([]);
        const notes = ref('');
        const selectedProducts = ref([]);
        const product_unit = ref([]);
        const productQuantity = ref(1);
        const toast = useToast();
        const customer_bids = ref([]);
        let totalPages = ref(0);
        const searchKeyword = ref("");
        const token = localStorage.getItem('token');
        const isCheckboxChecked = ref(false);
        const selectedProductIDs = ref([]);
        const modalRef = ref(null);
        const showModal = ref(false);
        const itemsPerPage = 10;
        const selectedCustomerBidsProducts = ref([]);
        const maxDisplayedPages = 10;
        const maxDisplayedLeft = Math.floor(maxDisplayedPages / 2);
        const maxDisplayedRight = Math.ceil(maxDisplayedPages / 2);
        const displayedPages = computed(() => {
            let startPage = Math.max(currentPage.value - maxDisplayedLeft, 1);
            let endPage = Math.min(currentPage.value + maxDisplayedRight, totalPages.value);
            if (endPage - startPage + 1 < maxDisplayedPages) {
                if (currentPage.value <= maxDisplayedLeft) {
                    endPage = Math.min(endPage + maxDisplayedPages - (endPage - startPage + 1), totalPages.value);
                } else {
                    startPage = Math.max(startPage - (maxDisplayedPages - (endPage - startPage + 1)), 1);
                }
            }
            return Array.from({
                length: endPage - startPage + 1
            }, (_, i) => startPage + i);
        });

        const toggleProductSelection = (productId, event) => {
            const checked = event.target.checked;
            if (checked) {
                isCheckboxChecked.value = true;
                selectedProductIDs.value.push(productId);

            } else {
                const indexToRemove = selectedProductIDs.value.indexOf(productId);
                if (indexToRemove !== -1) {
                    selectedProductIDs.value.splice(indexToRemove, 1);
                }
            }
        };
        const formatNumber = (value) => {
            if (value !== undefined && value !== null) {
                return value.toLocaleString();
            } else {
                return '';
            }
        };
        const toggleProductCustomer = (productId, event) => {
            const checked = event.target.checked;
            if (checked) {
                isCheckboxChecked.value = true;
                selectedCustomerBidsProducts.value.push(productId);
            } else {
                const indexToRemove = selectedCustomerBidsProducts.value.indexOf(productId);
                if (indexToRemove !== -1) {
                    selectedCustomerBidsProducts.value.splice(indexToRemove, 1);
                }
            }
        };
        onMounted(async () => {
            try {
                userPermission.value = await fetchUserPermission();
            } catch (error) {
                console.error('Error fetching user roles:', error);
            }
        });

        function hasPermission(args) {
            return Object.values(userPermission.value).includes(args)
        }
        const newLine = (id, producName, quantity, price, bid_id, order_id, product_id, product_code, is_bids) => {
            return {
                ID: id,
                product_name: producName,
                quantity: quantity,
                price: price,
                bid_id: bid_id,
                order_id: order_id,
                product_id: product_id,
                product_code: product_code,
                is_bids: is_bids,
            }
        };
        const newEmptyLine = () => {
            return {
                ID: 0,
                product_name: '',
                quantity: 0.0,
                price: 0.0,
                bid_id: 0,
                order_id: 0,
                product_id: 0,
                product_code: '',
                is_bids: 0
            }
        };
        const confirmSelection = () => {
            const selectedCustomerBidsProductsToAdd = customer_bids_products.value.filter(product =>
                selectedCustomerBidsProducts.value.includes(product.ID)
            );
            const selectedProductsToAdd = products.value.filter(product =>
                selectedProductIDs.value.includes(product.ID)
            );
            newLine();
            selectedProducts.value = selectedProducts.value.concat(
                selectedCustomerBidsProductsToAdd.map(product => ({
                    ...product,
                    quantity: productQuantity.value,
                }))
            );
            selectedProducts.value = selectedProducts.value.concat(
                selectedProductsToAdd.map(product => ({
                    ...product,
                    quantity: productQuantity.value,
                }))
            );
            selectedProductIDs.value = [];
            selectedCustomerBidsProducts.value = [];
            showModal.value = false;
        };
        const addSelectedProducts = () => {
            products.value.forEach((product) => {
                if (selectedProductIDs.value.includes(product.ID)) {
                    const existingProduct = selectedProducts.value.find((p) => p.ID === product.ID);
                    if (!existingProduct) {
                        selectedProducts.value.push({
                            ...product,
                            quantity: productQuantity.value,
                        });
                    }
                    showModal.value = true;
                }
            });
            toast.success("Thêm sản phẩm thành công");
        };
        const selectAllProducts = (event) => {
            const checked = event.target.checked;
            if (checked) {
                products.value.forEach((product) => {
                    if (!selectedProducts.value.find((selectedProduct) => selectedProduct.ID === product.ID)) {
                        selectedProducts.value.push({
                            ...product,
                            quantity: productQuantity.value,
                        });
                    }
                });
                toast.success("Chọn tất cả sản phẩm thành công");
            } else {
                products.value.forEach((product) => {
                    const indexToRemove = selectedProducts.value.findIndex((selectedProduct) => selectedProduct.ID === product.ID);
                    if (indexToRemove !== -1) {
                        selectedProducts.value.splice(indexToRemove, 1);
                    }
                });
                toast.success("Bỏ chọn tất cả sản phẩm thành công");
            }
        };
        const removeProduct = (productId) => {
            const indexToRemove = selectedProducts.value.findIndex((product) => product.ID === productId);
            if (indexToRemove !== -1) {
                selectedProducts.value.splice(indexToRemove, 1);
                toast.success("Xóa sản phẩm thành công");
                const checkboxToRemove = document.querySelector(`input[type='checkbox'][value='${productId}']`);
                if (checkboxToRemove) {
                    checkboxToRemove.checked = false;
                    toggleProductSelection(productId, { target: checkboxToRemove });
                }
            }
        };
        const searchProducts = () => {
            currentPage.value = 1;
            getSop();
        }
        const sendOrder = () => {
            if (!selectedCustomer.value || selectedProducts.value.length === 0) {
                toast.error('Vui lòng điền đầy đủ thông tin đơn hàng.');
                return;
            }
            const postData = {
                customer_id: selectedCustomer.value,
                notes: notes.value,
                total_quantity: calculateTotalQuantity.value,
                total_price: calculateTotalAmount.value,
                selected_products: selectedProducts.value.map((product) => ({
                    product_id: product.ID,
                    quantity: product.quantity,
                    name: product.prd_name || findProductName(product),
                    maProduct: product.prd_code || findProductID(product),
                    price: product.prd_sell_price,
                })),
            };
            if (isSaving.value) {
                return;
            }
            isSaving.value = true;
            axios
                .post(`${baseUrl}/api/sop`, postData, {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                })
                .then((response) => {
                    console.log('Đã gửi đơn hàng thành công', response.data);
                    selectedCustomer.value = '';
                    notes.value = '';
                    selectedProducts.value = [];
                    router.push({
                        name: "admin-order"
                    });
                    toast.success('Đã gửi đơn hàng thành công');
                })
                .catch((error) => {
                    console.error('Lỗi khi gửi đơn hàng', error);
                    if (error.response) {
                        const errorMessage = error.response.data.message || 'Lỗi khi gửi đơn hàng';
                        toast.error(errorMessage);
                    } else {
                        toast.error('Lỗi khi gửi đơn hàng. Vui lòng thử lại sau.');
                    }
                }).finally(() => {
                    isSaving.value = false;
                });
        };
        watchEffect([selectedCustomer], searchKeyword, () => {
            getSop();
            selectedCustomerId();
        }, { immediate: true });
        const calculateTotalQuantity = computed(() => {
            return selectedProducts.value.reduce((total, product) => total + product.quantity, 0);
        });
        const calculateTotalAmount = computed(() => {
            return selectedProducts.value.reduce(
                (total, product) => total + product.prd_sell_price * product.quantity,
                0
            );
        });
        const updateQuantity = (product, event) => {
            const newQuantity = parseInt(event.target.value, 10);
            if (!isNaN(newQuantity) && newQuantity >= 0) {
                product.quantity = newQuantity;
            } else {
                product.quantity = 0;
            }
        }
        const calculateTotalPrice = computed(() => {
            return calculateTotalAmount.value;
        });
        const displayedProducts = computed(() => {
            const startIndex = (currentPage.value - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;
            return products.value.slice(startIndex, endIndex);
        });

        const getSop = () => {
            axios
                .get(`${baseUrl}/api/sop`, {
                    params: {
                        customer_id: selectedCustomer.value,
                        keyword: searchKeyword.value,
                    },
                })
                .then((response) => {
                    customer.value = response.data.customer;
                    products.value = response.data.products;
                    product_unit.value = response.data.product_unit;
                    customer_bids.value = response.data.customer_bids;
                })
                .catch((error) => {
                    console.error(error);
                });
        };
        const selectedCustomerId = () => {
            const postData = {
                customer_id: selectedCustomer.value,
                keyword: searchKeyword.value,
            };
            axios
                .post(`${baseUrl}/api/sop/getlist`, postData)
                .then((response) => {
                    customer_bids_products.value = response.data.customer_bids_products;
                    console.log(customer_bids_products.value);
                })
                .catch((error) => {
                    console.error(error);
                });
        };
        const filterProducts = () => {
            currentPage.value = 1;
            getSop();
        };
        const changePage = (page) => {
            if (page >= 1 && page <= totalPages.value) {
                currentPage.value = page;
                getSop();
            }
        };
        watchEffect(() => {
            getSop();
            selectedCustomerId(searchKeyword.value); 
            currentPage.value = 1; 
        });
        getSop();
        return {
            changePage,
            filterProducts,
            customer,
            selectedCustomer,
            currentPage,
            products,
            selectedProduct,
            selectedProducts,
            customer_bids_products,
            customer_bids,
            notes,
            product_unit,
            productQuantity,
            removeProduct,
            calculateTotalQuantity,
            calculateTotalAmount,
            calculateTotalPrice,
            updateQuantity,
            sendOrder,
            searchKeyword,
            searchProducts,
            toggleProductSelection,
            selectAllProducts,
            confirmSelection,
            modalRef,
            toggleProductCustomer,
            findProductName,
            findProductID,
            hasPermission,
            userPermission,
            itemsPerPage,
            displayedPages,
            currentPage,
            isSaving,
            formatNumber
        };
    },
});
</script>
