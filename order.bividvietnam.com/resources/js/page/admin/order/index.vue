<template>
<div class="row">
    <div class="col-md-6">
        <h4 class="fw-bold">
            <span class="text-muted fw-light">Đơn hàng <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách đơn hàng
        </h4>
    </div>
    <div class="col-md-6" v-if="hasPermission('order.create')">
        <router-link :to="{ name: 'sop' }">
            <button type="button" class="btn btn-primary float-end"> <i class='bx bx-plus'></i>Thêm đơn
                hàng</button>
        </router-link>
    </div>
</div>

<div class="card">
    <div class="card-header">
        <div class="input-group input-group-merge">
            <span class="input-group-text" id="basic-addon-search31"><i class="bx bx-search"></i></span>
            <input class="form-control" id="html5-search-input" v-model="searchKeyword" @input="searchOrder" type="text" placeholder="Hãy nhập thông tin tìm kiếm...">
        </div>
    </div>
    <div class="card-body">
        <div class="table-responsive text-nowrap mb-4">
            <table class="table table-striped">
                <thead>
                    <tr class="text-nowrap alert-secondary">
                        <th>#</th>
                        <th>Mã đơn hàng</th>
                        <th>Khách hàng</th>
                        <th>Người đặt</th>
                        <th>Khu vực</th>
                        <th>Trạng thái</th>
                        <th>Ngày đặt hàng</th>
                        <th>Tổng tiền</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(order, index) in order">
                        <td>{{ index + 1 }}</td>
                        <td>
                            <router-link :to="{ name: 'admin-order-detail', params: { order: order.ID } }">{{
                                    order.output_code }}</router-link>
                        </td>
                        <td class="formart-customer">{{ customer.find(x => x.ID == order.customer_id)?.customer_name }}</td>
                        <td>{{ users.find(x => x.id == order.user_init)?.display_name }}</td>
                        <td>{{ stores.find(x => x.ID == order.store_id)?.store_name }}</td>
                        <td>{{ status.find(x => x.id == order.order_status)?.name }}</td>
                        <td>{{ order.created }}</td>
                        <td>{{ formatNumber(order.total_money) }}</td>
                        <td>
                            <div class="dropdown">
                                <a href="javascript:void(0);" @click="printInvoice(order.ID)"><i class='bx bx-printer text-dark'></i></a>
                                <a href="javascript:void(0);" @click="getOrderStatus(order.ID)"><i class="bx bx-trash text-dark"></i></a>
                                <router-link :to="{ name: 'admin-order-update', params: { id: order.ID } }">
                                    <i class="bx bxs-edit text-dark"></i>
                                </router-link>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-end pagination-reponsive">
                <li class="page-item prev">
                    <a class="page-link" href="javascript:void(0); " @click="changePage('first')">
                        <i class="tf-icon bx bx-chevrons-left"></i>
                    </a>
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
    computed,
    watch,
    onMounted
} from 'vue';
import {
    useToast
} from 'vue-toast-notification';
import {
    inject
} from 'vue';
import printJS from 'print-js';
import {
    fetchUserPermission
} from '@/utils/permission.js';
export default defineComponent({
    setup() {
        const userPermission = ref([]);
        const toast = useToast();
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const searchKeyword = ref('');
        const currentPage = ref(1);
        const customer = ref([]);
        const itemsPerPage = 10;
        const users = ref([]);
        const stores = ref([]);
        const order = ref([]);
        const status = ref([]);
        const template = ref([]);
        let totalPages = ref(0);
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
        const getOrder = () => {
            axios
                .get(`${baseUrl}/api/order`, {
                    params: {
                        page: currentPage.value,
                        per_page: itemsPerPage,
                        keyword: searchKeyword.value,
                    },
                })
                .then((response) => {
                    order.value = response.data.order.data;
                    customer.value = response.data.customer;
                    totalPages.value = response.data.order.last_page;
                    stores.value = response.data.stores;
                    users.value = response.data.users;
                    status.value = response.data.status;
                    template.value = response.data.template;

                })
                .catch((error) => {
                    console.log(error);
                });
        };
        const formatNumber = (value) => {
            if (value !== undefined && value !== null) {
                return value.toLocaleString();
            } else {
                return '';
            }
        };
        const getOrderStatus = (orderId) => {
            if (confirm("Bạn có chắc chắn muốn xóa đơn hàng trên trang này?")) {
                axios
                    .put(`${baseUrl}/api/order/${orderId}`, {
                        order_status: 13,
                        deleted: 1
                    }, )
                    .then((response) => {
                        toast.success("Cập nhật thành công đơn hàng");
                    })
                    .catch((error) => {
                        console.error(error);
                        toast.error("Lỗi cập nhật đơn hàng");
                    });
            }
        };
        const printInvoice = (orderId) => {
            axios.get(`${baseUrl}/api/order/${orderId}`)
                .then((response) => {
                    const OrderDetail = response.data.order_detail;
                    const maDonHang = response.data.order['output_code'];
                    const chietKhau = response.data.order['discount_item'];
                    const customerPay = response.data.order['customer_pay'];
                    const ngayXuat = response.data.order['created'];
                    const khach_Hang = response.data.customerOrder['customer_name'];
                    const diaChi = response.data.customerOrder['customer_addr'];
                    const soDienThoai = response.data.customerOrder['customer_phone'];
                    const tongTienHang = response.data.order['total_price'];
                    const note = response.data.order['notes'];
                    const userOrder = response.data.userOrder['display_name']
                    let tableContent = `
                <table border="1">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Tên sản phẩm</th>
                            <th>Số Lượng</th>
                            <th>Gía</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
            `;
                    OrderDetail.forEach((product, index) => {
                        tableContent += `
                    <tr>
                        <td>${index + 1}</td>
                        <td>${product.product_name}</td>
                        <td>${product.quantity}</td>
                        <td>${product.price}</td>
                        <td>${(product.quantity * product.price).toLocaleString()}</td>
                    </tr>
                `;
                    });
                    const invoiceContentWithMaDonHang = response.data.template['content'].replace('{Ma_Don_Hang}', maDonHang);
                    const invoiceContentWithNgayXuat = invoiceContentWithMaDonHang.replace('{Ngay_Xuat}', ngayXuat);
                    const invoiceContentWithCustomerInfo = invoiceContentWithNgayXuat
                        .replace('{Khach_Hang}', khach_Hang)
                        .replace('{DC_Khach_Hang}', diaChi)
                        .replace('{DT_Khach_Hang}', soDienThoai)
                        .replace('{Tong_Tien_Hang}', tongTienHang)
                        .replace('{Ghi_Chu}', note)
                        .replace('{Thu_Ngan}', userOrder)
                        .replace('{Chiec_Khau}', chietKhau)
                        .replace('{Khach_Dua}', customerPay)
                        .replace('{Chi_Tiet_San_Pham}', tableContent);
                    const printWindow = window.open('', '', 'width=800px,height=800px');
                    printWindow.document.open();
                    printWindow.document.write(`
                <html>
                <head>
                    <title>Hóa đơn đơn hàng</title>

<style>
body {
    font-family: Arial, sans-serif;
}
</style>
                </head>
                <body>
                    ${invoiceContentWithCustomerInfo}
                </body>
                </html>
            `);
                    printWindow.document.close();
                    printWindow.print();
                })
                .catch((error) => {
                    console.error(error);
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
            getOrder();
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
        watch(searchKeyword, () => {
            currentPage.value = 1;
            getOrder();
        });
        getOrder();
        return {
            order,
            searchKeyword,
            currentPage,
            displayedPages,
            changePage,
            customer,
            stores,
            users,
            status,
            template,
            getOrderStatus,
            printInvoice,
            hasPermission,
            formatNumber
        };
    },

});
</script>
