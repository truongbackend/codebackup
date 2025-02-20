<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">
        <router-link :to="{ name: 'admin-debts' }">Công nợ</router-link><i class="bx bx-chevron-right" style="font-size: 40px;"></i>Đơn hàng <i class="bx bx-chevron-right" style="font-size: 40px;"></i>
    </span> {{ debts.output_code }}</h4>
<div class="row">
    <div class="col-12 col-lg-9">
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between">
                <h6 class="card-title m-0">Người đặt hàng</h6>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã hàng</th>
                                <th>Tên sản phẩm</th>
                                <th>Số lượng</th>
                                <th>ĐVT</th>
                                <th>Giá bán </th>
                                <th>Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody v-if="debtsDetail.length > 0">
                            <tr v-for="(item, index) in debtsDetail" :key="index">
                                <td>{{ index+1 }}</td>
                                <td>{{ item.product_code }}</td>
                                <td>{{ item.product_name }}</td>
                                <td>{{item.quantity}}</td>
                                <td>{{ (product_unt.find(x => x.ID === item.bid_id)?.prd_unit_name) }}</td>
                                <td>{{formatNumber(item.price) }}</td>
                                <td>{{ formatNumber(item.quantity * item.price) }}</td>
                            </tr>
                        </tbody>
                        <tbody v-else>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card-body">
                <div class="alert alert-warning text-end" role="alert">Số lượng: {{totalQuantity}} , Thuế:{{ formatNumber(orderPx.find(cust => cust.ID === debts.order_id)?.vat) }} , Tổng tiền: {{ formatNumber(totalAmount) }}</div>
            </div>
        </div>
    </div>
    <div class="col-12 col-lg-3">
        <div class="card mb-4">
            <h5 class="card-header">Chi tiết khách hàng</h5>
            <div class="card-body">
                <table class="table table-borderless">
                    <tbody>
                        <tr>
                            <td class="align-middle"><strong class="fw-semibold">Mã đơn hàng</strong></td>
                            <td class="py-3">
                                <p class="mb-0">{{debts.output_code }}</p>
                            </td>
                        </tr>
                        <tr>
                            <td class="align-middle"><strong class="fw-semibold">Trạng thái</strong></td>
                            <td class="py-3">
                                <p class="mb-0 text-danger"> Quá hạn {{ calculateRemainingDays(debts.expdate) }} ngày</p>
                            </td>
                        </tr>
                        <tr>
                            <td class="align-middle"><strong class="fw-semibold">Khách hàng</strong></td>
                            <td class="py-3">
                                <p class="mb-0">{{ customer.find(cust => cust.id === orderPx.customer_id)?.customer_name }}</p>
                            </td>
                        </tr>
                        <tr>
                            <td class="align-middle"><strong class="fw-semibold">Ngày bán</strong></td>
                            <td class="py-3">
                                <p class="mb-0">{{debts.created }}</p>
                            </td>
                        </tr>
                        <tr>
                            <td class="align-middle"><strong class="fw-semibold">Hình thức</strong></td>
                            <td class="py-3">
                                <p class="mb-0" v-if=" orderPx.find(cust => cust.ID === debts.order_id)?.payment_method === 3">Chuyển khoản</p>
                                <p class="mb-0" v-if="orderPx.find(cust => cust.ID === debts.order_id)?.payment_method === 0">Trả tiền mặt</p>
                            </td>
                        </tr>
                        <tr>
                            <td class="align-middle"><strong class="fw-semibold">Tiền hàng</strong></td>
                            <td class="py-3">
                                <p class="mb-0">{{ formatNumber(orderPx.find(cust => cust.ID === debts.order_id)?.total_price) }}</p>
                            </td>
                        </tr>
                        <tr>
                            <td class="align-middle"><strong class="fw-semibold">Tiền thuế</strong></td>
                            <td class="py-3">
                                <p class="mb-0">{{ formatNumber(orderPx.find(cust => cust.ID === debts.order_id)?.vat) }}</p>
                            </td>
                        </tr>
                        <tr>
                            <td class="align-middle"><strong class="fw-semibold">Tổng cộng</strong></td>
                            <td class="py-3">
                                <p class="mb-0">{{ formatNumber(orderPx.find(cust => cust.ID === debts.order_id)?.total_money) }}</p>
                            </td>
                        </tr>
                        <tr>
                            <td class="align-middle"><strong class="fw-semibold">Khách trả</strong></td>
                            <td class="py-3">
                                <p class="mb-0">{{formatNumber(debts.paid) }}</p>
                            </td>
                        </tr>
                        <tr>
                            <td class="align-middle"><strong class="fw-semibold">Còn nợ</strong></td>
                            <td class="py-3">
                                <p class="mb-0 text-danger">{{formatNumber((orderPx.find(cust => cust.ID === debts.order_id)?.total_money)-(debts.paid)) }}</p>
                            </td>
                        </tr>
                        <tr>
                            <td class="align-middle"><strong class="fw-semibold">Kế toán trưởng</strong></td>
                            <td class="py-3">
                                <p class="mb-0">{{ customer.find(cust => cust.ID === debts.customer_id)?.ttpketoan }}</p>
                            </td>
                        </tr>
                    </tbody>
                </table>
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
    useSSRContext,
    watch,
    computed
} from 'vue';
import {
    inject
} from 'vue';
import {
    useRouter,
    useRoute
} from "vue-router";
export default defineComponent({
    setup() {
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const customer = ref([]);
        const route = useRoute();
        const debts = ref([]);
        const orderPx = ref([]);
        const product_detail = ref([]);
        const product = ref([]);
        const debtsDetail = ref([]);
        const product_unt = ref([]);
        const filteredDebts = computed(() => {
            if (!selectedCustomer.value) {
                return debts.value;
            } else {
                return debts.value.filter(debt => debt.customer_id === selectedCustomer.value);
            }
        });
        const getDebts = () => {
            axios
                .get(`${baseUrl}/api/debts/${route.params.debts}`)
                .then((response) => {
                    debts.value = response.data.debts;
                    customer.value = response.data.customer;
                    orderPx.value = response.data.orderPx;
                    product_detail.value = response.data.product_detail;
                    product.value = response.data.product;
                    debtsDetail.value = response.data.debtsDetail;
                    console.log(debtsDetail.value);
                    product_unt.value = response.data.product_unt;
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        const formatNumber = (value) => {
            if (value !== undefined && value !== null) {
                return new Intl.NumberFormat('vi-VN').format(value);
            } else {
                return '';
            }
        };
        const calculateRemainingDays = (expdate) => {
            const currentDate = new Date();
            const debtExpirationDate = new Date(expdate);
            const timeDifference = debtExpirationDate.getTime() - currentDate.getTime();
            const remainingDays = Math.ceil(timeDifference / (1000 * 60 * 60 * 24));
            return Math.abs(remainingDays);
        };
        const totalAmount = computed(() => {
            return debtsDetail.value.reduce((total, line) => total + line.quantity * line.price, 0);
        });
        const totalQuantity = computed(() => {
            return debtsDetail.value.reduce((total, line) => total + line.quantity, 0);
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
        getDebts();
        return {
            debts,
            customer,
            orderPx,
            calculateRemainingDays,
            visiblePages,
            product_detail,
            product,
            debtsDetail,
            product_unt,
            totalAmount,
            totalQuantity,
            formatNumber
        };
    },
});
</script>
