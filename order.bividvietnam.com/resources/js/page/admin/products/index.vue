<template>
<h4 class="fw-bold">
    <span class="text-muted fw-light">Sản phẩm <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách sản phẩm
</h4>
<div class="card">
    <div class="card-body">
        <div class="row">
            <div class="col-md-4">
                <label for="exampleFormControlSelect1" class="form-label">Danh mục</label>
                <model-list-select :list="category" v-model="selectedCategory" option-value="ID" option-text="prd_group_name" placeholder="Chọn danh mục"></model-list-select>
            </div>
            <div class="col-md-4">
                <label for="exampleFormControlSelect1" class="form-label">Nhà cung cấp</label>
                <model-list-select :list="producer" v-model="selectedManufacturer" option-value="ID" option-text="prd_manuf_name" placeholder="Chọn nhà cung cấp"></model-list-select>
            </div>
            <div class="col-md-4">
                <label for="exampleFormControlSelect1" class="form-label">Trạng thái</label>
                <select v-model="selectedStatus" @change="filterProducts" class="form-select">
                    <option value="">Chọn trạng thái</option>
                    <option value="1">Hoạt động</option>
                    <option value="0">Ngưng hoạt đông</option>
                </select>
            </div>
        </div>
    </div>
    <div class="card-header d-flex align-items-center justify-content-between search-model">
        <div class="input-group input-group-merge">
            <span class="input-group-text" id="basic-addon-search31"><i class="bx bx-search"></i></span>
            <input class="form-control" id="html5-search-input" v-model="searchKeyword" @input="searchProducts" type="text" placeholder="Nhập mã sản phẩm hoặc tên sản phẩm, hoạt chất ..." />
        </div>
    </div>
    <div class="card-header d-flex align-items-center justify-content-between search-model">
        <div class="col-md-6 product_stock row">
            <label class="col-sm-3 col-form-label">
                <a href="/assets/excel/ImportDataProducts.xlsx" download>
                    <button type="button" class="btn btn-primary">
                        <span class="tf-icons bx bx-cloud-upload"></span> Tải File
                        mẫu
                    </button>
                </a>
            </label>
            <div class="col-sm-5 col-form-label import-data">
                <input ref="fileInput" @change="handleFileChange" class="form-control" type="file" id="formFile" />
                <button @click="importProducts" type="button" class="btn btn-primary">
                    Import
                </button>
            </div>
            <div class="col-sm-4 col-form-label" v-if="hasPermission('product.create')">
                <router-link :to="{ name: 'admin-products-create' }">
                    <button type="button" class="btn btn-primary float-end">
                        <i class="bx bx-plus"></i> Thêm sản phẩm
                    </button>
                </router-link>
            </div>
        </div>
    </div>
    <div class="card-body">
        <div class="table-responsive text-nowrap mb-4">
            <table class="table table-striped">
                <thead>
                    <tr class="text-nowrap alert-secondary">
                        <th>Mã sản phẩm</th>
                        <th>Tên sản phẩm</th>
                        <th>Hoạt chất</th>
                        <th>Nồng độ/hàm lượng</th>
                        <th>Giá bán</th>
                        <th>Nhà sản xuất</th>
                        <th>Trạng thái</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(product, index) in filteredProducts" :key="index">
                        <td>{{ product.prd_code }}</td>
                        <td class="formart-customer">
                            <ins>
                                <router-link :to="{
    name: 'admin-products-detail',
    params: { products: product.ID },
}" class="secondary">{{ product.prd_name }}</router-link>
                            </ins>
                        </td>
                        <td class="formart-customer">{{ product.prd_active }}</td>
                        <td class="formart-customer">{{ product.prd_content }}</td>
                        <td>
                            {{ product.prd_sell_price.toLocaleString() }}
                        </td>
                        <td class="formart-customer">
                            {{
                                        producer.find(
                                            (x) =>
                                                x.ID == product.prd_manufacture_id
                                        )?.prd_manuf_name
                                    }}
                        </td>
                        <td v-if="product.prd_status === 1">
                            <span class="badge rounded-pill bg-success">
                                Hoạt động
                            </span>
                        </td>
                        <td v-else>
                            <span class="badge rounded-pill bg-danger">
                                Tạm dừng
                            </span>
                        </td>
                        <td v-if="hasPermission('product.edit')">
                            <router-link :to="{
    name: 'admin-products-update',
    params: { id: product.ID },
}">
                                <a href="javascript:void(0);"><i class="bx bxs-edit me-1 text-dark"></i></a>
                            </router-link>
                            <a v-if="hasPermission('product.delete')" @click="confirmDeleteProducts(product)" href="javascript:void(0);">
                                <i class="bx bx-trash me-1 text-dark"></i>
                            </a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <nav aria-label="Page navigation mt-4">
            <ul class="pagination justify-content-end">
                <li class="page-item prev">
                    <a class="page-link" href="javascript:void(0);" @click="changePage('first')"><i class="tf-icon bx bx-chevrons-left"></i></a>
                </li>
                <li class="page-item prev">
                    <a class="page-link" href="javascript:void(0);" @click="changePage(currentPage - 1)"><i class="tf-icon bx bx-chevron-left"></i></a>
                </li>
                <li v-for="page in displayedPages" :key="page" class="page-item" :class="{ active: page === currentPage }">
                    <a class="page-link" href="javascript:void(0);" @click="changePage(page)">{{ page }}</a>
                </li>
                <li class="page-item next">
                    <a class="page-link" href="javascript:void(0);" @click="changePage(currentPage + 1)"><i class="tf-icon bx bx-chevron-right"></i></a>
                </li>
                <li class="page-item next">
                    <a class="page-link" href="javascript:void(0);">
                        <i class="tf-icon bx bx-chevrons-right" @click="changePage('last')"></i>
                    </a>
                </li>
            </ul>
        </nav>
    </div>
