<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Vùng miền <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span>Khu vực</h4>
<div class="row">
    <div class="col-xxl">
        <div class="card mb-4">
            <div class="card-body">
                <form @submit.prevent="createStore">
                    <div class="row mb-3">
                        <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Vùng miền</label>
                        <div class="col-sm-10">
                            <select v-model="stores.store_manager" class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                                <option value>Chọn vùng miền</option>
                                <option v-for="store_managers in store_manager" :value="store_managers.id">{{ store_managers.name }}</option>
                            </select>
                            <small class="text-danger text-start-center" v-if="errors.store_id">{{ errors.store_id[0] }}</small>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-sm-2 col-form-label" for="store_name">Khu vực</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="stores.store_name" id="store_name" placeholder="Nhập tên kho bạn muốn thêm..." />
                            <small class="text-danger" v-if="errors.store_name">{{ errors.store_name[0] }}</small>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-sm-2 col-form-label mt-2" for="basic-default-name">Hoạt động</label>
                        <div class="col-sm-2 mt-3">
                            <input class="form-check-input" type="checkbox" v-model="stores.status" id="flexSwitchCheckDefault">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Lưu</button>
                        <router-link :to="{ name: 'admin-stores' }" type="button" class="btn btn-danger">
                            Hủy
                        </router-link>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</template>

<script>
import { defineComponent, ref } from "vue";
import { useToast } from "vue-toast-notification";
import { useRouter } from "vue-router";
import axios from "axios";
import { inject } from 'vue';

export default defineComponent({
    setup() {
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const toast = useToast();
        const router = useRouter();
        const store_manager = ref([]);
        const errors = ref({});
        const stores = ref({
            store_name: "",
            user_init: 1,
            store_manager: "",
            status: true,
        });

        const createStore = () => {
            axios
                .post(`${baseUrl}/api/stores`, {
                    store_name: stores.value.store_name,
                    user_init: stores.value.user_init,
                    store_manager: stores.value.store_manager,
                    status: stores.value.status,
                })
                .then((response) => {
                    toast.success("Bạn đã tạo kho thành công");
                    router.push({
                        name: "admin-stores"
                    });
                })
                .catch((error) => {
                    if (error.response && error.response.data && error.response.data.errors) {
                        errors.value = error.response.data.errors;
                    } else {
                        toast.error("Có lỗi xảy ra khi tạo kho");
                    }
                });
        };

        const getStores = () => {
            axios
                .get(`${baseUrl}/api/stores`)
                .then((response) => {
                    store_manager.value = response.data.store_manager.data;
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        getStores();
        return {
            stores,
            createStore,
            errors,
            store_manager
        };
    },
});
</script>
