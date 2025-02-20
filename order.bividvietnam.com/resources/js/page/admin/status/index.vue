<template>
<div class="card">
    <div class="card-header d-flex align-items-center justify-content-between">
        <h5 class="mb-0">Danh sách trạng thái</h5>
        <router-link :to="{ name: 'admin-status-create' }">
            <button type="button" class="btn btn-primary float-end">Thêm trạng thái</button>
        </router-link>
    </div>
    <div class="card-body">
        <div class="table-responsive text-nowrap">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Trạng thái</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(status, index) in status" :key="index">
                        <td>{{ index + 1 }}</td>
                        <td>{{ status.name }}</td>
                        <td>
                            <div class="dropdown">
                                <button type="button" class="btn p-0 dropdown-toggle hide-arrow" data-bs-toggle="dropdown">
                                    <i class="bx bx-dots-vertical-rounded"></i>
                                </button>
                                <div class="dropdown-menu">
                                    <router-link :to="{ name: 'admin-status-update', params: { id: status.id } }">
                                        <a class="dropdown-item" href="javascript:void(0);">
                                            <i class="bx bx-edit-alt me-1"></i>Edit
                                        </a>
                                    </router-link>
                                    <a @click="confirmDeleteStatus(status)" class="dropdown-item" href="javascript:void(0);">
                                        <i class="bx bx-trash me-1"></i> Delete
                                    </a>
                                </div>
                            </div>
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
        const status = ref([]);
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const getStatus = () => {
            axios
                .get(`${baseUrl}/api/status`)
                .then((response) => {
                    status.value = response.data.status.data;
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        const deleteStatus = (statusId) => {
            axios
                .delete(`${baseUrl}/api/status/${statusId}`)
                .then(() => {
                    toast.success('Xoá khách hàng thành công');
                    status.value = status.value.filter((status) => status.id !== statusId);
                })
                .catch((error) => {
                    console.log(error);
                    toast.error('Xóa khách hàng thất bại');
                });
        };
        const confirmDeleteStatus = (status) => {
            if (window.confirm('Bạn có chắc chắn muốn xoá khách hàng này?')) {
                deleteStatus(status.id);
            }
        };
        getStatus();
        return {
            status,
            confirmDeleteStatus,
        };
    },
});
</script>
