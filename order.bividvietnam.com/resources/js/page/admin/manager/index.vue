<template>
<div class="row">
    <div class="col-md-6">
        <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Vùng miền <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách Vùng miền</h4>
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
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Khu vực</th>
                        <th>Ngày tạo</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="store_managers in store_manager" :key="store_manager.id">
                        <td>{{ store_managers.id }}</td>
                        <td>{{ store_managers.name }}</td>
                        <td v-if="store_managers.status == 0"><span class="badge rounded-pill bg-success"> Hoạt động </span></td>
                        <td v-else><span class="badge rounded-pill bg-danger">Không hoạt động</span></td>
                        <td class="text-center">
                            <i class="bx bxs-edit text-dark"></i>
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
        const store_manager = ref([]);
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const getStores = () => {
            axios
                .get(`${baseUrl}/api/manager`)
                .then((response) => {
                    store_manager.value = response.data.store_manager;
                    console.log(store_manager.value);
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        getStores();
        return {
            store_manager,
        };
    },
});
</script>
