<template>
<div class="row">
    <div class="col-md-6">
        <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Danh sách người dùng <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Cập nhật người dùng </h4>
    </div>
</div>
<div class="card">
    <div class="card-body">
        <form>
            <div class="row mb-3">
                <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Nhóm quyền</label>
                <div class="col-sm-10">
                    <select v-model="user.store_id" class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                        <option v-for="store in stores" :value="store.ID">{{ store.store_name }}</option>
                    </select>
                </div>
            </div>
            <div class="row mb-3">
                <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Khu vực</label>
                <div class="col-sm-10">
                    <select v-model="user.store_id" class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                        <option v-for="store in stores" :value="store.ID">{{ store.store_name }}</option>
                    </select>
                </div>
            </div>
            <div class="row ">
                <label class="col-sm-2 col-form-label" for="basic-default-name">Trạng thái</label>
                <div class="col-sm-2">
                    <input class="form-check-input" type="checkbox" v-model="isActive" id="flexSwitchCheckDefault">
                    <label class="form-check-label check-left text-success" for="flexSwitchCheckDefault"> Hoạt động </label>
                </div>
            </div>
        </form>
    </div>
</div>
</template>


<script>
import axios from 'axios';
import {
    defineComponent,
    ref,
    onMounted,
    computed,
    watch
} from 'vue';
import {
    useToast
} from 'vue-toast-notification';
import {
    useRouter,
    useRoute
} from "vue-router";
import {
    inject
} from 'vue';

export default defineComponent({
    setup() {
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const router = useRouter();
        const route = useRoute();
        const toast = useToast();
        const errors = ref([]);
        const stores = ref([]);
        const role = ref([]);
        const user = ref({
            display_name: "",
            email: "",
            phone: "",
            store_id: "",
            user_status: "",
        });
        const selectAllFunctions = ref({
            show: false,
            create: false,
            edit: false,
            delete: false,
        });
        const permissions = ref([{
                label: 'Đặt hàng',
                checked: false,
                module: 'sop',
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
                label: 'Thiết lập',
                checked: false,
                module: 'setting',
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
                }
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
                }
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
                }
            },
        ]);
        const watchedPermissions = computed(() => {
            return permissions.value;
        });

        const toggleAllFunctions = () => {
            if (selectAllFunctions.value) {
                const newState = !selectAllFunctions.value.show;
                permissions.value.forEach((permission) => {
                    permission.checked = newState;
                    Object.keys(permission.functions).forEach((func) => {
                        permission.functions[func].checked = newState;
                    });
                });
            }
        };

        const toggleFunction = (func) => {
            if (selectAllFunctions.value) {
                selectAllFunctions.value[func] = !selectAllFunctions.value[func];
                permissions.value.forEach((permission) => {
                    permission.functions[func].checked = selectAllFunctions.value[func];
                });
            }
        };
        watch(permissions, () => {
            watchedPermissions.value = permissions.value;
        });
        const getUsersRoles = async () => {
            try {
                const response = await axios.get(`${baseUrl}/api/user/${route.params.id}/roles`);
                const {
                    permissions: userPermissions,
                    user: userData,
                    stores: {
                        data: storeData
                    },
                    role: {
                        data: role
                    },
                } = response.data;

                user.value = {
                    display_name: userData.display_name,
                    email: userData.email,
                    phone: userData.phone,
                    store_id: userData.store_id,
                    role: role,
                };
                role.value = role;
                stores.value = storeData;
                const formattedPermissions = permissions.value.map((permission) => {
                    const foundPermission = userPermissions.find((perm) => perm.name === `${permission.module}`);
                    const functions = ['show', 'create', 'edit', 'delete'].reduce((acc, func) => {
                        acc[func] = {
                            checked: foundPermission ? userPermissions.some((perm) => perm.name === `${permission.module}.${func}`) : false,
                        };
                        return acc;
                    }, {});

                    return {
                        label: permission.label,
                        checked: foundPermission ? true : false,
                        module: permission.module,
                        functions: functions,
                    };
                });

                //permissions.value = formattedPermissions;
            } catch (error) {
                console.error('Error fetching user permissions:', error);
            }
        };

        const putUsersRoles = () => {
            const selectedPermissions = [];

            watchedPermissions.value.forEach((permission) => {
                if (permission.module && permission.functions && permission.checked) {
                    Object.keys(permission.functions).forEach((func) => {
                        if (permission.functions[func].checked) {
                            const permissionString = `${permission.module}.${func}`;
                            selectedPermissions.push(permissionString);
                        }
                    });
                    selectedPermissions.push(permission.module);
                }
            });

            axios
                .put(`/api/user/${route.params.id}/permissions`, {
                    display_name: user.value.display_name,
                    email: user.value.email,
                    phone: user.value.phone,
                    store_id: user.value.store_id,
                    permissions: selectedPermissions,
                    user_status: user.value.user_status,
                })
                .then((response) => {
                    toast.success('Cập nhật quyền thành công');
                })
                .catch((error) => {
                    console.error('Error updating permissions:', error.response.data);
                });
        };

        onMounted(() => {
            getUsersRoles();
        });

        return {
            role,
            errors,
            stores,
            user,
            putUsersRoles,
            permissions,
            selectAllFunctions,
            toggleAllFunctions,
            toggleFunction,
        };
    },
});
</script>
