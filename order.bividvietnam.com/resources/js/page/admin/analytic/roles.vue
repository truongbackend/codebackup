<template>
<div class="col-12 col-lg-8">
    <div class="card mb-4">
        <h5 class="card-header me-sm-2">Chi tiết người dùng</h5>
        <div class="card-body">
            <table class="table table-borderless">
                <tbody>
                    <tr>
                        <td class="align-middle"><strong class="fw-semibold">Mã nhân viên</strong></td>
                        <td class="py-3">
                            <p class="mb-0">{{ users.id }}</p>
                        </td>
                    </tr>
                    <tr>
                        <td class="align-middle"><strong class="fw-semibold">Tên nhân viên</strong></td>
                        <td class="py-3">
                            <p class="mb-0">{{ users.username }}</p>
                        </td>
                    </tr>
                    <tr>
                        <td class="align-middle"><strong class="fw-semibold">Email</strong></td>
                        <td class="py-3">
                            <p class="mb-0">{{ users.email }}</p>
                        </td>
                    </tr>
                    <tr>
                        <td class="align-middle"><strong class="fw-semibold">Phone</strong></td>
                        <td class="py-3">
                            <p class="mb-0">{{ users.phone }}</p>
                        </td>
                    </tr>
                    <tr>
                        <td class="align-middle"><strong class="fw-semibold">Nhóm người dùng</strong></td>
                        <td class="py-3">
                            <p class="mb-0">{{ stores.find(x=>x.ID==users.store_id)?.store_name  }}</p>
                        </td>
                    </tr>
                    <tr>
                        <td class="align-middle"><strong class="fw-semibold">Khu vực</strong></td>
                        <td class="py-3">
                            <p class="mb-0">{{ users_group.find(x=>x.id==users.group_id)?.group_name  }}</p>
                        </td>
                    </tr>
                    <tr>
                        <td class="align-middle"><strong class="fw-semibold">Trạng thái</strong></td>
                        <td class="py-3">
                            <p class="text-success" v-if="users.user_status === 1">Hoạt động</p>
                            <p class="text-danger" v-else>Tạm ngừng</p>
                        </td>
                    </tr>
                    <div class="row justify-content">
                        <div class="col-sm-10">
                            <router-link :to="{ name: 'admin-products' }" class="btn btn-primary me-sm-2">Trở về</router-link>
                        </div>
                    </div>
                </tbody>
            </table>
        </div>
    </div>
</div>
<div class="card">
    <h5 class="card-header">Phân quyền</h5>
    <div class="card-body">
        <span>Hãy phân quyền cho người dùng bằng cách tích các chức năng vào checkbox</span>
        <div class="error"></div>
    </div>
    <div class="table-responsive">
        <table class="table table-striped table-borderless border-bottom">
            <thead>
                <tr>
                    <th class="text-nowrap">Chức năng</th>
                    <th class="text-nowrap text-center">Danh sách</th>
                    <th class="text-nowrap text-center">Thêm mới</th>
                    <th class="text-nowrap text-center">Sửa</th>
                    <th class="text-nowrap text-center">Xóa</th>
                </tr>
            </thead>
            <tbody>
                <form action="javascript:void(0);">
                    <tr>
                        <td class="text-nowrap">New for you</td>
                        <td>
                            <div class="form-check d-flex justify-content-center">
                                <input class="form-check-input" type="checkbox" id="defaultCheck1">
                            </div>
                        </td>
                        <td>
                            <div class="form-check d-flex justify-content-center">
                                <input class="form-check-input" type="checkbox" id="defaultCheck2">
                            </div>
                        </td>
                        <td>
                            <div class="form-check d-flex justify-content-center">
                                <input class="form-check-input" type="checkbox" id="defaultCheck3">
                            </div>
                        </td>
                        <td>
                            <div class="form-check d-flex justify-content-center">
                                <input class="form-check-input" type="checkbox" id="defaultCheck3">
                            </div>
                        </td>
                    </tr>
                </form>
            </tbody>
        </table>
    </div>
    <div class="card-body">
        <button type="submit" class="btn btn-primary me-2">Lưu</button>
        <button type="reset" class="btn btn-outline-danger">Hủy</button>
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
        const route = useRoute();
        const errors = ref([]);
        const stores = ref([]);
        const users_group = ref([]);
        const users = ref({
            username: "",
            email: "",
            phone: "",
        });

        const getUsers = () => {
            axios
                .get(`${baseUrl}/api/users/${route.params.user}`)
                .then((response) => {
                    const data = response.data.users;
                    users.value = data;
                    stores.value = response.data.stores;
                    users_group.value = response.data.users_group;
                    console.log(users_group);
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        getUsers();
        return {
            users,
            errors,
            stores,
            users_group,

        };
    },
});
</script>
