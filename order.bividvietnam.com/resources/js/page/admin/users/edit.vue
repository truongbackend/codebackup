<template>
<div class="row">
    <!-- Basic Layout -->
    <div class="col-xxl">
        <div class="card mb-4">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h5 class="mb-0">Sửa người dùng</h5>
            </div>
            <div class="card-body">
                <form @submit.prevent="updateUsers()">
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="username">Tên nhân viên</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="users.username" id="username" placeholder="Nhâp tên nhân viên" />
                            <small class="text-danger text-start-center" v-if="errors.username">{{ errors.username[0]
                                }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="id">Mã nhân viên</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="users.id" id="id" placeholder="Nhâp mã nhân viên" />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="email">Email</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="users.email" id="email" placeholder="Nhập email khách hàng ( ví dụ: abc@gmail.com )" />
                            <small class="text-danger text-start-center" v-if="errors.email">{{ errors.email[0]
                                }}</small>
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
                            <small class="text-danger text-start-center" v-if="errors.phone">{{ errors.phone[0]
                                }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Nhóm người dùng</label>
                        <div class="col-sm-10">
                            <select v-model="users.group_id" class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                                <option v-for="users_group in users_group" :value="users_group.id" :key="users_group.value">{{ users_group.group_name }}</option>
                            </select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Khu vực</label>
                        <div class="col-sm-10">
                            <select v-model="users.store_id" class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                                <option v-for="store in stores" :value="store.ID">{{ store.store_name }}</option>
                            </select>
                        </div>
                    </div>
                    <div class="row justify-content-end">
                        <div class="col-sm-10">
                            <router-link :to="{ name: 'admin-users' }" class="btn btn-primary me-sm-2">
                                Hủy
                            </router-link>
                            <button type="submit" class="btn btn-primary ">Lưu</button>
                        </div>
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
} from 'vue-toast-notification';
import {
    useRouter
} from "vue-router";
import {
    useRoute
} from "vue-router";
import axios from 'axios';
import {
    inject
} from 'vue';
export default defineComponent({
    setup() {
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const toast = useToast();
        const stores = ref([]);
        const roles = ref([]);
        const users_group = ref([]);
        const router = useRouter();
        const route = useRoute();
        const errors = ref([]);
        const users = ref({
            username: "",
            email: "",
            phone: "",
            store_id: "",
        });

        const getUsersEdit = () => {
            axios
                .get(`${baseUrl}/api/users/${route.params.id}/edit`)
                .then((response) => {
                    const data = response.data.users;
                    users.value = data;
                    stores.value = response.data.stores.data;
                    users_group.value = response.data.users_group.data
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        const updateUsers = () => {
            axios.put(`${baseUrl}/api/users/${route.params.id}`, users.value)
                .then((response) => {
                    toast.success("Bạn đã cập nhật tài khoản thành công");
                    router.push({
                        name: 'admin-users'
                    });
                })
                .catch((error) => {
                    toast.error("Cập nhật tài khoản thất baị");
                });
        };
        getUsersEdit();
        return {
            stores,
            roles,
            users,
            errors,
            users_group,
            ...toRefs(users),
            updateUsers,
        };
    },
});
</script>
