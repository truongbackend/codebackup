<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Danh sách khoá phần mềm <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách người dùng</h4>
<div class="card">
    <div class="card-header">
        <div class="row">
            <div class="col-md-12">
            <input class="form-control col-md-5" id="html5-search-input" v-model="searchKeyword" @input="searchUser" type="text" placeholder="Hãy nhập tên nhân viên hoặc số điện thoại...">
        </div>
        </div>

    </div>
    <div class="card-body">
        <div class="table-responsive text-nowrap">
            <table class="table mb-4 table-striped">
                <thead>
                    <tr class="text-nowrap alert-secondary">
                        <th>STT</th>
                        <th>Tên nhân viên</th>
                        <th>Email</th>
                        <th>Nhóm quyền</th>
                        <th>Khu vực</th>
                        <th>Số điện thoại</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(user, index) in users" :key="index">
                        <td>{{ index + 1 }}</td>
                        <td>{{ user.display_name }}</td>
                        <td>{{ user.email }}</td>
                        <td v-if="userRoles[user.id] && userRoles[user.id].length > 0" v-for="role in userRoles[user.id]" :key="role">{{ role }}</td>
                        <td v-else>Chưa phân quyền</td>
                        <td>{{ stores.find(x=>x.ID==user.store_id)?.store_name }}</td>
                        <td v-if="user.phone">{{ user.phone }}</td>
                        <td v-else>Không có</td>
                        <td class="text-center">
                            <a @click="showDeleteConfirmation(user.id)" data-bs-toggle="modal" data-bs-target="#basicModal" href="javascript:void(0);">
                                <i class="bx bx-lock-open-alt me-1 text-dark"></i>
                            </a>
                        </td>
                    </tr>
                </tbody>
            </table>
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-end">
                    <li class="page-item prev">
                        <a class="page-link" href="javascript:void(0);" @click="changePage('first')"><i class="tf-icon bx bx-chevrons-left"></i></a>
                    </li>
                    <li class="page-item prev">
                        <a class="page-link" href="javascript:void(0);" @click="changePage(currentPage - 1)">
                            <i class="tf-icon bx bx-chevron-left"></i>
                        </a>
                    </li>
                    <li v-for="page in displayedPages" :key="page" class="page-item" :class="{ active: page === currentPage }">
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
    <div class="col-lg-4 col-md-6">
        <div class="mt-3">
            <div class="modal fade" id="basicModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel1">Thông báo</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body toast-modal">
                            <div class="col mb-3">
                                <p>Bạn có chắc muốn xóa người này khỏi danh sách khoá phần mềm không ?</p>
                            </div>
                        </div>
                        <div class="modal-footer toast-modal">
                            <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">
                                Đóng
                            </button>
                            <button type="button" class="btn btn-primary" data-bs-dismiss="modal" @click="confirmDelete">Đồng ý</button>
                        </div>
                    </div>
                </div>
            </div>
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
export default defineComponent({
    setup() {
        const toast = useToast();
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const users = ref([]);
        const stores = ref([]);
        const userRoles = ref([]);
        const searchKeyword = ref('');
        const currentPage = ref(1);
        const itemsPerPage = 10;
        let totalPages = ref(0);
        const deletingUserId = ref(null);
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
            axios.get(`${baseUrl}/api/softwarelock`, {
                    params: {
                        keyword: searchKeyword.value,
                        page: currentPage.value,
                        per_page: itemsPerPage,
                    },
                })
                .then((response) => {
                    stores.value = response.data.stores.data;
                    userRoles.value = response.data.roles;
                    users.value = response.data.users.data;
                    totalPages.value = response.data.users.last_page;
                })
                .catch((error) => {
                    console.error('Lỗi khi lấy danh sách người dùng:', error);
                });
        };
        const showDeleteConfirmation = (userId) => {
            deletingUserId.value = userId;
        };
        const confirmDelete = () => {
            if (deletingUserId.value) {
                deleteUsers(deletingUserId.value);
                deletingUserId.value = null;
            }
        };
        const deleteUsers = (userId) => {
            axios
                .put(`${baseUrl}/api/softwarelock/${userId}`)
                .then((response) => {
                    getUsers()
                    toast.success('Xoá người dùng khỏi danh sách khoá phần mềm thành công');
                })
                .catch((error) => {
                    if (error.response && error.response.status === 401) {
                        toast.error('Không thể xóa người dùng có vai trò là Admin');
                    } else {
                        console.log(error);
                        toast.error('Xoá người dùng thất bại');
                    }
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
            deleteUsers,
            userRoles,
            showDeleteConfirmation,
            confirmDelete
        };
    },
});
</script>
