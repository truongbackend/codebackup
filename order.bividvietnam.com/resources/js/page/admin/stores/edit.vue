<template>
    <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Khu vực<i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Cập nhật khu vực</h4>
<div class="row">
    <div class="col-xxl">
        <div class="card mb-4">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h5 class="mb-0">Sửa nhà kho</h5>
            </div>
            <div class="card-body">
                <form @submit.prevent="updateStores">
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="store_name">Tên kho</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="stores.store_name" id="store_name" placeholder="Nhập tên kho bạn muốn thêm..." />
                            <small class="text-danger" v-if="errors.store_name">{{ errors.store_name[0] }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Hoạt động</label>
                        <div class="col-sm-10">
                            <input class="form-check-input mt-2" type="checkbox" v-model="isActive" />
                        </div>
                    </div>
                    <div class="row justify-content-end">
                        <div class="col-sm-10">
                            <button type="submit" class="btn btn-danger me-sm-2">Lưu</button>
                            <router-link :to="{ name: 'admin-stores' }" class="btn btn-primary">Hủy</router-link>
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
import {
    inject
} from 'vue';
import axios from "axios";
export default defineComponent({
    setup() {
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const toast = useToast();
        const router = useRouter();
        const errors = ref({});
        const isActive = ref(true);
        const stores = ref({
            store_name: "",
            user_init: 1
        });
        const getStoresEdit = () => {
            axios
                .get(`${baseUrl}/api/stores/${route.params.id}/edit`)
                .then((response) => {
                    const data = response.data.stores;
                    stores.value = data;
                    isActive.value = data.status === 1;
                    console.log(stores.value);
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        const updateStores = () => {
            stores.value.status = isActive.value ? 1 : 0;
            axios
                .put(`${baseUrl}/api/stores/${route.params.id}`, stores.value)
                .then(() => {
                    toast.success("Bạn đã cập nhật tài khoản thành công");
                    router.push({
                        name: "admin-stores"
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
        getStoresEdit();
        return {
            stores,
            isActive,
            errors,
            updateStores,
        };
    },
});
</script>
