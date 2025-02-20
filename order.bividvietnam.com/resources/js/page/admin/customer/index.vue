<template>
<div class="row">
    <div class="col-md-6">
        <h4 class="fw-bold"><span class="text-muted fw-light">Khách hàng <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách khách hàng</h4>
    </div>
    <div class="col-md-6">
        <router-link :to="{ name: 'admin-customer-create' }" v-if="hasPermission('customer.create')">
            <button type="button" class="btn btn-primary float-end"> <i class='bx bx-plus'></i>Thêm khách hàng</button>
        </router-link>
    </div>
</div>
<div class="card">
    <div class="card-header">
        <div class="input-group input-group-merge">
            <span class="input-group-text" id="basic-addon-search31"><i class="bx bx-search"></i></span>
            <input class="form-control" id="html5-search-input" v-model="searchKeyword" type="text" placeholder="Nhập thông tin tìm kiếm...">
        </div>
        <div class="row mt-3">
                <div class="col-md-3">
                    <button type="button" class="btn btn-outline-danger" @click="searchProducts">
                        <i class='bx bx-search-alt'></i> Xem kết quả
                    </button>
                </div>
            </div>
    </div>
    <div class="card-body">
        <div class="table-responsive text-nowrap">
            <table class="table table-striped mb-6">
                <thead>
                    <tr class="text-nowrap alert-secondary">
                        <th>#</th>
                        <th>Mã KH</th>
                        <th>Tên KH</th>
                        <th>Điện thoại</th>
                        <th>Khu vực</th>
                        <th>Địa chỉ</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(customer, index) in customers" :key="customer.ID">
                        <td>{{ index + 1 }}</td>
                        <td>
                            <router-link :to="{ name: 'admin-customer-detail', params: { customer: customer.ID }, }">{{ customer.customer_code }}</router-link>
                        </td>
                        <td>
                            <router-link :to="{ name: 'admin-customer-detail', params: { customer: customer.ID }, }" class="content-table">{{ customer.customer_name }}</router-link>
                        </td>
                        <td>{{ customer.customer_phone }}</td>
                        <td>{{ stores.find((x) =>x.ID == customer.store_id)?.store_name
                                    }}</td>
                        <td class="formart-customer">{{ customer.customer_addr }}</td>
                        <td>
                            <router-link :to="{ name: 'admin-customer-update', params: { id: customer.ID } }" v-if="hasPermission('customer.edit')">
                                <i class="bx bxs-edit me-1 text-dark"></i>
                            </router-link>
                            <a @click="confirmDelete(customer.ID)" href="javascript:void(0);" v-if="hasPermission('customer.delete')" data-bs-toggle="modal" data-bs-target="#basicModal">
                                <i class="bx bx-trash me-1 text-dark"></i>
                            </a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <nav aria-label="Page navigation mt-6">
                <ul class="pagination justify-content-end">
                    <li class="page-item prev">
                        <a class="page-link" href="javascript:void(0); " @click="changePage('first')">
                            <i class="tf-icon bx bx-chevrons-left"></i>
                        </a>
                    </li>
                    <li class="page-item prev">
                        <a class="page-link" href="javascript:void(0);" @click="changePage(currentPage - 1)">
                            <i class="tf-icon bx bx-chevron-left"></i>
                        </a>
                    </li>
                    <li v-for="page in displayedPages" :key="page" class="page-item" :class="{ active: page === currentPage }">
                        <a class="page-link" href="javascript:void(0);" @click="changePage(page)">{{ page }}</a>
                    </li>
                    <li class="page-item next">
                        <a class="page-link" href="javascript:void(0);" @click="changePage(currentPage + 1)">
                            <i class="tf-icon bx bx-chevron-right"></i>
                        </a>
                    </li>
                    <li class="page-item next">
                        <a class="page-link" href="javascript:void(0);" @click="changePage('last')">
                            <i class="tf-icon bx bx-chevrons-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
    </div>
</div>
<div class="col-lg-4 col-md-6">
    <div class="mt-3">
        <div class="modal fade" id="basicModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel1">Thông báo</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body toast-modal">
                        <div class="col mb-3">
                            <p>Bạn có chắc muốn xóa khách hàng này không ?</p>
                        </div>
                    </div>
                    <div class="modal-footer toast-modal">
                        <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">
                            Đóng
                        </button>
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal" @click="deleteConfirmed">Đồng ý</button>
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
    onMounted,
    computed
} from 'vue';
import {
    useRouter
} from 'vue-router';
import {
    useToast
} from 'vue-toast-notification';
import {
    inject
} from 'vue';
import {
    fetchUserPermission
} from '@/utils/permission.js';
export default defineComponent({
    setup() {
        const deletingCustomerId = ref(null);
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const customers = ref([]);
        const router = useRouter();
        const toast = useToast();
        const currentPage = ref(1);
        const itemsPerPage = 10;
        const totalPages = ref(0);
        const userPermission = ref([]);
        const searchKeyword = ref('');
        const searchTimer = ref(null);
        const stores = ref([]);
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
        const getCustomers = () => {
            axios
                .get(`${baseUrl}/api/customers`, {
                    params: {
                        page: currentPage.value,
                        per_page: itemsPerPage,
                        keyword: searchKeyword.value,
                    },
                })
                .then((response) => {
                    customers.value = response.data.customers.data;
                    stores.value = response.data.stores;
                    totalPages.value = response.data.customers.last_page;
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        const confirmDelete = (customerId) => {
            deletingCustomerId.value = customerId;
        };

        const performSearch = () => {
            clearTimeout(searchTimer.value);
            searchTimer.value = setTimeout(() => {
                currentPage.value = 1;
            }, 300);
        };
        const deleteConfirmed = () => {
            if (deletingCustomerId.value) {
                deleteCustomer(deletingCustomerId.value);
                deletingCustomerId.value = null;
            }
        };

        const changePage = (page) => {
            if (page === 'first') {
                currentPage.value = 1;
            } else if (page === 'last') {
                currentPage.value = totalPages.value;
            } else if (page >= 1 && page <= totalPages.value) {
                currentPage.value = page;
            }
            getCustomers();
        };

        const deleteCustomer = (customerId) => {
            axios
                .delete(`${baseUrl}/api/customers/${customerId}`)
                .then(() => {
                    toast.success('Xoá khách hàng thành công');
                    customers.value = customers.value.filter(
                        (customer) => customer.ID !== customerId
                    );
                    deletingCustomerId.value = null;
                })
                .catch((error) => {
                    console.log(error);
                    toast.error('Failed to delete user');
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
        watch(searchKeyword, performSearch);
        getCustomers();
        return {
            customers,
            searchKeyword,
            currentPage,
            totalPages,
            changePage,
            hasPermission,
            userPermission,
            stores,
            itemsPerPage,
            displayedPages,
            currentPage,
            totalPages,
            confirmDelete,
            deleteConfirmed,
            searchProducts:getCustomers,
        };
    },
});
</script>
