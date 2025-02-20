<template>
<h4 class="fw-bold py-3 mb-4">
    <span class="text-muted fw-light">Sản phẩm <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Chi tiết sản phẩm
</h4>
<div class="col-xl">
    <div class="card mb-4">
        <div class="card-body">
            <form>
                <div class="mb-3">
                    <label class="form-label" for="basic-default-fullname">Tên sản phẩm</label>
                    <input type="text" class="form-control" v-model="products.prd_name" id="basic-default-fullname" placeholder="John Doe" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="basic-default-fullname">Hoạt chất</label>
                    <input type="text" class="form-control" v-model="products.prd_active" id="basic-default-fullname" placeholder="John Doe" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="basic-default-fullname">Nồng độ/ hàm lượng</label>
                    <input type="text" class="form-control" v-model="products.prd_content" id="basic-default-fullname" placeholder="John Doe" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="basic-default-fullname">Quy cách đóng gói</label>
                    <input type="text" class="form-control" v-model="products.prd_pack" id="basic-default-fullname" placeholder="John Doe" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="basic-default-fullname">Danh mục</label>
                    <input type="text" class="form-control" v-model="products.prd_name" id="basic-default-fullname" placeholder="John Doe" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="basic-default-fullname">Giá bán</label>
                    <input type="text" class="form-control" v-model="products.prd_sell_price" id="basic-default-fullname" placeholder="John Doe" readonly>
                </div>
                <div class="mb-3">
                    <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Danh mục</label>
                    <div class="col-sm-12">
                        <select v-model="products.prd_group_id" disabled class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                            <option v-for="category in category" :value="category.ID" :key="category.value" >{{ category.prd_group_name }}</option>
                        </select>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Nhà sản xuất</label>
                    <div class="col-sm-12">
                        <select v-model="products.prd_manufacture_id" disabled class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                            <option v-for="producer in producer" :value="producer.ID" :key="producer.ID" disabled>{{ producer.prd_manuf_name }}</option>
                        </select>
                    </div>
                </div>
                <div class="row justify-content-end">
                        <div class="col-sm-12">
                            <router-link :to="{ name: 'admin-products' }" class="btn btn-danger">Trở về</router-link>
                        </div>
                    </div>
            </form>
        </div>
    </div>
</div>
</template>

<script>
import axios from 'axios';
import {
    defineComponent,
    ref,
    watch
} from 'vue';
import {
    inject
} from 'vue';
import {
    useRouter,
    useRoute
} from "vue-router";
export default defineComponent({
    setup() {
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const products = ref([]);
        const router = useRouter();
        const route = useRoute();
        const producer = ref([]);
        const product_unit = ref([]);
        const category = ref([]);
        const getProducts = () => {
            axios
                .get(`${baseUrl}/api/products/${route.params.products}`)
                .then((response) => {
                    const data = response.data.products;
                    products.value = data;
                    producer.value = response.data.producer.data;
                    product_unit.value = response.data.product_unit.data;
                    category.value = response.data.category.data;
                    console.log(product_unit.value);
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        getProducts();
        return {
            products,
            product_unit,
            producer,
            route,
            category,
        };
    },
});
</script>
