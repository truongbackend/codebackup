<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light"><router-link :to="{ name: 'admin-order' }">Đơn hàng </router-link><i class="bx bx-chevron-right" style="font-size: 40px;"></i> Chi tiết đơn hàng <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách</h4>
<div class="row">
    <div class="col-12 col-lg-9">
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title m-6">Chi tiết sản phẩm</h5>
                <div class="table-responsive text-nowrap">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã hàng</th>
                                <th>Tên sản phẩm</th>
                                <th>Số lượng</th>
                                <th>Giá bán</th>
                                <th>Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody v-if="order_detail.length >0 ">
                            <tr v-for="(line, index) in order_detail" :key="index">
                                <td>{{ index + 1 }}</td>
                                <td>{{ line.product_code }}</td>
                                <td>{{ line.product_name }}</td>
                                <td>{{ line.quantity }}</td>
                                <td>{{ line.price.toLocaleString() }}</td>
                                <td>{{ (line.quantity * line.price).toLocaleString() }}</td>
                            </tr>
                        </tbody>
                        <tbody v-else>
                            <tr>
                                <td colspan="6">Không có dữ liệu</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="alert alert-warning text-end mt-2" role="alert">
                    Số lượng: {{ totalQuantity }}, Tổng tiền: {{ totalAmount.toLocaleString() }}
                </div>
            </div>

        </div>
    </div>
    <div class="col-12 col-lg-3">
        <div class="card mb-4">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <h5 class="card-title m-6 mt-2 mb-4">Thông Tin đơn hàng</h5>
                </div>
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Mã đơn hàng</h6>
                    <p class="m-6">{{ order.output_code }}</p>
                </div>
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Trạng thái</h6>
                    <p class="m-6" v-if="order.order_status == 11">Thành công</p>
                    <p class="m-6" v-if="order.order_status == 10">Đã giao</p>
                    <p class="m-6" v-if="order.order_status == 9">Đang giao</p>
                    <p class="m-6" v-if="order.order_status == 5">Khởi tạo</p>
                    <p class="m-6" v-if="order.order_status == 12">Hủy</p>
                </div>
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Khách hàng</h6>
                    <p class="m-6">{{ customer.find(x => x.ID == order.customer_id)?.customer_name }}</p>
                </div>
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Ngày bán</h6>
                    <p class="m-6">{{ order.created }}</p>
                </div>
                <div class="d-flex justify-content-between">
                    <div class="col-12 text-end">
                        <div class="btn-group">
                            <button type="button" class="btn btn-primary dropdown-toggle" data-bs-toggle="dropdown" data-bs-display="static" aria-haspopup="true" aria-expanded="false">
                                Trạng thái
                            </button>
                            <ul class="dropdown-menu">
                                <li v-for="item in status" :key="item.id">
                                    <button @click="() => putStatus(item.id)" class="dropdown-item" type="button">{{ item.name }}</button>
                                </li>
                            </ul>
                        </div>
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
    computed,
    onMounted
} from 'vue';
import {
    inject
} from 'vue';
import {
    useRoute
} from 'vue-router';
export default defineComponent({
    setup() {
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const route = useRoute();
        const customer = ref([]);
        const order_detail = ref([]);
        const order = ref([]);
        const status = ref([]);
        const toast = ref([]);
        const selectedStatus = ref(null);
        const token = localStorage.getItem('token');
        const getOrder = () => {
            axios
                .get(`${baseUrl}/api/order/${route.params.order}`, {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                })
                .then((response) => {
                    const data = response.data.order;
                    order.value = data;
                    customer.value = response.data.customer;
                    order_detail.value = response.data.order_detail;
                    status.value = response.data.status;
                })
                .catch((error) => {
                    console.log(error);
                });
        };

        const putStatus = (statusId) => {
            axios
                .put(
                    `${baseUrl}/api/order/${route.params.order}`, {
                        status: statusId,
                    }, {
                        headers: {
                            Authorization: `Bearer ${token}`,
                        },
                    }
                )
                .then(() => { 
                    window.location.reload();
                    toast.success('Cập nhật trạng thái thành công');
                })
                .catch((error) => {
                    console.error(error);
                });
        };

        const totalQuantity = computed(() => {
            return order_detail.value.reduce((total, line) => total + line.quantity, 0);
        });

        const totalAmount = computed(() => {
            return order_detail.value.reduce((total, line) => total + line.quantity * line.price, 0);
        });

        onMounted(() => {
            getOrder();
        });

        return {
            order,
            customer,
            order_detail,
            totalQuantity,
            totalAmount,
            status,
            selectedStatus,
            putStatus,
        };
    },
});
</script>
