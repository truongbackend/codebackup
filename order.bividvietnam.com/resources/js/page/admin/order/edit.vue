<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">
        <router-link :to="{ name: 'admin-order' }">Đơn hàng </router-link><i class="bx bx-chevron-right" style="font-size: 40px;"></i>
    </span> {{ order.output_code}}</h4>
<div class="row ">
    <div class="col-12 col-lg-9">
        <div class="card mb-4">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h5 class="mb-0">Sản phẩm</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive text-nowrap">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Mã hàng</th>
                                <th>Tên sản phẩm</th>
                                <th>Số lượng</th>
                                <th>Giá bán</th>
                                <th>Thành tiền</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(line, index) in order_detail" :key="index">
                                <td>{{ index + 1 }}</td>
                                <td>{{ line.product_code }}</td>
                                <td>{{ line.product_name }}</td>
                                <td><input class="form-control" type="number" v-model="line.quantity" min="0" pattern="\d*" @input="validateQuantity(line, index)" />
                                    <div v-if="errors.quantity && errors.quantity[index]" class="text-danger">
                                        {{ errors.quantity[index] }}
                                    </div>
                                </td>
                                <td><input class="form-control" type="number" v-model="line.price" min="0" pattern="\d*" /></td>
                                <td>{{ formatNumber(line.quantity * line.price) }}</td>
                                <td><a @click="confirmDeleteProducts(line.ID, index)" href="javascript:void(0);"><i class="bx bx-trash me-1 text-dark">
                                        </i></a></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="alert alert-warning text-end mt-4" role="alert">
                    Số lượng: {{ formatNumber(totalQuantity) }}, Tổng tiền: {{ formatNumber(totalAmount) }}
                </div>
            </div>
        </div>
    </div>
    <div class="col-12 col-lg-3">
        <div class="card mb-4">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h5 class="mb-0">Thông tin đơn hàng</h5>
            </div>
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Khách hàng</h6>
                    <p class="m-6">{{ customer.find(x=>x.ID==order.customer_id)?.customer_name }}</p>
                </div>
                <div class="row mb-3">
                    <label class="col-sm-5 col-form-label" for="basic-default-message">Ghi chú</label>
                    <div class="col-sm-7">
                        <textarea v-model="order.notes" id="basic-default-message" class="form-control" placeholder="Hãy nhập ghi chú "></textarea>
                    </div>
                </div>
                <div class="row mb-3">
                    <label class="col-sm-5 col-form-label" for="basic-default-message">Trạng thái</label>
                    <div class="col-sm-7">
                        <select class="form-select" v-model="selectedStatus" id="exampleFormControlSelect1" aria-label="Default select example">
                            <option v-for="status in status" :key="status.id" :value="status.id">
                                {{ status.name }}
                            </option>
                        </select>
                    </div>
                </div>
                <div class="row mb-3">
                    <label class="col-sm-5 col-form-label" for="basic-default-message">Thời gian</label>
                    <div class="col-sm-7">
                        <p class="m-6 mt-1"> {{order.created}} </p>
                    </div>
                </div>
                <div class="row mb-3 btn-save">
                    <label class="col-sm-5 col-form-label" for="basic-default-message">Người lên đơn</label>
                    <div class="col-sm-7">
                        <p class="m-6 mt-1"> {{ user.find(x=>x.id==order.user_init)?.display_name }} </p>
                    </div>
                </div>
                <div class="row justify-content-end btn-save">
                    <div class="col-sm-3">
                        <button @click="saveOrder" class="btn btn-primary">Lưu</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="nav-align-top mb-4 ">
    <ul class="nav nav-pills mb-3" role="tablist">
        <li class="nav-item">
            <button type="button" class="nav-link active" role="tab" data-bs-toggle="tab" data-bs-target="#navs-pills-top-profile" aria-controls="navs-pills-top-profile" aria-selected="false">
                Lịch sử cập nhật
            </button>
        </li>
    </ul>
    <div class="tab-content">
        <div class="tab-pane fade active show" id="navs-pills-top-profile" role="tabpanel">
            <div class="table-responsive text-nowrap">
                <table class="table table-bordered mb-4">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Ngày cập nhật</th>
                            <th>Trạng thái</th>
                            <th>Dữ liệu cũ</th>
                            <th>Người cập nhật</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(item, index) in order_log" :key="index">
                            <td>{{ index + 1 }}</td>
                            <td>{{getJustDate(item.created_at)}}</td>
                            <td class="fw-bold">{{ status.find(x=>x.id==item.status)?.name }}</td>
                            <td v-if="item.delete == 1">
                                <span>
                                    <span class="fw-bold">Đã xoá</span> {{ product.find(x => x.ID == item.product_id)?.prd_code }} -
                                    <span class="fw-bold">Số lượng</span> {{ item.quantity }} -
                                    <span class="fw-bold">Giá</span> {{ formatNumber(item.price) }}
                                </span>
                            </td>
                            <td v-else-if="item.product_id"><span>{{ product.find(x=>x.ID==item.product_id)?.prd_code }} - <span class="fw-bold"> Số lượng </span>{{item.quantity}}</span> - <span><span class="fw-bold"> Giá </span>{{formatNumber(item.price)}}</span></td>
                            <td v-else>Thay đổi trạng thái</td>
                            <td class="fw-bold">{{ user.find(x=>x.id==item.user_id)?.display_name }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</template>

<script>
import {
    defineComponent,
    ref,
    toRefs,
    computed
} from "vue";
import {
    useToast
} from "vue-toast-notification";
import {
    useRouter,
    useRoute
} from "vue-router";
import {
    inject
} from 'vue';
import axios from "axios";
import {
    reactive
} from "vue";
export default defineComponent({
    setup() {
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const toast = useToast();
        const router = useRouter();
        const errors = ref({});
        const customer = ref([]);
        const user = ref([]);
        const product = ref([]);
        const status = ref([]);
        const order_detail = ref([]);
        const order = ref([]);
        const order_log = ref([]);
        const selectedStatus = ref(null);
        const getOrderEdit = () => {
            axios
                .get(`${baseUrl}/api/order/${route.params.id}/edit`)
                .then((response) => {
                    const data = response.data.order;
                    order.value = data;
                    customer.value = response.data.customer;
                    order_detail.value = response.data.order_detail;
                    status.value = response.data.status;
                    selectedStatus.value = data.order_status;
                    user.value = response.data.user;
                    order_log.value = response.data.order_log;
                    product.value = response.data.product;
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        const validateQuantity = (line, index) => {
            let quantity = parseInt(line.quantity, 10);
            if (quantity < 0 || isNaN(quantity)) {
                quantity = 0;
            }
            line.quantity = quantity;
            errors.value.quantity = errors.value.quantity || {};
            errors.value.quantity[index] = null;
        };
        const totalQuantity = computed(() => {
            return order_detail.value.reduce((total, line) => total + line.quantity, 0);
        });
        const getJustDate = (dateTime) => {
        return dateTime.split('T')[0];
        };
        const totalAmount = computed(() => {
            return order_detail.value.reduce((total, line) => total + line.quantity * line.price, 0);
        });
        const saveOrder = () => {
            putOrder(route.params.id);
        };
        const putOrder = (id) => {
            const token = localStorage.getItem("token");
            const data = {
                quantity: order_detail.value.map((line) => ({
                    id: line.ID,
                    quantity: line.quantity,
                    price:line.price
                })),
                notes: order.value.notes,
                status: selectedStatus.value
            };
            axios
                .put(
                    `${baseUrl}/api/order/${id}`,
                    data, {
                        headers: {
                            Authorization: `Bearer ${token}`,
                        },
                    }
                )
                .then(() => {
                    toast.success('Cập nhật đơn hàng thành công');
                    getOrderEdit();
                })
                .catch((error) => {
                    console.error(error);
                });
        };
        const deleteProduct = (id, index) => {
            axios
                .delete(`${baseUrl}/api/order/${id}`)
                .then(() => {
                    order_detail.value.splice(index, 1);
                    getOrderEdit();
                    toast.success("Xoá sản phẩm thành công");
                })
                .catch((error) => {
                    console.log(error);
                    toast.error("Xóa khách hàng thất bại");
                });
        };
        const confirmDeleteProducts = (line, index) => {
            if (window.confirm("Bạn có chắc chắn muốn xoá sản phầm này?")) {
                deleteProduct(line, index);
            }
        };
        const formatNumber = (value) => {
                if (value !== undefined && value !== null) {
                    return new Intl.NumberFormat('vi-VN').format(value);
                } else {
                    return '';
                }
            };

        const route = useRoute();
        getOrderEdit();
        return {
            customer,
            errors,
            order,
            order_detail,
            totalQuantity,
            totalAmount,
            confirmDeleteProducts,
            putOrder,
            saveOrder,
            validateQuantity,
            status,
            selectedStatus,
            user,
            formatNumber,
            order_log,
            product,
            getJustDate
        };
    },
});
</script>
