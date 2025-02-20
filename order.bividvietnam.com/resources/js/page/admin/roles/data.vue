<template>
    <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Người dùng<i class="bx bx-chevron-right"
                style="font-size: 40px;"></i></span> Danh sách người dùng theo nhóm quyền</h4>
    <div class="card">
        <div class="card-header d-flex align-items-center justify-content-between">
            <div class="col-md-10">
                <input class="form-control col-md-5" id="html5-search-input" v-model="searchKeyword" @input="searchUser"
                    type="text" placeholder="Hãy nhập tên nhân viên hoặc số điện thoại...">
            </div>
            <router-link :to="{ name: 'admin-users-create' }">
                <button type="button" class="btn btn-primary float-end"> <i class='bx bx-plus'></i>Thêm người dùng</button>
            </router-link>
        </div>
        <div class="card-body">
            <div class="table-responsive text-nowrap">
                <table class="table table-bordered mb-4">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Tên nhân viên</th>
                            <th>Email</th>
                            <th>Khu vực</th>
                            <th>Số điện thoại</th>
                            <th>Trạng thái</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(user, index) in users" :key="index">
                            <td>{{ index + 1 }}</td>
                            <td>{{ user.display_name }}</td>
                            <td>{{ user.email }}</td>
                            <td>{{ stores.find(x => x.ID == user.store_id)?.store_name }}</td>
                            <td v-if="user.phone">{{ user.phone }}</td>
                            <td v-else>Không có</td>
                            <td v-if="user.user_status === 1">
                                <span class="badge rounded-pill bg-success"> Hoạt động </span>
                            </td>
                            <td v-else>
                                <span class="badge rounded-pill bg-danger"> Ngừng động </span>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-end">
                        <li class="page-item prev">
                            <a class="page-link" href="javascript:void(0);" @click="changePage('first')"><i
                                    class="tf-icon bx bx-chevrons-left"></i></a>
                        </li>
                        <li class="page-item prev">
                            <a class="page-link" href="javascript:void(0);" @click="changePage(currentPage - 1)">
                                <i class="tf-icon bx bx-chevron-left"></i>
                            </a>
                        </li>
                        <li v-for="page in displayedPages" :key="page" class="page-item"
                            :class="{ active: page === currentPage }">
                            <a class="page-link" href="javascript:void(0);" @click="changePage(page)">{{ page }}</a>
                        </li>
                        <li class="page-item next">
                            <a class="page-link" href="javascript:void(0);" @click="changePage(currentPage + 1)">
                                <i class="tf-icon bx bx-chevron-right"></i>
                            </a>
                        </li>
                        <li class="page-item next">
                            <a class="page-link" href="javascript:void(0);">
                                <i class="tf-icon bx bx-chevrons-right" @click="changePage('last')"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</template>

<script>
import { inject, defineComponent, ref, onMounted, watch, computed } from 'vue';
import axios from 'axios';
import {
    useToast
} from 'vue-toast-notification';
import {
    useRouter,
    useRoute
} from "vue-router";
export default defineComponent({
    setup() {
        const route = useRoute();
        const router = useRouter();
        const toast = useToast();
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const users = ref([]);
        const stores = ref([]);
        const userRoles = ref([]);
        const UserRoles = ref([]);
        const searchKeyword = ref('');
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
        const getUsers = () => {
            axios.get(`${baseUrl}/api/roles/${route.params.id}/data`, {
                params: {
                    keyword: searchKeyword.value,
                    page: currentPage.value,
                    per_page: itemsPerPage,
                },
            })
                .then((response) => {
                    users.value = response.data.UserRoles;
                    console.log(users.value);
                    stores.value = response.data.stores;
                    totalPages.value = response.data.users.last_page;
                })
                .catch((error) => {
                    console.error('Lỗi khi lấy danh sách người dùng:', error);
                });
        };
        const changePage = (page) => {
            if (page === 'first') {
                currentPage.value = 1;
            } else if (page === 'last') {
                currentPage.value = totalPages.value;
            } else if (page >= 1 && page <= totalPages.value) {
                currentPage.value = page;
            }
            getUsers();
        };
        watch(searchKeyword, () => {
            currentPage.value = 1;
            getUsers();
        });

        onMounted(() => {
            getUsers();
        });

        return {
            displayedPages,
            changePage,
            users,
            searchKeyword,
            currentPage,
            totalPages,
            stores,
            userRoles,
            UserRoles,
        };
    },
});
</script>