</div>
</template>

<script>
import axios from "axios";
import {
    defineComponent,
    ref,
    watch,
    computed,
    onMounted
} from "vue";
import {
    useToast
} from "vue-toast-notification";
import {
    inject
} from "vue";
import {
    fetchUserPermission
} from '@/utils/permission.js';
import { ModelListSelect } from 'vue-search-select';
export default defineComponent({
    components: {
        ModelListSelect,
    },
    setup() {
        const userPermission = ref([]);
        const toast = useToast();
        const globalState = inject("globalState");
        const baseUrl = globalState.baseUrl;
        const products = ref([]);
        const searchKeyword = ref("");
        const status = ref([]);
        const producer = ref([]);
        const category = ref([]);
        const currentPage = ref(1);
        const itemsPerPage = 10;
        let totalPages = ref(0);
        const selectedStatus = ref("");
        const selectedCategory = ref("");
        const selectedManufacturer = ref("");
        const fileInput = ref(null);
        const file = ref(null);
        const maxDisplayedPages = 4;
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
        const getProducts = () => {
            axios
                .get(`${baseUrl}/api/products`, {
                    params: {
                        page: currentPage.value,
                        per_page: itemsPerPage,
                        keyword: searchKeyword.value,
                        status: selectedStatus.value,
                        category: selectedCategory.value,
                        manufacturer: selectedManufacturer.value,
                    },
                })
                .then((response) => {
                    console.log(selectedManufacturer.value);
                    products.value = response.data.product.data;
                    totalPages.value = response.data.product.last_page;
                    category.value = response.data.category;
                    status.value = response.data.status.data;
                    producer.value = response.data.producer;
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        const deleteProduct = (productId) => {
            axios
                .delete(`${baseUrl}/api/products/${productId}`)
                .then(() => {
                    toast.success("Xoá khách hàng thành công");
                    products.value = products.value.filter(
                        (product) => product.ID !== productId
                    );
                })
                .catch((error) => {
                    console.log(error);
                    toast.error("Xóa khách hàng thất bại");
                });
        };
        onMounted(async () => {
            try {
                userPermission.value = await fetchUserPermission();
            } catch (error) {
                console.error('Error fetching user roles:', error);
            }
        });

        function hasPermission(args) {
            return Object.values(userPermission.value).includes(args);
        }
        const handleFileChange = () => {
            file.value = fileInput.value.files[0];
        };
        const importProducts = () => {
            if (!file.value) {
                toast.error("Please select a file.");
                return;
            }
            const formData = new FormData();
            formData.append("file", file.value);
            axios
                .post(`${baseUrl}/api/products`, formData, {
                    headers: {
                        "Content-Type": "multipart/form-data",
                    },
                })
                .then((response) => {
                    if (response.data.success) {
                        toast.success("Products imported successfully.");
                        getProducts();
                        fileInput.value.value = '';
                    } else {
                        fileInput.value.value = '';
                        toast.success("Đã thêm sản phẩm thành công.");
                    }
                })
                .catch((error) => {
                    console.error(error);
                    if (error.response && error.response.data && error.response.data.message) {
                        const errorMessage = error.response.data.message;
                        if (errorMessage) {
                            fileInput.value.value = '';
                            toast.error(errorMessage);
                        } else {
                            fileInput.value.value = '';
                            toast.error("An error occurred while importing products.");
                        }
                    } else {
                        toast.error("An error occurred while importing products.");
                    }
                });
        };
        const changePage = (page) => {
            if (page === 'first') {
                currentPage.value = 1;
            } else if (page === 'last') {
                currentPage.value = totalPages.value;
            } else if (page >= 1 && page <= totalPages.value) {
                currentPage.value = page;
            }
            getProducts();
        };
        watch(searchKeyword, () => {
            currentPage.value = 1;
            getProducts();
        });

        const visiblePages = computed(() => {
            const totalVisiblePages = 10;
            const halfVisiblePages = Math.floor(totalVisiblePages / 2);
            const startPage = Math.max(currentPage.value - halfVisiblePages, 1);
            const endPage = Math.min(startPage + totalVisiblePages - 1, totalPages.value);

            return Array.from({
                length: endPage - startPage + 1
            }, (_, i) => startPage + i);
        });
        const showEllipsisBefore = computed(() => {
            return visiblePages.value[0] > 1;
        });
        const searchProducts = () => {
            currentPage.value = 1;
            getProducts();
        };
        const confirmDeleteProducts = (product) => {
            if (window.confirm("Bạn có chắc chắn muốn xoá khách hàng này?")) {
                deleteProduct(product.ID);
            }
        };
        const filterProducts = () => {
            currentPage.value = 1;
            getProducts();
        };
        const filteredProducts = computed(() => {
            return products.value.filter((product) => {
                const matchesStatus = !selectedStatus.value || product.prd_status == selectedStatus.value;
                const matchesCategory = !selectedCategory.value ||
                    (product.category && product.category.ID == selectedCategory.value);
                const matchesManufacturer = !selectedManufacturer.value ||
                    product.prd_manufacture_id == selectedManufacturer.value;

                return matchesStatus && matchesCategory && matchesManufacturer;
            });
        });
        getProducts();
        return {
            products,
            status,
            category,
            searchKeyword,
            currentPage,
            totalPages,
            producer,
            changePage,
            searchProducts,
            confirmDeleteProducts,
            selectedStatus,
            selectedCategory,
            selectedManufacturer,
            filterProducts,
            filteredProducts,
            importProducts,
            fileInput,
            handleFileChange,
            hasPermission,
            userPermission,
            itemsPerPage,
            displayedPages
        };
    },
});
</script>
