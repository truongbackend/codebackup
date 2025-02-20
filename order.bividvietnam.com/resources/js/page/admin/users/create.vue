<template>
<div class="row">
    <div class="col-md-6">
        <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Doanh sách người dùng <i class='bx bx-chevron-right' style="font-size: 40px;"></i></span> Thêm người dùng</h4>
    </div>
</div>
<div class="row">
    <div class="col-xxl">
        <div class="card mb-4">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h5 class="mb-0 fw-bold">Thêm người dùng</h5>
            </div>
            <hr class="my-1">
            <div class="card-body">
                <form @submit.prevent="createUsers()">
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="username">Tên người dùng</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="users.display_name" id="username" placeholder="Nhâp tên nhân viên" />
                            <small class="text-danger text-start-center" v-if="errors.display_name">{{ errors.display_name[0] }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="email">Email</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="users.email" id="email" placeholder="Nhập email khách hàng ( ví dụ: abc@gmail.com )" />
                            <small class="text-danger text-start-center" v-if="errors.email">{{ errors.email[0] }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="password">Mật khẩu</label>
                        <div class="col-sm-10">
                            <input type="password" class="form-control" v-model="users.password" id="password" readonly />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="phone">Số điện thoại</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="users.phone" id="phone" placeholder="012345678" />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Nhóm quyền</label>
                        <div class="col-sm-10">
                            <select v-model="users.role" class="form-select" id="exampleFormControlSelect6" aria-label="Default select example">
                                <option value="">Chọn quyền</option>
                                <option v-for="role in role" :value="role.id" :key="role.value">{{ role.name }}</option>
                            </select>
                            <small class="text-danger text-start-center" v-if="errors.role">{{ errors.role[0] }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Khu vực</label>
                        <div class="col-sm-10">
                            <select v-model="users.store_id" class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                                <option value="">Chọn khu vực</option>
                                <option v-for="store in stores" :value="store.ID">{{ store.store_name }}</option>
                            </select>
                            <small class="text-danger text-start-center" v-if="errors.store_id">{{ errors.store_id[0] }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="exampleFormControlSelect2" class="col-sm-2 col-form-label">Công ty</label>
                        <div class="col-sm-10">
                            <MultiSelect v-model="selectedCompanny" variant="filled" :options="company" filter optionLabel="name" placeholder="Chọn công ty" :maxSelectedLabels="3" class="w-full md:w-20rem" />
                            <small class="text-danger text-start-center" v-if="errors.company_id">{{ errors.company_id[0] }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Hoạt động</label>
                        <div class="col-sm-10 mt-2">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="defaultCheck3" v-model="users.user_status">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary" :disabled="isSaving">Lưu</button>
                        <router-link :to="{ name: 'admin-permission' }" class="btn btn-danger me-sm-2">
                            Thoát
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
    ref,watch
} from "vue";
import {
    useToast
} from "vue-toast-notification";
import {
    useRouter
} from "vue-router";
import {
    inject
} from "vue";
import axios from "axios";

export default defineComponent({
    setup() {
        const globalState = inject("globalState");
        const baseUrl = globalState.baseUrl;
        const toast = useToast();
        const router = useRouter();
        const isSaving = ref(false);
        const stores = ref([]);
        const role = ref([]);
        const company = ref([]);
        const errors = ref([]);
        const users = ref({
            username: "",
            store_id: "",
            id: "",
            email: "",
            phone: "",
            password: "test123456",
            user_status: true,
            display_name: "",
        });
        const selectedCompanny = ref();
        const createUsers = () => {
            if (isSaving.value) {
                return;
            }
            isSaving.value = true;
            const companyIds = selectedCompanny.value.map(company => company.id);
            users.value.company_id = companyIds;
            users.user_status = users.user_status ? 1 : 0;
            axios
                .post(`${baseUrl}/api/users`, users.value)
                .then(function (response) {
                    toast.success("Bạn đã tạo tài khoản thành công");
                    router.push({
                        name: "admin-permission"
                    });
                })
                .catch(function (error) {
                    errors.value = error.response.data.errors;
                    if (error.response.status === 422 && error.response.data.errors.email) {
                        toast.error("Email này đã tồn tại trong hệ thống.");
                    } else {
                        toast.error("Bạn đã tạo tài khoản thất bại.");
                    }
                })
                .finally(() => {
                    isSaving.value = false;
                });
        };

        const getUsersCreate = () => {
            axios
                .get(`${baseUrl}/api/users/create`)
                .then((response) => {
                    stores.value = response.data.stores.data;
                    company.value = response.data.company;
                })
                .catch((error) => {
                    errors.value = error.response.data.errors;
                });
        };
        const getRole = () =>{
            axios.get(`${baseUrl}/api/roles`)
                .then(response => {
                    role.value = response.data;
                })
                .catch(error => {
                    console.error(error);
                });
        }
        watch(() => users.value.email, (newEmail) => {
            if (newEmail) {
                users.value.username = newEmail.split('@')[0];
            } else {
                users.value.username = "";
            }
        });
        getUsersCreate();
        getRole();
        return {
            stores,
            users,
            createUsers,
            errors,
            role,
            isSaving,
            company,
            selectedCompanny
        };
    },
});
</script>
