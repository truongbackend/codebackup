<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Khách hàng <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Tạo mới khách hàng</h4>
<div class="row">
    <div class="col-xxl">
        <div class="card mb-4">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h5 class="mb-0">Thêm khách hàng</h5>
            </div>
            <div class="card-body">
                <form @submit.prevent="createCustomers()">
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="customer_code">Mã khách hàng</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="customer.customer_code" id="customer_code" disabled placeholder="Mã khách hàng tự sinh" />
                        </div>
                        <div class="col-sm-10">
                            <small v-if="errors.customer_code">{{errors.customer_code[0] }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="customer_name">Tên khách hàng</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="customer.customer_name" id="customer_name" placeholder="Nhập tên khách hàng" />
                            <small class="text-danger text-start-center" v-if="errors.customer_name">{{ errors.customer_name[0] }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="customer_phone">Số điện thoại</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="customer.customer_phone" id="customer_phone" placeholder="012345678" />
                            <small class="text-danger text-start-center" v-if="errors.customer_phone">{{ errors.customer_phone[0] }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="customer_email">Email</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="customer.customer_email" id="customer_email" placeholder="Nhập email khách hàng ( ví dụ: abc@gmail.com )" />
                            <small class="text-danger text-start-center" v-if="errors.customer_email">{{ errors.customer_email[0] }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="customer_addr">Địa chỉ</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="customer.customer_addr" id="customer_addr" />
                            <small class="text-danger text-start-center" v-if="errors.customer_addr">{{ errors.customer_phone[0] }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="customer_ship_addr">Địa chỉ nhận hàng</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="customer.customer_ship_addr" id="customer_ship_addr" />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Khu vực</label>
                        <div class="col-sm-10">
                            <select v-model="customer.customer_store" class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                                <option v-for="store in stores" :value="store.value" :key="store.value">
                                    {{ store.store_name }}
                                </option>
                            </select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="notes">Ghi chú</label>
                        <div class="col-sm-10">
                            <textarea class="form-control" v-model="customer.notes" id="notes" rows="5"></textarea>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="customer_image" class="col-sm-2 col-form-label">Hình ảnh khách hàng</label>
                        <div class="col-sm-10">
                            <input type="file" v-on:change="handleImageChange" id="customer_image" class="form-control" />
                            <small class="text-danger text-start-center" v-if="errors.customer_image">{{
                                    errors.customer_image[0] }}</small>
                        </div>
                    </div>
                    <div class="modal-footer mt-3">
                        <button type="submit" class="btn btn-primary">
                                Lưu
                            </button>
                        <router-link :to="{ name: 'admin-customer' }" class="btn btn-danger me-sm-2">
                                Hủy
                            </router-link>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</template>

<script>
import {
    defineComponent,
    ref,
    toRefs
} from "vue";
import {
    useToast
} from "vue-toast-notification";
import {
    useRouter
} from "vue-router";
import axios from "axios";
import {
    inject
} from "vue";
export default defineComponent({
    setup() {
        const globalState = inject("globalState");
        const baseUrl = globalState.baseUrl;
        const router = useRouter();
        const stores = ref([]);
        const customer = ref({
            customer_code: "",
            customer_name: "",
            customer_email: "",
            customer_phone: "",
            customer_addr: "",
            customer_ship_addr: "",
            customer_store: "",
            notes: "",
            customer_image: "",
            user_init: 0,
            created: Date(),
        });
        const createCustomers = () => {
            const body = new FormData();
            body.append("customer_image", customer.customer_image);
            body.append("customer_name", customer.value.customer_name);
            body.append("customer_code", customer.value.customer_code);
            body.append("customer_email", customer.value.customer_email);
            body.append("customer_phone", customer.value.customer_phone);
            body.append("customer_addr", customer.value.customer_addr);
            body.append(
                "customer_ship_addr",
                customer.value.customer_ship_addr
            );
            body.append("customer_store", customer.value.customer_store);
            body.append("notes", customer.value.notes);
            body.append("user_init", customer.value.user_init);
            const config = {
                "Content-Type": "multipart/form-data",
            };
            axios
                .post(`${baseUrl}/api/customers`, body, config)
                .then(function (response) {
                    const toast = useToast();
                    toast.success("Bạn đã tạo tài khoản thành công");
                    router.push({
                        name: "admin-customer",
                    });
                })
                .catch(function (error) {
                    if (error.response && error.response.status === 422) {
                        errors.value = error.response.data.errors;
                    }
                });
        };
        const handleImageChange = (event) => {
            const imageFile = event.target.files[0];
            customer.customer_image = imageFile;
            console.log(customer.customer_image);
        };
        const errors = ref({});
        const getCustomersCreat = () => {
            axios
                .get(`${baseUrl}/api/customers/create`)
                .then((response) => {
                    stores.value = response.data.stores.data;
                })
                .catch((error) => {
                    console.log(error);
                    errors.value = error.response.data.error;
                });
        };
        getCustomersCreat();
        return {
            stores,
            createCustomers,
            errors,
            customer,
            handleImageChange,
        };
    },
});
</script>
