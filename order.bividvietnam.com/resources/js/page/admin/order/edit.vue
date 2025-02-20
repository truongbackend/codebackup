<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">
        <router-link :to="{ name: 'admin-order' }">Đơn hàng </router-link><i class="bx bx-chevron-right" style="font-size: 40px;"></i>
    </span> {{ order.output_code}}</h4>
<div class="row ">

    <div class="col-12 col-lg-9">
        <div class="card mb-4">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h5 class="mb-0">Sản phẩm trong thầu</h5>
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
                                <td>{{ line.price.toLocaleString() }}</td>
                                <td>{{ (line.quantity * line.price).toLocaleString() }}</td>
                                <td><a @click="confirmDeleteProducts(line.ID, index)" href="javascript:void(0);"><i class="bx bx-trash me-1 text-dark">
                                        </i></a></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="alert alert-warning text-end mt-4" role="alert">
                    Số lượng: {{ totalQuantity }}, Tổng tiền: {{ totalAmount.toLocaleString() }}
                </div>
            </div>
        </div>
    </div>
    <div class="col-12 col-lg-3">
        <div class="card mb-4">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h5 class="mb-0">Khách hàng</h5>
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
                <div class="row justify-content-end">
                    <div class="col-sm-3">
                        <button @click="saveOrder" class="btn btn-primary">Lưu</button>
                    </div>
                </div>
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
        const product_unt = ref([]);
        const order_detail = ref([]);
        const order = ref([]);
        const getOrderEdit = () => {
            axios
                .get(`${baseUrl}/api/order/${route.params.id}/edit`)
                .then((response) => {
                    const data = response.data.order;
                    order.value = data;
                    customer.value = response.data.customer;
                    order_detail.value = response.data.order_detail;
                    product_unt.value = response.data.product_unt;
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
                    quantity: line.quantity
                })),
                notes: order.value.notes
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
        const route = useRoute();
        getOrderEdit();
        return {
            customer,
            errors,
            order,
            order_detail,
            totalQuantity,
            totalAmount,
            product_unt,
            confirmDeleteProducts,
            putOrder,
            saveOrder,
            validateQuantity,
        };
    },
});
</script>
