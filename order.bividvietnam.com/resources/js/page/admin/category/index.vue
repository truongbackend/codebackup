<template>
<div class="row">
    <div class="col-md-6">
        <h4 class="fw-bold py-3"><span class="text-muted fw-light">Danh mục <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách nhóm sản phẩm</h4>
    </div>
    <div class="col-md-6">
        <router-link :to="{ name: 'admin-category-create' }" v-if="hasPermission('category.create')">
            <button type="button" class="btn btn-primary float-end mt-3"><i class="bx bx-plus"></i>Thêm danh mục</button>
        </router-link>
    </div>
</div>
<div class="card">
    <div class="card-body">
        <div class="table-responsive text-nowrap mb-4">
            <table class="table table-striped">
                <thead>
                    <tr class="text-nowrap alert-secondary">
                        <th>#</th>
                        <th>Danh mục</th>
                        <th>Ngày tạo</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(category,index) in category" :key="index">
                        <td>{{ index + 1 }}</td>
                        <td>{{ category.prd_group_name }}</td>
                        <td>{{ category.created}}</td>
                        <td class="text-center">
                            <router-link :to="{ name: 'admin-category-update', params: { id: category.ID } }" v-if="hasPermission('category.edit')">
                                <i class="bx bxs-edit text-dark"></i>
                            </router-link>
                            <a @click="confirmDeleteCategory(category)" href="javascript:void(0);" v-if="hasPermission('category.delete')">
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
    ref,computed,onMounted
} from 'vue';
import {
    useToast
} from 'vue-toast-notification';
import {
    inject
} from 'vue';
import {
        fetchUserPermission
    } from '@/utils/permission.js';
export default defineComponent({
    setup() {
        const userPermission = ref([]);
        const toast = useToast();
        const category = ref([]);
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const currentPage = ref(1);
        const itemsPerPage = 10;
        let totalPages = ref(0);
        const maxDisplayedPages = 10;
        const maxDisplayedLeft = Math.floor(maxDisplayedPages / 2);
        const maxDisplayedRight = Math.ceil(maxDisplayedPages / 2);
        const displayedPages = computed(() => {
            let startPage = Math.max(currentPage.value - maxDisplayedLeft, 1);
            let endPage = Math.min(currentPage.value + maxDisplayedRight, totalPages.value);
            if (endPage - startPage + 1 < maxDisplayedPages) {
                if (currentPage.value <= maxDisplayedLeft) {
                    endPage = Math.min(endPage + maxDisplayedPages - (endPage - startPage + 1), totalPages.value);
                } else {
                    startPage = Math.max(startPage - (maxDisplayedPages - (endPage - startPage + 1)), 1);
                }
            }
            return Array.from({
                length: endPage - startPage + 1
            }, (_, i) => startPage + i);
        });
        const getCategory = () => {
      axios
        .get(`${baseUrl}/api/category`, {
          params: {
            page: currentPage.value,
            per_page: itemsPerPage,
          },
        })
        .then((response) => {
          totalPages.value = response.data.category.last_page;
          category.value = response.data.category;
        })
        .catch((error) => {
          console.error('Error fetching categories:', error);
          toast.error('Failed to fetch categories');
        });
    };
        const deleteCategory = (CategoryId) => {
            axios
                .delete(`${baseUrl}/api/category/${CategoryId}`)
                .then(() => {
                    toast.success('Xoá khách hàng thành công');
                    category.value = category.value.filter((category) => category.ID !== CategoryId);
                })
                .catch((error) => {
                    console.log(error);
                    toast.error('Xóa khách hàng thất bại');
                });
        };
        const changePage = (page) => {
            if (page >= 1 && page <= totalPages.value) {
                currentPage.value = page;
                getCategory();
            }
        };
        const confirmDeleteCategory = (category) => {
            if (window.confirm('Bạn có chắc chắn muốn xoá khách hàng này?')) {
                deleteCategory(category.ID);
            }
        };
        onMounted(async () => {
                try {
                    userPermission.value = await fetchUserPermission();
                } catch (error) {
                    console.error('Error fetching user roles:', error);
                }
            });
            function hasPermission(args) {
                return Object.values(userPermission.value).includes(args);
            }
        getCategory();
        return {
            changePage,
            category,
            confirmDeleteCategory,
            currentPage,
            totalPages,
            displayedPages,
            hasPermission,
            userPermission,
        };
    },
});
</script>
