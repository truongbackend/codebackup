<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Nhóm quyền theo vai trò <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Cập nhật nhóm quyền theo vai trò</h4>
<div class="nav-align-top mb-4">
    <ul class="nav nav-pills mb-3" role="tablist">
        <li class="nav-item">
            <button type="button" class="nav-link active" role="tab" data-bs-toggle="tab" data-bs-target="#navs-pills-top-home" aria-controls="navs-pills-top-home" aria-selected="true">
                Phân quyền chức năng
            </button>
        </li>
        <li class="nav-item">
            <button type="button" class="nav-link" role="tab" data-bs-toggle="tab" data-bs-target="#navs-pills-top-profile" aria-controls="navs-pills-top-profile" aria-selected="false">
                Phân quyền dữ liệu
            </button>
        </li>
    </ul>
    <div class="tab-content">
        <div class="tab-pane fade show active" id="navs-pills-top-home" role="tabpanel">
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
                <div class="row mt-3">
                    <label class="col-sm-2 col-form-label" for="basic-default-name">Công ty</label>
                    <div class="col-sm-10">
                        <MultiSelect v-model="selectedCompanny" :options="company" filter  optionLabel="name" placeholder="Chọn công ty" :maxSelectedLabels="5" class="w-full md:w-800rem" />
                        <small class="text-danger" v-if="errors.company_id">{{ errors.company_id[0] }}</small>
                    </div>
                </div>
                <div class="row ">
                    <label class="col-sm-2 col-form-label mt-2" for="basic-default-name">Trạng
                        thái</label>
                    <div class="col-sm-2 mt-3">
                        <input class="form-check-input" type="checkbox" v-model="isActive" id="flexSwitchCheckDefault">
                        <label class="form-check-label check-left text-success" for="flexSwitchCheckDefault"> Hoạt động
                        </label>
                    </div>
                </div>
                <hr class="m-0 mt-2 primary">
                <h5 class="card-header danhsach">Danh sách chức năng</h5>
                <hr class="m-0 primary">
                <div class="table-responsive">
                    <table class="table table-striped table-borderless border-bottom">
                        <thead>
                            <tr>
                                <th class="text-nowrap"></th>
                                <th class="text-nowrap text-center">Xem</th>
                                <th class="text-nowrap text-center">Thêm</th>
                                <th class="text-nowrap text-center">Sửa</th>
                                <th class="text-nowrap text-center">Xóa</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(permission, index) in permissions" :key="index">
                                <td class="text-nowrap">
                                    <input class="form-check-input" type="checkbox" :id="'permissionCheckbox' + index" v-model="permission.checked" @change="selectAllPermissions(permission)">
                                    <label class="form-check-label form-left" :for="'permissionCheckbox' + index">{{
                                            permission.label
                                        }}</label>
                                </td>
                                <td>
                                    <div class="form-check d-flex justify-content-center">
                                        <input class="form-check-input" type="checkbox" :id="'showCheckbox' + permission.module" v-model="permission.functions.show.checked" :disabled="permission.functions.show.disabled">
                                    </div>
                                </td>
                                <td>
                                    <div class="form-check d-flex justify-content-center">
                                        <input class="form-check-input" type="checkbox" :id="'createCheckbox' + permission.module" v-model="permission.functions.create.checked" :disabled="permission.functions.create.disabled">
                                    </div>
                                </td>
                                <td>
                                    <div class="form-check d-flex justify-content-center">
                                        <input class="form-check-input" type="checkbox" :id="'editCheckbox' + permission.module" v-model="permission.functions.edit.checked" :disabled="permission.functions.edit.disabled">
                                    </div>
                                </td>
                                <td>
                                    <div class="form-check d-flex justify-content-center">
                                        <input class="form-check-input" type="checkbox" :id="'deleteCheckbox' + permission.module" v-model="permission.functions.delete.checked" :disabled="permission.functions.delete.disabled">
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="modal-footer mt-3">
                    <button type="submit" class="btn btn-primary">Lưu</button>
                    <router-link :to="{ name: 'admin-roles' }" class="btn btn-danger">
                        Thoát
                    </router-link>
                </div>
            </form>
        </div>
        <div class="tab-pane fade" id="navs-pills-top-profile" role="tabpanel">
            <div class="table-responsive text-nowrap mb-4">
                <table class="table">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Tên nhân viên</th>
                            <th>Email</th>
                            <th>Khu vực</th>
                            <th>Số điện thoại</th>
                            <th>Trạng thái</th>
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
            </div>

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
        const users = ref([]);
        const stores = ref([]);
        const roleName = ref("");
        const roleNote = ref("");
        const errors = ref({});
        const company = ref([]);
        const selectedCompanny = ref([]);
        const isActive = ref(true);
        const currentRoleId = ref(0);
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const selectAllPermissions = (permission) => {
            if (permission.checked) {
                permission.functions.show.checked = true;
                permission.functions.create.checked = true;
                permission.functions.edit.checked = true;
                permission.functions.delete.checked = true;
            } else {
                permission.functions.show.checked = false;
                permission.functions.create.checked = false;
                permission.functions.edit.checked = false;
                permission.functions.delete.checked = false;
            }
        };

        const permissions = ref([{
                label: 'Đơn hàng',
                checked: false,
                module: 'order',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                }
            },
            {
                label: 'Khách hàng',
                checked: false,
                module: 'customer',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                }
            },
            {
                label: 'Công nợ',
                checked: false,
                module: 'debts',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                }
            },
            {
                label: 'Sản phẩm',
                checked: false,
                module: 'product',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                }
            },
            
            {
                label: 'Người dùng',
                checked: false,
                module: 'users',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                },
            },
            {
                label: 'Danh mục sản phẩm',
                checked: false,
                module: 'category',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                },
            },
            {
                label: 'Nhà kho',
                checked: false,
                module: 'stores',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                },
            },
            {
                label: 'Thiết lập',
                checked: false,
                module: 'setting',
                functions: {
                    show: {
                        checked: false,
                        disabled: true, 
                    },
                    create: {
                        checked: false,
                        disabled: true, 
                    },
                    edit: {
                        checked: false,
                        disabled: true, 
                    },
                    delete: {
                        checked: false,
                        disabled: true, 
                    }
                },
            },
            {
                label: 'Thống kê',
                checked: false,
                module: 'chart',
                functions: {
                    show: {
                        checked: false,
                        disabled: true, 
                    },
                    create: {
                        checked: false,
                        disabled: true, 
                    },
                    edit: {
                        checked: false,
                        disabled: true, 
                    },
                    delete: {
                        checked: false,
                        disabled: true, 
                    }
                },
            },
            {
                label: 'Thống kê quản lý',
                checked: false,
                module: 'analytic',
                functions: {
                    show: {
                        checked: false,
                        disabled: true, 
                    },
                    create: {
                        checked: false,
                        disabled: true, 
                    },
                    edit: {
                        checked: false,
                        disabled: true, 
                    },
                    delete: {
                        checked: false,
                        disabled: true, 
                    }
                },
            },
            {
                label: 'Báo cáo tổng quan thầu',
                checked: false,
                module: 'contractor',
                functions: {
                    show: {
                        checked: false,
                        disabled: true, 
                    },
                    create: {
                        checked: false,
                        disabled: true, 
                    },
                    edit: {
                        checked: false,
                        disabled: true, 
                    },
                    delete: {
                        checked: false,
                        disabled: true, 
                    }
                },
            },
            {
                label: 'Báo cáo theo dõi tham gia thầu',
                checked: false,
                module: 'biddingParticipate',
                functions: {
                    show: {
                        checked: false,
                        disabled: true, 
                    },
                    create: {
                        checked: false,
                        disabled: true, 
                    },
                    edit: {
                        checked: false,
                        disabled: true, 
                    },
                    delete: {
                        checked: false,
                        disabled: true, 
                    }
                }
            },
            {
                label: 'Báo cáo theo dõi tham gia bán hàng',
                checked: false,
                module: 'biddingContractorOrder',
                functions: {
                    show: {
                        checked: false,
                        disabled: true, 
                    },
                    create: {
                        checked: false,
                        disabled: true, 
                    },
                    edit: {
                        checked: false,
                        disabled: true, 
                    },
                    delete: {
                        checked: false,
                        disabled: true, 
                    }
                }
            },
            {
                label: 'Tổng quan marketing',
                checked: false,
                module: 'marketing',
                functions: {
                    show: {
                        checked: false,
                        disabled: true, 
                    },
                    create: {
                        checked: false,
                        disabled: true, 
                    },
                    edit: {
                        checked: false,
                        disabled: true, 
                    },
                    delete: {
                        checked: false,
                        disabled: true, 
                    }
                }
            },
            {
                label: 'Tổng quan bán hàng',
                checked: false,
                module: 'orderCustomer',
                functions: {
                    show: {
                        checked: false,
                        disabled: true, 
                    },
                    create: {
                        checked: false,
                        disabled: true, 
                    },
                    edit: {
                        checked: false,
                        disabled: true, 
                    },
                    delete: {
                        checked: false,
                        disabled: true, 
                    }
                }
            },
            {
                label: 'Tổng quan bán hàng chi nhánh và sản phẩm',
                checked: false,
                module: 'biddingOrder',
                functions: {
                    show: {
                        checked: false,
                        disabled: true, 
                    },
                    create: {
                        checked: false,
                        disabled: true, 
                    },
                    edit: {
                        checked: false,
                        disabled: true, 
                    },
                    delete: {
                        checked: false,
                        disabled: true, 
                    }
                }
            },
            {
                label: 'Công nợ phải thu',
                checked: false,
                module: 'biddingDebts',
                functions: {
                    show: {
                        checked: false,
                        disabled: true, 
                    },
                    create: {
                        checked: false,
                        disabled: true, 
                    },
                    edit: {
                        checked: false,
                        disabled: true, 
                    },
                    delete: {
                        checked: false,
                        disabled: true, 
                    }
                }
            },
            {
                label: 'Báo cáo tồn kho',
                checked: false,
                module: 'biddingInventory',
                functions: {
                    show: {
                        checked: false,
                        disabled: true, 
                    },
                    create: {
                        checked: false,
                        disabled: true, 
                    },
                    edit: {
                        checked: false,
                        disabled: true, 
                    },
                    delete: {
                        checked: false,
                        disabled: true, 
                    }
                }
            },
            {
                label: 'Báo cáo tồn kho HSD 12 tháng',
                checked: false,
                module: 'biddingInventoryDate',
                functions: {
                    show: {
                        checked: false,
                        disabled: true, 
                    },
                    create: {
                        checked: false,
                        disabled: true, 
                    },
                    edit: {
                        checked: false,
                        disabled: true, 
                    },
                    delete: {
                        checked: false,
                        disabled: true, 
                    }
                }
            },
            {
                label: 'Báo cáo hàng hủy',
                checked: false,
                module: 'inventoryDateDelete',
                functions: {
                    show: {
                        checked: false,
                        disabled: true, 
                    },
                    create: {
                        checked: false,
                        disabled: true, 
                    },
                    edit: {
                        checked: false,
                        disabled: true, 
                    },
                    delete: {
                        checked: false,
                        disabled: true, 
                    }
                }
            },
            {
                label: 'Báo cáo tổng hợp bán hàng , công nợ theo Asm',
                checked: false,
                module: 'salessummary',
                functions: {
                    show: {
                        checked: false,
                        disabled: true, 
                    },
                    create: {
                        checked: false,
                        disabled: true, 
                    },
                    edit: {
                        checked: false,
                        disabled: true, 
                    },
                    delete: {
                        checked: false,
                        disabled: true, 
                    },
                }
            },
        ]);

        const editRole = () => {
            axios.get(`${baseUrl}/api/roles/${route.params.id}`)
                .then(response => {
                    const roleData = response.data;
                    roleName.value = roleData.role.name;
                    roleNote.value = roleData.role.note;
                    isActive.value = roleData.role.status === 0;
                    company.value = roleData.company;
                    selectedCompanny.value = company.value.filter(company => roleData.role.company_id.includes(company.id));
                    const apiPermissions = roleData.role.permissions;
                    permissions.value.forEach(permission => {
                        const foundPermission = apiPermissions.find(apiPermission => apiPermission.name === permission.module);
                        if (foundPermission) {
                            permission.checked = true;
                            let functionsExist = false;

                            if (permission.functions.show) {
                                const showPermission = apiPermissions.find(apiPermission => apiPermission.name === `${permission.module}.show`);
                                if (showPermission) {
                                    permission.functions.show.checked = true;
                                    functionsExist = true;
                                }
                            }

                            if (permission.functions.create) {
                                const createPermission = apiPermissions.find(apiPermission => apiPermission.name === `${permission.module}.create`);
                                if (createPermission) {
                                    permission.functions.create.checked = true;
                                    functionsExist = true;
                                }
                            }

                            if (permission.functions.edit) {
                                const editPermission = apiPermissions.find(apiPermission => apiPermission.name === `${permission.module}.edit`);
                                if (editPermission) {
                                    permission.functions.edit.checked = true;
                                    functionsExist = true;
                                }
                            }

                            if (permission.functions.delete) {
                                const deletePermission = apiPermissions.find(apiPermission => apiPermission.name === `${permission.module}.delete`);
                                if (deletePermission) {
                                    permission.functions.delete.checked = true;
                                    functionsExist = true;
                                }
                            }
                            if (!functionsExist) {
                                permission.functions.show.checked = true;
                                permission.functions.create.checked = true;
                                permission.functions.edit.checked = true;
                                permission.functions.delete.checked = true;
                            }
                        }
                    });
                })
                .catch(error => {
                    console.error(error);
                });
        };
        const getUsers = () => {
            axios.get(`${baseUrl}/api/roles/${route.params.id}/data`)
                .then((response) => {
                    users.value = response.data.UserRoles;
                    stores.value = response.data.stores;
                })
                .catch((error) => {
                    console.error('Lỗi khi lấy danh sách người dùng:', error);
                });
        };
        
        const saveEditedRole = () => {
            const status = isActive.value ? 0 : 1;
            const selectedPermissions = [];
            permissions.value.forEach((permission) => {
                if (permission.checked) {
                    selectedPermissions.push(`${permission.module}`);
                    if (permission.functions.show.checked) {
                        selectedPermissions.push(`${permission.module}.show`);
                    }
                    if (permission.functions.create.checked) {
                        selectedPermissions.push(`${permission.module}.create`);
                    }
                    if (permission.functions.edit.checked) {
                        selectedPermissions.push(`${permission.module}.edit`);
                    }
                    if (permission.functions.delete.checked) {
                        selectedPermissions.push(`${permission.module}.delete`);
                    }
                }
            });
            const companyIds = selectedCompanny.value.map(company => company.id);
            axios
                .put(`${baseUrl}/api/roles/${route.params.id}`, {
                    name: roleName.value,
                    note: roleNote.value,
                    status: status,
                    permissions: selectedPermissions,
                    company_id:companyIds
                })
                .then(response => {
                    window.location.reload();
                    toast.success("Bạn đã chỉnh sửa nhóm thành công");
                })
                .catch(error => {
                    if (error.response && error.response.data && error.response.data.errors) {
                        errors.value = error.response.data.errors;
                    } else {
                        toast.error("Có lỗi xảy ra khi tạo kho");
                    }
                });
        };
        onMounted(() => {
            editRole();
            getUsers();
        });

        return {
            errors,
            users,
            stores,
            roleName,
            roleNote,
            isActive,
            roles,
            permissions,
            saveEditedRole,
            selectAllPermissions,
            company,
            selectedCompanny
        };
    },
});
</script>
