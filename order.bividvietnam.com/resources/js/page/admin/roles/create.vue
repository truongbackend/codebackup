<template>
<h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Nhóm quyền theo vai trò <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Thêm mới nhóm quyền theo vai trò</h4>
<div class="card">
    <div class="card-body">
        <form @submit.prevent="createRole">
            <div class="row">
                <label class="col-sm-2 col-form-label" for="basic-default-name">Nhóm quyền</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="basic-default-name" v-model="roleName" placeholder="Hãy nhập quyền vào">
                    <small class="text-danger" v-if="errors.name">{{ errors.name[0] }}</small>
                </div>
            </div>
            <div class="row mt-3">
                <label class="col-sm-2 col-form-label" for="basic-default-name">Mô tả</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" v-model="roleNote" placeholder="Mô tả quyền đó">
                </div>
            </div>
            <div class="row mt-3">
                <label class="col-sm-2 col-form-label" for="basic-default-name">Chọn công ty</label>
                <div class="col-sm-10">
                    <MultiSelect v-model="selectedCompanny" variant="filled" :options="company" filter optionLabel="name" placeholder="Chọn công ty" :maxSelectedLabels="3" class="w-full md:w-20rem" />
                    <small class="text-danger" v-if="errors.company_id">{{ errors.company_id[0] }}</small>
                </div>
            </div>
            <div class="row ">
                <label class="col-sm-2 col-form-label mt-2" for="basic-default-name">Trạng thái</label>
                <div class="col-sm-2 mt-3">
                    <input class="form-check-input" type="checkbox" v-model="isActive" id="flexSwitchCheckDefault">
                </div>
            </div>
            <hr class="m-0 mt-2 primary">
            <h5 class="card-header danhsach">Danh sách chức năng</h5>
            <hr class="m-0 primary">
            <div>
                <div class="row">
                    <div class="col-sm-3 roles-left mt-3">
                        <input class="form-check-input" type="checkbox" v-model="selectAllPermissions">
                        <label class="form-check-label form-left fw-bold ">Chọn tất cả</label>
                    </div>
                </div>
            </div>
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
                <button type="submit" class="btn btn-primary">Lưu</button>
                <router-link :to="{ name:'admin-roles' }" class="btn btn-danger">
                    Thoát
                </router-link>

            </div>
        </form>
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
    inject,computed
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
        const errors = ref({});
        const company = ref ([]);
        const roleNote = ref("");
        const selectedCompanny = ref();
        const isActive = ref(true);
        const currentRoleId = ref(0);
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        // const permissions = ref([{
        //         label: 'Công nợ',
        //         checked: false,
        //         name: 'debts'
        //     },
        //     {
        //         label: 'Đơn hàng',
        //         checked: false,
        //         name: 'order'
        //     },
        //     {
        //         label: 'Sản phẩm',
        //         checked: false,
        //         name: 'product'
        //     },
        //     {
        //         label: 'Khách hàng',
        //         checked: false,
        //         name: 'customer'
        //     },
        //     {
        //         label: 'Thiết lập',
        //         checked: false,
        //         name: 'setting'
        //     },
        //     {
        //         label: 'Người dùng',
        //         checked: false,
        //         name: 'users'
        //     },
        //     {
        //         label: 'Danh mục sản phẩm',
        //         checked: false,
        //         name: 'category'
        //     },
        //     {
        //         label: 'Khu vực',
        //         checked: false,
        //         name: 'stores'
        //     },
        //      {
        //         label: 'Báo cáo tổng quan thầu',
        //         checked: false,
        //         name: 'contractor'
        //     },
        //      {
        //         label: 'Báo cáo theo dõi tham gia thầu',
        //         checked: false,
        //         name: 'biddingParticipate'
        //     },
        //      {
        //         label: 'Báo cáo theo dõi tham gia bán hàng',
        //         checked: false,
        //         name: 'biddingContractorOrder'
        //     },
        //     {
        //         label: 'Tổng quan marketing',
        //         checked: false,
        //         name: 'marketing'
        //     },
        //     {
        //         label: 'Tổng quan bán hàng',
        //         checked: false,
        //         name: 'orderCustomer'
        //     },
        //     {
        //         label: 'Tổng quan bán hàng chi nhánh và sản phẩm',
        //         checked: false,
        //         name: 'biddingOrder'
        //     },
        //     {
        //         label: 'Công nợ phải thu',
        //         checked: false,
        //         name: 'biddingDebts'
        //     },
        //     {
        //         label: 'Báo cáo tồn kho',
        //         checked: false,
        //         name: 'biddingInventory'
        //     },
        //     {
        //         label: 'Báo cáo tồn kho HSD 12 tháng',
        //         checked: false,
        //         name: 'biddingInventoryDate'
        //     },
        //     {
        //         label: 'Báo cáo hàng hủy',
        //         checked: false,
        //         name: 'inventoryDateDelete'
        //     },
        //      {
        //         label: 'Báo cáo tổng hợp bán hàng , công nợ theo Asm',
        //         checked: false,
        //         name: 'salessummary'
        //     }
        // ]);
        const permissions = ref([{
                label: 'Đơn hàng',
                checked: false,
                module: 'order',
                functions: {
                    show: {
                        checked: true
                    },
                    create: {
                        checked: true
                    },
                    edit: {
                        checked: true
                    },
                    delete: {
                        checked: true
                    }
                }
            },
            {
                label: 'Khách hàng',
                checked: false,
                module: 'customer',
                functions: {
                    show: {
                        checked: true
                    },
                    create: {
                        checked: true
                    },
                    edit: {
                        checked: true
                    },
                    delete: {
                        checked: true
                    }
                }
            },
            {
                label: 'Công nợ',
                checked: false,
                module: 'debts',
                functions: {
                    show: {
                        checked: true
                    },
                    create: {
                        checked: true
                    },
                    edit: {
                        checked: true
                    },
                    delete: {
                        checked: true
                    }
                }
            },
            {
                label: 'Sản phẩm',
                checked: false,
                module: 'product',
                functions: {
                    show: {
                        checked: true
                    },
                    create: {
                        checked: true
                    },
                    edit: {
                        checked: true
                    },
                    delete: {
                        checked: true
                    }
                }
            },
            
            {
                label: 'Người dùng',
                checked: false,
                module: 'users',
                functions: {
                    show: {
                        checked: true
                    },
                    create: {
                        checked: true
                    },
                    edit: {
                        checked: true
                    },
                    delete: {
                        checked: true
                    }
                },
            },
            {
                label: 'Danh mục sản phẩm',
                checked: false,
                module: 'category',
                functions: {
                    show: {
                        checked: true
                    },
                    create: {
                        checked: true
                    },
                    edit: {
                        checked: true
                    },
                    delete: {
                        checked: true
                    }
                },
            },
            {
                label: 'Nhà kho',
                checked: false,
                module: 'stores',
                functions: {
                    show: {
                        checked: true
                    },
                    create: {
                        checked: true
                    },
                    edit: {
                        checked: true
                    },
                    delete: {
                        checked: true
                    }
                },
            },
            {
                label: 'Thiết lập',
                checked: false,
                module: 'setting',
                functions: {
                    show: {
                        checked: true,
                    },
                    create: {
                        checked: false,
                    },
                    edit: {
                        checked: true,
                    },
                    delete: {
                        checked: true,
                    }
                },
            },
            {
                label: 'Thống kê',
                checked: false,
                module: 'chart',
                functions: {
                    show: {
                        checked: true,
                    },
                    create: {
                        checked: true,
                    },
                    edit: {
                        checked: true,
                    },
                    delete: {
                        checked: true,
                    }
                },
            },
            {
                label: 'Thống kê quản lý',
                checked: false,
                module: 'analytic',
                functions: {
                    show: {
                        checked: true,
                    },
                    create: {
                        checked: true,
                    },
                    edit: {
                        checked: true,
                    },
                    delete: {
                        checked: true,
                    }
                },
            },
            {
                label: 'Báo cáo tổng quan thầu',
                checked: false,
                module: 'contractor',
                functions: {
                    show: {
                        checked: true,
                    },
                    create: {
                        checked: true,
                    },
                    edit: {
                        checked: true,
                    },
                    delete: {
                        checked: true,
                    }
                },
            },
            {
                label: 'Báo cáo theo dõi tham gia thầu',
                checked: false,
                module: 'biddingParticipate',
                functions: {
                    show: {
                        checked: true,
                    },
                    create: {
                        checked: true,
                    },
                    edit: {
                        checked: true,
                    },
                    delete: {
                        checked: true,
                    }
                }
            },
            {
                label: 'Báo cáo theo dõi tham gia bán hàng',
                checked: false,
                module: 'biddingContractorOrder',
                functions: {
                    show: {
                        checked: true,
                    },
                    create: {
                        checked: true,
                    },
                    edit: {
                        checked: true,
                    },
                    delete: {
                        checked: true,
                    }
                }
            },
            {
                label: 'Tổng quan marketing',
                checked: false,
                module: 'marketing',
                functions: {
                    show: {
                        checked: true,
                    },
                    create: {
                        checked: true,
                    },
                    edit: {
                        checked: true,
                    },
                    delete: {
                        checked: true,
                    }
                }
            },
            {
                label: 'Tổng quan bán hàng',
                checked: false,
                module: 'orderCustomer',
                functions: {
                    show: {
                        checked: true,
                    },
                    create: {
                        checked: true,
                    },
                    edit: {
                        checked: true,
                    },
                    delete: {
                        checked: true,
                    }
                }
            },
            {
                label: 'Tổng quan bán hàng chi nhánh và sản phẩm',
                checked: false,
                module: 'biddingOrder',
                functions: {
                    show: {
                        checked: true,
                    },
                    create: {
                        checked: true,
                    },
                    edit: {
                        checked: true,
                    },
                    delete: {
                        checked: true,
                    }
                }
            },
            {
                label: 'Công nợ phải thu',
                checked: false,
                module: 'biddingDebts',
                functions: {
                    show: {
                        checked: true,
                    },
                    create: {
                        checked: true,
                    },
                    edit: {
                        checked: true,
                    },
                    delete: {
                        checked: true,
                    }
                }
            },
            {
                label: 'Báo cáo tồn kho',
                checked: false,
                module: 'biddingInventory',
                functions: {
                    show: {
                        checked: true,
                    },
                    create: {
                        checked: true,
                    },
                    edit: {
                        checked: true,
                    },
                    delete: {
                        checked: true,
                    }
                }
            },
            {
                label: 'Báo cáo tồn kho HSD 12 tháng',
                checked: false,
                module: 'biddingInventoryDate',
                functions: {
                    show: {
                        checked: true,
                    },
                    create: {
                        checked: true,
                    },
                    edit: {
                        checked: true,
                    },
                    delete: {
                        checked: true,
                    }
                }
            },
            {
                label: 'Báo cáo hàng hủy',
                checked: false,
                module: 'inventoryDateDelete',
                functions: {
                    show: {
                        checked: true,
                    },
                    create: {
                        checked: true,
                    },
                    edit: {
                        checked: true,
                    },
                    delete: {
                        checked: true,
                    }
                }
            },
            {
                label: 'Báo cáo tổng hợp bán hàng , công nợ theo Asm',
                checked: false,
                module: 'salessummary',
                functions: {
                    show: {
                        checked: true,
                    },
                    create: {
                        checked: true,
                    },
                    edit: {
                        checked: true,
                    },
                    delete: {
                        checked: true,
                    },
                }
            },
        ]);
        const selectAllPermissions = computed({
            get() {
                return permissions.value.every(permission => permission.checked);
            },
            set(value) {
                permissions.value.forEach(permission => {
                permission.checked = value;
                });
            }
            });
        const createRole = () => {
            const companyIds = selectedCompanny.value?.map(company => company.id) ?? [];
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
            // const selectedPermissions = permissions.value.filter(permission => permission.checked).map(permission => permission.name);
            console.log(selectedPermissions);
            const status = isActive.value ? 0 : 1;
            axios.post(`${baseUrl}/api/roles`, {
                    name: roleName.value,
                    note: roleNote.value,
                    description: roleNote.value,
                    status: status,
                    permissions: selectedPermissions,
                    company_id:companyIds,
                })
                .then(response => {
                    roles.value.push(response.data);
                    roleName.value = '';
                    roleNote.value = '';
                    isActive.value = true;
                    toast.success("Bạn đã tạo nhóm thành công");
                     router.push({
                        name: "admin-roles",
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
        const companyRole = () => {
            axios
                .get(`${baseUrl}/api/companyRole`)
                .then((response) => {
                    company.value = response.data.company;
                })
                .catch((error) => {
                    console.log(error);
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
        companyRole();
        return {
            roleName,
            roleNote,
            isActive,
            createRole,
            roles,
            permissions,
            selectAllPermissions,
            errors,
            company, 
            selectedCompanny
        };
    },
});
</script>
