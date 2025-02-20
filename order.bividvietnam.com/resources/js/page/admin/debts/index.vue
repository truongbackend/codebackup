<template>
<h4 class="fw-bold"><span class="text-muted fw-light">Công nợ<i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách công nợ</h4>
<div class="card">
    <div class="card-header">
        <div class="row">
            <div class="col-md-10">
                <div class="input-group input-group-merge">
                    <span class="input-group-text" id="basic-addon-search31"><i class="bx bx-search"></i></span>
                    <input type="text" class="form-control" v-model="searchKeyword" @input="searchProducts" placeholder="Nhập thông tin tìm kiếm ..." aria-label="Search..." aria-describedby="basic-addon-search31">
                </div>
            </div>
            <div class="col-md-2">
                <select id="ProductStock" class="form-select text-capitalize" v-model="selectedStatus" @change="filterByStatusOrder">
                    <option value="">Chọn trạng thái</option>
                    <option value="1">Chưa thanh toán</option>
                    <option value="0">Đã thanh toán</option>
                </select>
            </div>
        </div>
    </div>
    <div class="card-body">
        <div class="table-responsive text-nowrap mb-4">
            <table class="table table-striped">
                <thead>
                    <tr class="text-nowrap alert-secondary">
                        <th>#</th>
                        <th>Mã đơn hàng</th>
                        <th>Tên khách hàng</th>
                        <th>Hạn thanh toán</th>
                        <th>Chưa thanh toán</th>
                        <th>Đã thanh toán</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(debt, index) in debts" :key="index">
                        <td class="text-danger">{{ index + 1 }}</td>
                        <td class="text-danger">
                            <router-link class="text-danger" :to="{ name: 'admin-debts-detail', params: { debts: debt.ID } }">{{ debt.output_code }}</router-link>
                        </td>
                        <td class="text-danger">
                            <router-link class="text-danger" :to="{ name: 'admin-debts-detail', params: { debts: debt.ID } }">{{ customer.find(cust => cust.ID === debt.customer_id)?.customer_name }}</router-link>
                        </td>
                        <td class="text-danger">{{ debt.expdate }}</td>
                        <td class="text-danger"> Quá hạn {{ calculateRemainingDays(debt.expdate) }} ngày</td>
                        <td class="text-danger">{{ debt.paid.toLocaleString() }}</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <nav aria-label="Page navigation mt-4">
            <ul class="pagination justify-content-end">
                <li class="page-item first">
                    <a class="page-link" href="javascript:void(0); " @click="changePage('first')">
                        <i class="tf-icon bx bx-chevrons-left"></i>
                    </a>
                </li>
                <li class="page-item prev">
                    <a class="page-link" href="javascript:void(0);" @click="changePage(currentPage - 1)">
                        <i class="tf-icon bx bx-chevron-left"></i>
                    </a>
                </li>

                <li v-for="page in visiblePages" :key="page" class="page-item" :class="{ active: page === currentPage }">
                    <a class="page-link" href="javascript:void(0);" @click="changePage(page)">{{ page }}</a>
                </li>
                <li v-if="showEllipsisBefore" class="page-item">
                    <a class="page-link" href="javascript:void(0);">...</a>
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
        const inputCustomer = ref('');
        const toast = useToast();
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const customer = ref([]);
        const debts = ref([]);
        const searchKeyword = ref('');
        const currentPage = ref(1);
        const itemsPerPage = 50;
        const selectedStatus = ref('');
        const totalPages = ref(0);
        const selectedCustomer = ref('');
        const searchCustomer = ref('');
        const filteredDebts = computed(() => {
            if (!selectedCustomer.value) {
                return debts.value;
            } else {
                return debts.value.filter(debt => debt.customer_id === selectedCustomer.value);
            }
        });
        const filterByStatusOrder = () => {
            currentPage.value = 1;
            getDebts();
        }
        const filterByCustomer = () => {
            currentPage.value = 1;
            getDebts();
        };
        watch([currentPage, selectedCustomer], () => {
            getDebts();
        });
        const getDebts = () => {
            axios
                .get(`${baseUrl}/api/debts`, {
                    params: {
                        page: currentPage.value,
                        per_page: itemsPerPage,
                        keyword: searchKeyword.value,
                        customer_id: selectedCustomer.value,
                        selected_status: selectedStatus.value
                    },
                })
                .then((response) => {
                    debts.value = response.data.debts.data;
                    customer.value = response.data.customer;
                    totalPages.value = response.data.debts.last_page;
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        const calculateRemainingDays = (expdate) => {
            const currentDate = new Date();
            const debtExpirationDate = new Date(expdate);
            const timeDifference = debtExpirationDate.getTime() - currentDate.getTime();
            const remainingDays = Math.ceil(timeDifference / (1000 * 60 * 60 * 24));
            return Math.abs(remainingDays);
        };
        const filterCustomers = () => {
            const searchTerm = inputCustomer.value.toLowerCase();
            if (!searchTerm) return filteredCustomers.value;

            return filteredCustomers.value.filter(customerItem =>
                customerItem.customer_name.toLowerCase().includes(searchTerm)
            );
        };
        const filteredCustomers = computed(() => {
            const searchTerm = searchCustomer.value.toLowerCase();
            if (!searchTerm) return customer.value;

            return customer.value.filter(customerItem =>
                customerItem.customer_name.toLowerCase().includes(searchTerm)
            );
        });
        const visiblePages = computed(() => {
            const totalVisiblePages = 4;
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
        const updateSearchCustomer = () => {
            currentPage.value = 1;
            getDebts();
        };
        watch(currentPage, () => {
            getDebts();
        });
        const changePage = (page) => {
            if (page === 'first') {
                currentPage.value = 1;
            } else if (page === 'last') {
                currentPage.value = totalPages.value;
            } else if (page >= 1 && page <= totalPages.value) {
                currentPage.value = page;
            }
        };
        const searchProducts = () => {
            currentPage.value = 1;
            getDebts();
        };
        getDebts();
        return {
            customer,
            debts,
            searchKeyword,
            currentPage,
            totalPages,
            changePage,
            searchProducts,
            calculateRemainingDays,
            visiblePages,
            showEllipsisBefore,
            selectedCustomer,
            filteredDebts,
            filterByCustomer,
            selectedStatus,
            filterByStatusOrder,
            searchCustomer,
            filteredCustomers,
            updateSearchCustomer,
            inputCustomer,
            filterCustomers,
        };
    },
});
</script>
