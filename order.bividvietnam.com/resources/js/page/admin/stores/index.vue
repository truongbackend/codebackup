<template>
<div class="row">
    <div class="col-md-6">
        <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Khu vực <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Doanh sách khu vực</h4>
    </div>
    <div class="col-md-6 mt-2">
        <router-link :to="{ name: 'admin-stores-create' }">
            <button type="button" class="btn btn-primary float-end mt-2"> <i class='bx bx-plus'></i>Thêm khu vực</button>
        </router-link>
    </div>
</div>
<div class="card">
    <div class="card-body">
        <div class="table-responsive text-nowrap">
            <table class="table table-striped">
                <thead>
                    <tr class="text-nowrap alert-secondary">
                        <th>STT</th>
                        <th>Khu vực</th>
                        <th>Ngày tạo</th>
                        <th>Hoạt động</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(store, index) in stores" :key="index">
                        <td>{{ index+1 }}</td>
                        <td>{{ store.store_name }}</td>
                        <td>{{ store.created }}</td>
                        <td v-if="store.status == 1"><span class="badge rounded-pill bg-success"> Hoạt động </span></td>
                        <td v-else><span class="badge rounded-pill bg-danger">Không hoạt động</span></td>
                        <td class="text-center">
                            <router-link :to="{ name: 'admin-stores-update', params: { id: store.ID } }">
                                <i class="bx bxs-edit text-dark"></i>
                            </router-link>
                            <a @click="confirmDeleteStore(store)">
                                <i class="bx bx-trash text-dark"></i>
                            </a>
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
        const getStores = () => {
            axios
                .get(`${baseUrl}/api/stores`)
                .then((response) => {
                    stores.value = response.data.stores.data;
                    store_manager.value = response.data.store_manager.data
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        const deleteStore = (storeId) => {
            axios
                .delete(`${baseUrl}/api/stores/${storeId}`)
                .then(() => {
                    toast.success('Xoá khách hàng thành công');
                    stores.value = stores.value.filter((store) => store.ID !== storeId);
                    console.log(stores.value);
                })
                .catch((error) => {
                    console.log(error);
                    toast.error('Xóa khách hàng thất bại');
                });
        };
        const confirmDeleteStore = (store) => {
            if (window.confirm('Bạn có chắc chắn muốn xoá khách hàng này?')) {
                deleteStore(store.ID);
            }
        };
        getStores();
        return {
            stores,
            confirmDeleteStore,
            store_manager,
        };
    },
});
</script>
