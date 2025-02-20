<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Thống kê người quản lý <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách</h4>
<div class="card">
    <div class="card-body">
        <div class="row">
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Quản lý</label>
                <model-list-select :list="users" v-model="selectedUser" option-value="id" option-text="display_name" placeholder="Chọn quản lý" filterable></model-list-select>
            </div>
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Khách hàng</label>
                <model-list-select :list="customer" v-model="selectedCustomer" option-value="ID" option-text="customer_name" placeholder="Chọn khách hàng"></model-list-select>
            </div>
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Trạng thái</label>
                <select class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                    <option selected>Trạng thái</option>
                    <option v-for="status in status" :value="status.id">{{ status.name }}</option>
                </select>
            </div>
            <div class="col-md-3">
                <label for="exampleFormControlSelect1" class="form-label">Chi nhánh</label>
                <model-list-select :list="stores" v-model="selectedStore" option-value="ID" option-text="store_name" placeholder="Chọn chi nhánh"></model-list-select>
            </div>
        </div>
    </div>
    <div class="card-body">
        <div class="table-responsive text-nowrap">
            <table class="table mb-4 table-striped">
                <thead>
                    <tr class="text-nowrap alert-secondary">
                        <th>#</th>
                        <th>Mã đơn hàng</th>
                        <th>Người đặt</th>
                        <th>Mã khách hàng</th>
                        <th>Khách hàng</th>
                        <th>Tổng tiền</th>
                        <th>Ngày tạo</th>
                        <th>IP</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(orderPx, index) in orderPx" :key="index">
                        <td>{{ index + 1 }}</td>
                        <td>{{ orderPx.output_code }}</td>
                        <td>{{ users.find(x=>x.id==orderPx.user_init)?.display_name }}</td>
                        <td>{{ customer.find(x=>x.ID==orderPx.customer_id)?.customer_code }}</td>
                        <td>{{ customer.find(x=>x.ID==orderPx.customer_id)?.customer_name }}</td>
                        <td v-if="orderPx.total_price">{{formatNumber(orderPx.total_price)}}</td>
                        <td v-else>0</td>
                        <td>{{ orderPx.created }}</td>
                        <td>{{ users.find(x=>x.id==orderPx.user_init)?.ip_logged }}</td>
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
import axios from 'axios';
import {
    defineComponent,
    ref,
    watch,
    computed
} from 'vue';
import {
    useToast
} from 'vue-toast-notification';
import {
    inject
} from 'vue';
import { ModelListSelect } from 'vue-search-select';
export default defineComponent({
    components: {
        ModelListSelect,
    },
    setup() {
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const users = ref([]);
        const orderPx = ref([]);
        const stores = ref([]);
        const status = ref([]);
        const customer = ref([]);
        const users_group = ref([]);
        const selectedStore = ref('');
        const currentPage = ref(1);
        const itemsPerPage = 50;
        const totalPages = ref(0);
        const selectedCustomer = ref('');
        const searchKeyword = ref('');
        const toast = useToast();
        const selectedUser = ref('');
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
        const filterByCustomer = () => {
            currentPage.value = 1;
            getSummary();
        };
        watch([currentPage, selectedCustomer, selectedStore, selectedUser], () => {
            getSummary();
        });

        const getSummary = () => {
            axios
                .get(`${baseUrl}/api/summary`, {
                    params: {

                        page: currentPage.value,
                        per_page: itemsPerPage,
                        keyword: searchKeyword.value,
                        customer_id: selectedCustomer.value,
                        store_id: selectedStore.value,
                        user_init: selectedUser.value,
                    },
                })
                .then((response) => {
                    orderPx.value = response.data.orderPx.data;
                    status.value = response.data.status;
                    stores.value = response.data.stores;
                    customer.value = response.data.customer;
                    users.value = response.data.users;
                    users_group.value = response.data.users_group;
                    totalPages.value = response.data.orderPx.last_page;
                })
                .catch((error) => {
                    console.log(error);
                });
        };
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
        const formatNumber = (value) => {
            if (value !== undefined && value !== null) {
                return new Intl.NumberFormat('vi-VN').format(value);
            } else {
                return '';
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
            getUsers();
        };
        getSummary();
        return {
            orderPx,
            users,
            stores,
            status,
            customer,
            users_group,
            selectedCustomer,
            filterByCustomer,
            changePage,
            showEllipsisBefore,
            selectedStore,
            selectedUser,
            displayedPages,
            itemsPerPage,
            currentPage,
            totalPages,
            formatNumber
        };
    },
});
</script>
