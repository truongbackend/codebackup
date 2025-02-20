<template>
<div class="content" v-if="! checkRole('Khách Hàng,Khách hàng ngoài thầu,Khách hàng trong thầu')">
<h4 class="fw-bold py-3 mb-4">
    <span class="text-muted fw-light">Dashboard <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách đơn hàng
    hôm nay
</h4>
<div class="row">
    <div class="col-sm-6 col-lg-3 mb-4">
        <div class="card card-border-shadow-primary h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-2 pb-1">
                    <div class="avatar me-2">
                        <span class="avatar-initial rounded bg-label-primary"><i class="bx bxs-truck"></i></span>
                    </div>
                    <h4 class="ms-1 mb-0">{{ formatNumber(order.totalMoneyToday) }} </h4>
                </div>
                <p class="mb-1">Tổng tiền</p>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-lg-3 mb-4">
        <div class="card card-border-shadow-warning h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-2 pb-1">
                    <div class="avatar me-2">
                        <span class="avatar-initial rounded bg-label-warning"><i class="bx bx-cart"></i></span>
                    </div>
                    <h4 class="ms-1 mb-0">{{ formatNumber(order.totalOrderToday) }}</h4>
                </div>
                <p class="mb-1">Số đơn hàng</p>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-lg-3 mb-4">
        <div class="card card-border-shadow-danger h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-2 pb-1">
                    <div class="avatar me-2">
                        <span class="avatar-initial rounded bg-label-danger"><i class="bx bx-error"></i></span>
                    </div>
                    <h4 class="ms-1 mb-0">{{ formatNumber(order.totalCancelToday) }}</h4>
                </div>
                <p class="mb-1">Số đơn hủy</p>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-lg-3 mb-4">
        <div class="card card-border-shadow-info h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-2 pb-1">
                    <div class="avatar me-2">
                        <span class="avatar-initial rounded bg-label-info"><i class="bx bx-user"></i></span>
                    </div>
                    <h4 class="ms-1 mb-0">{{ order.totalCustomerToday }}</h4>
                </div>
                <p class="mb-1">Tổng số khách</p>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-4">
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between">
                <h6 class="card-title m-0">Hoạt động</h6>
            </div>
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Tổng tiền</h6>
                    <p class="m-6"><u>{{ (order.totalMoneySum).toLocaleString() }}</u></p>
                </div>
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Đơn bán</h6>
                    <p class="m-6"><u>{{ (order.totalOrder).toLocaleString() }}</u></p>
                </div>
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Số lượng</h6>
                    <p class="m-6"><u>{{ Math.floor(order.totalQuantity).toLocaleString() }}</u></p>
                </div>
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Tiền trả hàng</h6>
                    <p class="m-6"><u>0</u></p>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between">
                <h6 class="card-title m-0">Thông tin kho</h6>
            </div>
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Tồn kho</h6>
                    <p class="m-6">{{ products.outStockProduct }}</p>
                </div>
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Hết Hàng</h6>
                    <p class="m-6">{{ products.inventoryProduct }}</p>
                </div>
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Sắp hết hàng</h6>
                    <p class="m-6">0</p>
                </div>
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Vượt định mức</h6>
                    <p class="m-6">0</p>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between">
                <h6 class="card-title m-0">Thông tin sản phẩm</h6>
            </div>
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Sản phẩm/ Nhà sản xuất</h6>
                    <p class="m-6">{{ products.numberProducts }} /{{category.numberCategories }}</p>
                </div>
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Chưa làm giá bán</h6>
                    <p class="m-6">{{products.nullPrice}}</p>
                </div>
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Chưa nhập giá mua</h6>
                    <p class="m-6">{{ products.outStockProduct}}</p>
                </div>
                <div class="d-flex justify-content-between">
                    <h6 class="card-title m-6">Hàng chưa phân loại</h6>
                    <p class="m-6">0</p>
                </div>
            </div>
        </div>
    </div>
</div>
</div>
<div class="row" v-if="checkRole('Khách Hàng,Khách hàng ngoài thầu,Khách hàng trong thầu')">
    <div class="card-body">
        <h4 class="fw-bold py-3 mb-4">
            <span class="text-muted fw-light">Xin chào </span> {{ user.display_name }}
        </h4>
    </div>
</div>
</template>

<script>
import axios from 'axios';
import { defineComponent, ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useToast } from 'vue-toast-notification';
import { inject } from 'vue';
import {
    fetchUserRoles
} from '@/utils/role.js';
export default defineComponent({
    setup() {
        const userRoles = ref([]);
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const order = ref({ totalMoneySum: 0, totalQuantity: 0, totalMoneyToday: 0, totalOrderToday: 0, totalCancelToday: 0, totalCustomerToday: 0, totalOrder: 0 });
        const category = ref({ numberCategories: 0 });
        const products = ref({ numberProducts: 0, nullPrice: 0, inventoryProduct: 0, outStockProduct: 0 })
        const router = useRouter();
        const toast = useToast();
        const user = ref({});
        const token = localStorage.getItem('token');
        const getOrder = () => {
            axios
                .get(`${baseUrl}/api/dashboard`, {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    }
                })
                .then((response) => {
                    order.value.totalMoneySum = response.data.total_money_sum;
                    order.value.totalQuantity = response.data.totalQuantity;
                    category.value.numberCategories = response.data.numberCategories;
                    products.value.numberProducts = response.data.numberProducts;
                    products.value.nullPrice = response.data.nullPrice;
                    order.value.totalMoneyToday = response.data.totalMoneyToday;
                    order.value.totalOrderToday = response.data.totalOrderToday;
                    order.value.totalCancelToday = response.data.totalCancelToday;
                    order.value.totalCustomerToday = response.data.totalCustomerToday;
                    order.value.totalOrder = response.data.totalOrder;
                    order.value.inventoryProduct = response.inventoryProduct;
                    order.value.outStockProduct = response.outStockProduct;
                    user.value = response.data.user;
                })
                .catch((error) => {
                    console.error('Error fetching order data:', error);
                    toast.error('An error occurred while fetching order data.');
                });
        };
        const formatNumber = (value) => {
            if (value !== undefined && value !== null) {
                return value.toLocaleString();
            } else {
                return '';
            }
        };
        onMounted(async () => {
            try {
                userRoles.value = await fetchUserRoles();
            } catch (error) {
                console.error('Error fetching user roles:', error);
            }
        });
         function checkRole(rolesString) {
            const rolesArray = rolesString.split(',').map(role => role.trim());
            return userRoles.value.some(role => rolesArray.includes(role));
        }
        onMounted(() => {
            getOrder();
        });

        return {
            order,
            category,
            products,
            formatNumber,
            user,
            checkRole,
            userRoles,
        };
    },
});
</script>
