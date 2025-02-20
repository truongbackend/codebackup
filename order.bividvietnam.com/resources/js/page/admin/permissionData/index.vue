<template>
<div class="row">
    <div class="col-md-6">
        <h4 class="fw-bold py-3 mb-4">
            <span class="text-muted fw-light">Nhóm quyền theo dữ liệu
                <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span>
            Danh sách nhóm quyền theo dữ liệu
        </h4>
    </div>
    <div class="col-md-6 mt-2">
        <router-link :to="{ name: 'admin-permission-user-data-create' }">
            <button type="button" class="btn btn-primary float-end mt-2">
                <i class='bx bx-plus'></i>Thêm nhóm quyền
            </button>
        </router-link>
    </div>
</div>
<div class="card">
    <div class="card-body">
        <div class="table-responsive text-nowrap">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Nhóm quyền</th>
                        <th>Khu vực</th>
                        <th>Hoạt động</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(permissionDataItem,index) in permissionData" :key="index">
                        <td>{{ index + 1 }}</td>
                        <td>{{ roles.find(x => x.id == permissionDataItem.role_id)?.name }}</td>
                        <td>{{ stores.find(x => x.ID == permissionDataItem.store_id)?.store_name }}</td>
                        <td v-if="permissionDataItem.status === 1">
                            <span class="badge rounded-pill bg-success"> Hoạt động </span>
                        </td>
                        <td v-else>
                            <span class="badge rounded-pill bg-danger">Không hoạt động</span>
                        </td>
                        <td class="text-center">
                            <router-link :to="{ name: 'admin-permission-user-data-edit', params: { id: permissionDataItem.id } }">
                                <i class="bx bxs-edit text-dark"></i>
                            </router-link>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
</template>


<script>
import axios from 'axios';
import {
    defineComponent,
    ref
} from 'vue';
import {
    useToast
} from 'vue-toast-notification';
import {
    inject
} from 'vue';

export default defineComponent({
    setup() {
        const toast = useToast();
        const stores = ref([]);
        const store_manager = ref([]);
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const permissionData = ref([]);
        const roles = ref([]);

        const getStores = () => {
            axios
                .get(`${baseUrl}/api/permission/data`)
                .then((response) => {
                    permissionData.value = response.data.permissionData;
                    stores.value = response.data.stores;
                    roles.value = response.data.roles;
                })
                .catch((error) => {
                    console.log(error);
                });
        };

        getStores();

        return {
            stores,
            permissionData,
            roles,
        };
    },
});
</script>
