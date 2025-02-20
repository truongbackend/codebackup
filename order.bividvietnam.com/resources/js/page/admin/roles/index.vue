<template>
<div class="row">
    <div class="col-md-6">
        <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Nhóm quyền theo vai trò <i class='bx bx-chevron-right' style="font-size: 40px;"></i></span> Danh sách nhóm quyền theo vai trò</h4>
    </div>
    <div class="col-md-6">
        <router-link :to="{ name: 'admin-roles-create' }">
            <button type="button" class="btn btn-primary float-end mt-2"> <i class='bx bx-plus'></i>Thêm nhóm quyền</button>
        </router-link>
    </div>
</div>

<div class="card">
    <div class="card-body">
        <div class="table-responsive text-nowrap">
            <table class="table table-striped">
                <thead>
                    <tr class="text-nowrap alert-secondary">
                        <th>STT</th>
                        <th>Nhóm quyền</th>
                        <th>Mô tả</th>
                        <th class="text-center">Trạng thái</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(role, index) in roles" :key="role.id">
                        <td>{{ index + 1 }}</td>
                        <td>{{ role.name }}</td>
                        <td>{{ role.note }}</td>
                        <td v-if="role.status == 0" class="text-center"><span class="badge bg-label-success me-1">Hoạt động</span></td>
                        <td v-else class="text-center"><span class="badge bg-label-danger me-1">Ngừng hoạt động</span></td>
                        <td class="text-center">
                            <router-link :to="{ name: 'admin-roles-edit', params: { id: role.id } }">
                                <i class="bx bxs-edit text-dark"></i>
                            </router-link>
                            
                        </td>
                    </tr>
                    <div class="modal fade" id="editRole" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg" role="document">
                            <div class="modal-content">
                                <div class="modal-body">
                                    <form @submit.prevent="saveEditedRole()">
                                        <div class="row">
                                            <label class="col-sm-2 col-form-label" for="basic-default-name">Nhóm quyền</label>
                                            <div class="col-sm-10">
                                                <input type="text" class="form-control" id="basic-default-name" v-model="roleName" placeholder="Hãy nhập quyền vào">
                                            </div>
                                        </div>
                                        <div class="row mt-3">
                                            <label class="col-sm-2 col-form-label" for="basic-default-name">Mô tả</label>
                                            <div class="col-sm-10">
                                                <input type="text" class="form-control" v-model="roleNote" placeholder="Mô tả quyền đó">
                                            </div>
                                        </div>
                                        <div class="row ">
                                            <label class="col-sm-2 col-form-label mt-2" for="basic-default-name">Trạng thái</label>
                                            <div class="col-sm-2 mt-3">
                                                <input class="form-check-input" type="checkbox" v-model="isActive" id="flexSwitchCheckDefault">
                                                <label class="form-check-label check-left text-success" for="flexSwitchCheckDefault"> Hoạt động </label>
                                            </div>
                                        </div>
                                        <hr class="m-0 mt-2 primary">
                                        <h5 class="card-header danhsach">Danh sách chức năng</h5>
                                        <hr class="m-0 primary">
                                        <div v-for="(permission, index) in permissions" :key="index">
                                            <div class="row">
                                                <div class="col-sm-3 roles-left mt-3">
                                                    <input class="form-check-input" type="checkbox" :id="'permissionCheckbox' + index" v-model="permission.checked">
                                                    <label class="form-check-label form-left" :for="'permissionCheckbox' + index">{{ permission.label }}</label>
                                                </div>
                                            </div>
                                        </div>
                                        <hr class="m-0 mt-2">
                                        <div class="modal-footer mt-3">
                                            <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Thoát</button>
                                            <button type="submit" class="btn btn-primary">Lưu</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </tbody>
            </table>
        </div>
    </div>
</div>
</template>

<script>
import axios from "axios";
import {
    useToast
} from "vue-toast-notification";
import {
    defineComponent,
    ref,
    onMounted,
    inject
} from "vue";
import {
    useRouter,
    useRoute
} from "vue-router";
export default defineComponent({
    setup() {
        const router = useRouter();
        const route = useRoute();
        const toast = useToast();
        const roles = ref([]);
        const roleName = ref("");
        const roleNote = ref("");
        const isActive = ref(true);
        const currentRoleId = ref(0);
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const permissions = ref([{
                label: 'Công nợ',
                checked: false,
                name: 'debts'
            },
            {
                label: 'Đơn hàng',
                checked: false,
                name: 'order'
            },
            {
                label: 'Sản phẩm',
                checked: false,
                name: 'product'
            },
            {
                label: 'Khách hàng',
                checked: false,
                name: 'customer'
            },
            {
                label: 'Đặt hàng',
                checked: false,
                name: 'order'
            },
        ]);
        const createRole = () => {
            const selectedPermissions = permissions.value.filter(permission => permission.checked).map(permission => permission.name);
            const status = isActive.value ? 0 : 1;
            axios.post(`${baseUrl}/api/roles`, {
                    name: roleName.value,
                    note: roleNote.value,
                    description: roleNote.value,
                    status: status,
                    permissions: selectedPermissions,
                })
                .then(response => {
                    roles.value.push(response.data);
                    roleName.value = '';
                    roleNote.value = '';
                    isActive.value = true;
                    toast.success("Bạn đã tạo nhóm thành công");
                })
                .catch(error => {
                    console.error(error);
                });
        };
        const editRole = (roleId) => {
            currentRoleId.value = roleId;
            const status = isActive.value ? 0 : 1;
            axios.get(`${baseUrl}/api/roles/${roleId}`)
                .then(response => {
                    const roleData = response.data;
                    roleName.value = roleData.name;
                    roleNote.value = roleData.note;
                    const status = roleData.status;
                    isActive.value = status === 0 ? true : false;
                    permissions.value.forEach(permission => {
                        permission.checked = roleData.permissions.some(rolePermission => rolePermission.name === permission.name);
                    });
                })
                .catch(error => {
                    console.error(error);
                });
        };

        const saveEditedRole = () => {
            const roleId = currentRoleId.value;
            const status = isActive.value ? 0 : 1;
            const selectedPermissions = permissions.value
                .filter(permission => permission.checked)
                .map(permission => permission.name);
            axios
                .put(`${baseUrl}/api/roles/${roleId}`, {
                    name: roleName.value,
                    note: roleNote.value,
                    status: status,
                    permissions: selectedPermissions,
                })
                .then(response => {
                    toast.success("Bạn đã chỉnh sửa nhóm thành công");
                })
                .catch(error => {
                    console.error(error);
                });
        };
        onMounted(() => {
            axios.get(`${baseUrl}/api/roles`)
                .then(response => {
                    roles.value = response.data;
                })
                .catch(error => {
                    console.error(error);
                });
        });

        return {
            roleName,
            roleNote,
            isActive,
            createRole,
            roles,
            permissions,
            editRole,
            saveEditedRole,
        };
    },
});
</script>
