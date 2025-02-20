<template>
<div class="row">
    <!-- Basic Layout -->
    <div class="col-xxl">
        <div class="card mb-4">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h5 class="mb-0">Sửa trạng thái</h5>
            </div>
            <div class="card-body">
                <form @submit.prevent="updateStatus">
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="name">Trạng thái</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="status.name" id="name" placeholder="Nhập tên kho bạn muốn thêm..." />
                            <small class="text-danger" v-if="errors.name">{{ errors.name[0] }}</small>
                        </div>
                    </div>
                    <div class="row justify-content-end">
                        <div class="col-sm-10">
                            <router-link :to="{ name: 'admin-status' }" class="btn btn-primary me-sm-2">Hủy</router-link>
                            <button type="submit" class="btn btn-primary">Lưu</button>
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
} from "vue-toast-notification";
import {
    useRouter,
    useRoute
} from "vue-router";
import { inject } from 'vue';
import axios from "axios";
export default defineComponent({
    setup() {
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const toast = useToast();
        const router = useRouter();
        const errors = ref({});
        const status = ref({
            name: "",
        });
        const getStatusEdit = () => {
            axios
                .get(`${baseUrl}/api/status/${route.params.id}/edit`)
                .then((response) => {
                    const data = response.data.status;
                    status.value = data;
                    console.log(status.value);
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        const updateStatus = () => {
            axios
                .put(`${baseUrl}/api/status/${route.params.id}`, status.value)
                .then(() => {
                    toast.success("Bạn đã cập nhật tài khoản thành công");
                    router.push({
                        name: "admin-status"
                    });
                })
                .catch((error) => {
                    if (error.response && error.response.data && error.response.data.errors) {
                        errors.value = error.response.data.errors;
                    } else {
                        toast.error("Cập nhật tài khoản thất bại");
                    }
                });
        };
        const route = useRoute();
        getStatusEdit();
        return {
            status,
            errors,
            updateStatus,
        };
    },
});
</script>
