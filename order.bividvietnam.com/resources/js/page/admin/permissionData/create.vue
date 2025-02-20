<template>
<h4 class="fw-bold py-3 mb-4">
    <span class="text-muted fw-light">Phân quyền theo dữ liệu
        <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span>Thêm nhóm quyền theo dữ liệu
</h4>
<div class="row">
    <div class="col-xxl">
        <div class="card mb-4">
            <div class="card-body">
                <form @submit.prevent="createPermissionData">
                    <div class="row mb-3">
                        <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Nhóm quyền</label>
                        <div class="col-sm-10">
                            <select v-model="permissionData.role_id" class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                                <option value>Chọn nhóm quyền</option>
                                <option v-for="role in roles" :value="role.id">{{ role.name }}</option>
                            </select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Khu vực</label>
                        <div class="col-sm-10">
                            <select v-model="permissionData.store_id" class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                                <option value>Chọn khu vực</option>
                                <option v-for="store in stores" :value="store.ID">{{ store.store_name }}</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-sm-2 col-form-label mt-1" for="basic-default-name">Hoạt động</label>
                        <div class="col-sm-2 mt-2">
                            <input v-model="permissionData.status" class="form-check-input" type="checkbox" id="flexSwitchCheckDefault" />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Lưu</button>
                        <router-link :to="{ name: 'admin-stores' }" type="button" class="btn btn-danger">Hủy</router-link>
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
    ref
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
        const toast = useToast();
        const router = useRouter();
        const errors = ref({});
        const roles = ref([]);
        const stores = ref([]);
        const permissionData = ref({
            role_id: "",
            store_id: "",
            status: true,
        });

        const createPermissionData = () => {
            axios
                .post(`${baseUrl}/api/permission/data/create`, {
                    role_id: permissionData.value.role_id,
                    store_id: permissionData.value.store_id,
                    status: permissionData.value.status,

                })
                .then((response) => {
                    toast.success("Bạn đã tạo quyền thành công");
                    router.push({
                        name: "admin-permission-user-data"
                    });
                })
                .catch((error) => {
                    if (error.response && error.response.data && error.response.data.errors) {
                        errors.value = error.response.data.errors;
                    } else {
                        toast.error("Có lỗi xảy ra khi tạo quyền");
                    }
                });
        };

        const getPemissionData = () => {
            axios
                .get(`${baseUrl}/api/permission/data`)
                .then((response) => {
                    roles.value = response.data.roles;
                    stores.value = response.data.stores;
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        getPemissionData();

        return {
            createPermissionData,
            roles,
            errors,
            stores,
            permissionData,
        };
    },
});
</script>
