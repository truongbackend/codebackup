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
                                <td>{{ formatNumber(order_px.total_money) }}</td>
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
                                <td class="text-danger">{{formatNumber(order_debts.unpaid)}}</td>
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
            <div class="card-header d-flex align-items-center justify-content-between">
                <h6 class="card-title m-0">Hợp đồng thầu</h6>
                <button type="button" class="btn btn-primary float-end mt-2" data-bs-toggle="modal" data-bs-target="#basicModal">
                    <i class='bx bxs-user-plus'></i>Thêm hợp đồng
                </button>
                <div class="modal fade" id="basicModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel1">Thêm hợp đồng thầu</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <form @submit.prevent="postBiddingCustomer">
                                <div class="modal-body">
                                    <div class="col mb-3">
                                        <label for="nameBasic" class="form-label">MÃ SỐ THẦU</label>
                                        <input type="text" class="form-control" v-model="product.output_code" id="customer_code" placeholder="ma số thầu" />
                                    </div>
                                    <div class="col mb-3">
                                        <label for="nameBasic" class="form-label">NGÀY BẮT ĐẦU</label>
                                        <input type="date" class="form-control" v-model="product.begin_date" id="customer_code" placeholder="ngày bắt đầu" />
                                    </div>
                                    <div class="col mb-3">
                                        <label for="nameBasic" class="form-label">NGÀY HẾT HẠN</label>
                                        <input type="date" class="form-control" v-model="product.expiration_date" id="customer_code" placeholder="ngày hết hạn" />
                                    </div>

                                    <div class="col mb-3">
                                        <label for="nameBasic" class="form-label">Mã sản phẩm</label>
                                        <model-list-select :list="products" v-model="selectedProduct" option-value="ID" option-text="prd_code" placeholder="Mã sản phẩm"></model-list-select>
                                    </div>
                                    <div class="col mb-3">
                                        <label for="nameBasic" class="form-label">Tên sản phẩm</label>
                                        <model-list-select :list="products" v-model="selectedProduct" option-value="ID" option-text="prd_name" placeholder="Tên sản phẩm"></model-list-select>
                                    </div>
                                    <div class="col mb-3">
                                        <label for="nameBasic" class="form-label">SỐ LƯỢNG</label>
                                        <input type="number" v-model="product.total_quantity" class="form-control" id="customer_code" placeholder="số lượng" />
                                    </div>
                                    <div class="col mb-3">
                                        <label for="nameBasic" class="form-label">đơn giá</label>
                                        <input type="number" v-model="product.prd_sell_price" class="form-control" id="customer_code" placeholder="đơn giá" />
                                    </div>
                                    <div class="col mb-3">
                                        <label for="nameBasic" class="form-label">TỔNG TIỀN</label>
                                        <input type="text" v-model="product.total_price" class="form-control" id="customer_code" placeholder="tổng tiền" />
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-danger">Lưu </button>
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                        Đóng
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
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
                                <th></th>
                            </tr>
                        </thead>
                        <tbody v-if="customerBids.length > 0">
                            <tr v-for="customerBids in customerBids">
                                <td class="text-primary"> {{ customerBids.output_code }}</td>
                                <td>{{customerBids.begin_date }}</td>
                                <td>{{customerBids.expiration_date }}</td>
                                <td>{{ formatNumber(customerBids.total_quantity) }}</td>
                                <td>{{ formatNumber(customerBids.total_price) }}</td>
                                <td>
                                    <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#basicModalHide" @click="editBiddingCustomer(customerBids)" >
                                        <i class="bx bxs-edit me-1 text-dark"></i>
                                    </a>
                                    <i class="bx bx-trash me-1 text-dark" data-bs-toggle="modal" data-bs-target="#basicModalDelete"></i>
                                </td>
                            </tr>
                        </tbody>
                        <tbody v-else>
                            <tr>
                                <td colspan="6">Không có dữ liệu</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="basicModalHide" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel1">Sửa hợp đồng thầu</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form @submit.prevent="postBiddingCustomer">
                    <div class="modal-body">
                        <div class="col mb-3">
                            <label for="nameBasic" class="form-label">MÃ SỐ THẦU</label>
                            <input type="text" class="form-control" v-model="product.output_code" id="customer_code" placeholder="mã số thầu" />
                        </div>
                        <div class="col mb-3">
                            <label for="nameBasic" class="form-label">NGÀY BẮT ĐẦU</label>
                            <input type="date" class="form-control" v-model="product.begin_date" id="customer_code" placeholder="ngày bắt đầu" />
                        </div>
                        <div class="col mb-3">
                            <label for="nameBasic" class="form-label">NGÀY HẾT HẠN</label>
                            <input type="date" class="form-control" v-model="product.expiration_date" id="customer_code" placeholder="ngày hết hạn" />
                        </div>
                        <div class="col mb-3">
                            <label for="nameBasic" class="form-label">Mã sản phẩm</label>
                            <!-- <model-list-select :list="products" v-model="selectedProduct" option-value="ID" option-text="prd_code" placeholder="Mã sản phẩm"></model-list-select>
                            <MultiSelect v-model="selectedCompanny" variant="filled" :options="company" filter optionLabel="name" placeholder="Chọn công ty" :maxSelectedLabels="3" class="w-full md:w-20rem" /> -->
                            <MultiSelect v-model="selectedProduct" variant="filled" :options="products" filter optionLabel="prd_code" placeholder="Mã sản phẩm" :maxSelectedLabels="3" class="w-full md:w-20rem" />
                        </div>
                        <div class="col mb-3">
                            <label for="nameBasic" class="form-label">Tên sản phẩm</label>
                            <model-list-select :list="products" v-model="selectedProduct" option-value="ID" option-text="prd_name" placeholder="Tên sản phẩm"></model-list-select>
                        </div>
                        <div class="col mb-3">
                            <label for="nameBasic" class="form-label">SỐ LƯỢNG</label>
                            <input type="number" v-model="product.total_quantity" class="form-control" id="customer_code" placeholder="số lượng" />
                        </div>
                        <div class="col mb-3">
                            <label for="nameBasic" class="form-label">đơn giá</label>
                            <input type="number" v-model="products.prd_code" class="form-control" id="customer_code" placeholder="đơn giá" />
                        </div>
                        <div class="col mb-3">
                            <label for="nameBasic" class="form-label">TỔNG TIỀN</label>
                            <input type="text" v-model="product.total_price" class="form-control" id="customer_code" placeholder="tổng tiền" />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-danger">Lưu </button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            Đóng
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div class="modal fade" id="basicModalDelete" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel1">Thông báo</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body toast-modal">
                            <div class="col mb-3">
                                <p>Bạn có chắc muốn xóa hợp đồng này không ?</p>
                            </div>
                        </div>
                        <div class="modal-footer toast-modal">
                            <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">
                                Đóng
                            </button>
                            <button type="button" class="btn btn-primary" data-bs-dismiss="modal" @click="DeleteBiddingCustomer(customerBids)">Đồng ý</button>
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
    useToast
} from "vue-toast-notification";
import {
    useRouter,
    useRoute
} from "vue-router";
import {
    ModelListSelect
} from 'vue-search-select';
export default defineComponent({
    components: {
        ModelListSelect,
    },
    setup() {
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const selectedProduct = ref([]);
        const customer = ref([]);
        const toast = useToast();
        const route = useRoute();
        const stores = ref([]);
        const customerBids = ref([]);
        const order = ref([]);
        const products = ref([]);
        const product = ref({
            output_code: "",
            begin_date: "",
            expiration_date: "",
            total_price: "",
            total_quantity: "",
            prd_sell_price: "",
            customer_id: route.params.customer,
        });
        const order_px = ref([]);
        const order_debts = ref([]);
        const users = ref([]);
        const biddingContractCustomer = () => {
            axios
                .get(`${baseUrl}/api/biddingContractCustomer`)
                .then((response) => {
                    products.value = response.data.product;
                })
        };
        const getCustomer = () => {
            axios
                .get(`${baseUrl}/api/customers/${route.params.customer}`)
                .then((response) => {
                    const data = response.data.customer;
                    customer.value = data;
                    stores.value = response.data.stores;
                    customerBids.value = response.data.customerBids;
                    order.value = response.data.order;
                    order_px.value = response.data.order_Px;
                    users.value = response.data.users;
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
        const postBiddingCustomer = () => {
            product.value.product = selectedProduct.value;
            axios.post(`${baseUrl}/api/postBiddingCustomer`, product.value)
                .then(response => {
                    toast.success("Bạn đã tạo tài khoản thành công");
                    getCustomer();
                })
                .catch(error => {
                    if (error.response && error.response.data && error.response.data.errors) {
                        alert("Có lỗi xảy ra khi tạo hợp đồng");
                    } else {
                        console.error(error);
                    }
                });
        };
        const editBiddingCustomer = (customerBids) => {
            const params = {
                customer_id: customerBids.customer_id,
                output_code: customerBids.output_code,
            };
            axios.get(`${baseUrl}/api/editBiddingCustomer`, { params })
            .then(response => {
                product.value = response.data.product;
                selectedProduct.value = products.value.find(p => p.ID === response.data.product.product_id);
                products.value = response.data.products;
            })
            .catch(error => {
                toast.error("Sửa không thành công");
            });
        }
        const DeleteBiddingCustomer = (customerBids)=>{
            const params = {
                customer_id: route.params.customer,
                output_code: customerBids.ID,
            };
            axios.delete(`${baseUrl}/api/DeleteBiddingCustomer`, { params })
            .then(response => {
                toast.success("Bạn đã xoá hợp đồng thành công");
            })
            .catch(error => {
                toast.error("Xoá không thành công");
            });
        }
        const formatNumber = (value) => {
                if (value !== undefined && value !== null) {
                    return new Intl.NumberFormat('vi-VN').format(value);
                } else {
                    return '';
                }
            };
        getCustomer();
        biddingContractCustomer();
        return {
            customer,
            stores,
            customerBids,
            order,
            order_px,
            order_debts,
            calculateRemainingDays,
            users,
            products,
            selectedProduct,
            postBiddingCustomer,
            product,
            editBiddingCustomer,
            formatNumber,
            DeleteBiddingCustomer
        };
    },
});
</script>
