<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Khách hàng <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Chi tiết khách hàng</h4>
<div class="row">
    <div class="col-12 col-lg-9">
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between">
                <h6 class="card-title m-0">Đơn hàng</h6>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Mã đơn hàng</th>
                                <th>Ngày đặt hàng</th>
                                <th>Trạng thái</th>
                                <th>Tổng tiền</th>
                                <th>Hóa đơn</th>
                            </tr>
                        </thead>
                        <tbody v-if="order_px.length > 0">
                            <tr v-for="order_px in order_px" :key="order_px.id">
                                <td class="text-primary">{{ order_px.output_code }}</td>
                                <td>{{ order_px.created }}</td>
                                <td :class="{ 'alert-success': order_px.order_status === 1, 'alert-danger': order_px.order_status === 2 }">{{ order_px.order_status === 1 ? 'Hoàn thành' : 'Khởi tạo' }}</td>
                                <td>{{ order_px.total_money.toLocaleString() }}</td>
                                <td v-if="order_px.mtc"><a :href="`https://van.ehoadon.vn/TCHD?MTC=${order_px.mtc}`"><i class='bx bx-link-external'></i></a></td>
                                <td v-else></td>
                            </tr>
                        </tbody>
                        <tbody v-else>
                            <tr>
                                <td colspan="5">Không có dữ liệu</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between">
                <h6 class="card-title m-0">Tình hình công nợ</h6>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Mã đơn hàng</th>
                                <th>Hạn thanh toán</th>
                                <th>Trạng thái</th>
                                <th>Chưa thanh toán</th>
                            </tr>
                        </thead>
                        <tbody v-if="order_debts.length > 0">
                            <tr v-for="order_debts in order_debts">
                                <td class="text-danger">{{ order_debts.output_code }}</td>
                                <td class="text-danger">{{ order_debts.expdate }}</td>
                                <td class="text-danger"> Quá hạn {{ calculateRemainingDays(order_debts.expdate) }} ngày </td>
                                <td class="text-danger">{{ order_debts.unpaid.toLocaleString() }}</td>
                            </tr>
                        </tbody>
                        <tbody v-else>
                            <tr>
                                <td colspan="5">Không có dữ liệu</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between">
                <h6 class="card-title m-0">Hợp đồng thầu</h6>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Mã số thầu</th>
                                <th>Ngày bắt đầu</th>
                                <th>Ngày hết hạn</th>
                                <th>Số lượng</th>
                                <th>Tổng tiền</th>
                            </tr>
                        </thead>
                        <tbody v-if="customerBids.length > 0">
                            <tr v-for="customerBids in customerBids">
                                <td class="text-primary"> {{ customerBids.output_code }}</td>
                                <td>{{customerBids.begin_date }}</td>
                                <td>{{customerBids.expiration_date }}</td>
                                <td>{{ customerBids.total_quantity }}</td>
                                <td>{{ customerBids.total_price.toLocaleString() }}</td>
                            </tr>
                        </tbody>
                        <tbody v-else>
                            <tr>
                                <td colspan="5">Không có dữ liệu</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="col-12 col-lg-3">
        <div class="card mb-4">
            <h5 class="card-header">Chi tiết khách hàng</h5>
            <div class="card-body">
                <tr class="row mt-2">
                    <td class="align-middle col-5"><strong class="fw-semibold">Tên khách hàng</strong></td>
                    <td class="col-7">
                        <p class="mb-0">{{ customer.customer_name }}</p>
                    </td>
                </tr>
                <tr class="row mt-2">
                    <td class="align-middle col-5"><strong class="fw-semibold">Mã khách hàng</strong></td>
                    <td class="col-7">
                        <p class="mb-0">{{ customer.customer_code }}</p>
                    </td>
                </tr>
                <tr class="row mt-2">
                    <td class="align-middle col-5"><strong class="fw-semibold">Điện thoại</strong></td>
                    <td class="col-7">
                        <p class="mb-0 ">{{ customer.customer_phone }}</p>
                    </td>
                </tr>
                <tr class="row mt-2">
                    <td class="align-middle col-5"><strong class="fw-semibold">Email</strong></td>
                    <td class="col-7">
                        <p class="mb-0">{{ customer.customer_email ? customer.customer_email : 'Chưa có' }}</p>
                    </td>
                </tr>
                <tr class="row mt-2">
                    <td class="align-middle col-5"><strong class="fw-semibold">Địa chỉ</strong></td>
                    <td class="col-7">
                        <p class="mb-0">{{ customer.customer_addr }}</p>
                    </td>
                </tr>
                <tr class="row mt-2">
                    <td class="align-middle col-5"><strong class="fw-semibold">Địa chỉ giao hàng</strong></td>
                    <td class="col-7">
                        <p class="mb-0">{{ customer.customer_ship_addr }}</p>
                    </td>
                </tr>
                <tr class="row mt-2">
                    <td class="align-middle col-5"><strong class="fw-semibold">Danh mục</strong></td>
                    <td class="col-7">
                        <p class="mb-0">{{ stores.find(x=>x.ID==customer.store_id)?.store_name  }}</p>
                    </td>
                </tr>
                <tr class="row mt-2">
                    <td class="align-middle col-5"><strong class="fw-semibold">Ghi chú</strong></td>
                    <td class="col-7">
                        <p class="mb-0">{{ customer.notes ? customer.notes : 'Chưa có'  }}</p>
                    </td>
                </tr>
                <div class="row">
                    <div class="col-sm-12 text-end">
                        <router-link :to="{ name: 'admin-customer' }" class="btn btn-danger me-sm-2">Trở về</router-link>
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
        const stores = ref([]);
        const customerBids = ref([]);
        const order = ref([]);
        const order_px = ref([]);
        const order_debts = ref([]);
        const users = ref([]);
        const getCustomer = () => {
            axios
                .get(`${baseUrl}/api/customers/${route.params.customer}`)
                .then((response) => {
                    const data = response.data.customer;
                    customer.value = data;
                    stores.value = response.data.stores;
                    customerBids.value = response.data.customerBids;
                    order.value = response.data.order;
                    console.log(order.value);
                    order_px.value = response.data.order_Px;
                    users.value = response.data.users;
                    console.log(users.value);
                    order_debts.value = response.data.order_Debts;

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
        getCustomer();
        return {
            customer,
            stores,
            customerBids,
            order,
            order_px,
            order_debts,
            calculateRemainingDays,
            users,
        };
    },
});
</script>
