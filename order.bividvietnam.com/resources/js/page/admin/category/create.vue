<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Danh mục <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Thêm danh mục </h4>
<div class="row">
    <div class="col-xxl">
        <div class="card mb-4">
            <div class="card-body">
                <form @submit.prevent="createCategory">
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="prd_group_name">Danh mục</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="category.prd_group_name" id="prd_group_name" placeholder="Nhập thêm danh mục vào..." />
                            <small class="text-danger text-start-center" v-if="errors.prd_group_name">{{ errors.prd_group_name[0] }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Danh mục cha</label>
                        <div class="col-sm-10">
                            <select v-model="category.level" class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                                <option value="0" selected="">--Danh mục --</option>
                                <option v-for="categories in categories" :value="categories.ID" :key="categories.ID">{{
                                        categories.prd_group_name }}</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer mt-3"><button type="submit" class="btn btn-primary">Lưu</button>
                        <router-link :to="{ name: 'admin-category' }" class="btn btn-danger me-sm-2">
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
} from 'vue';
export default defineComponent({
    setup() {
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const toast = useToast();
        const router = useRouter();
        const errors = ref({});
        const category = ref({
            prd_group_name: "",
            parentid: "",
            user_init: 1,
        });
        const categories = ref([]);
        const getCategoryCreat = () => {
            axios
                .get(`${baseUrl}/api/category/create`)
                .then((response) => {
                    categories.value = response.data.categories.data
                })
                .catch((error) => {
                    errors.value = error.response.data.errors;
                });
        }
        const createCategory = () => {
            axios
                .post(`${baseUrl}/api/category`, category.value)
                .then((response) => {
                    toast.success("Bạn đã tạo kho thành công");
                    router.push({
                        name: "admin-category"
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

        getCategoryCreat();
        return {
            category,
            createCategory,
            errors,
            categories,
        };
    },
});
</script>
