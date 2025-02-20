const admin = [
    { path: '/', redirect: '/login' },
    {
        path: "/admin",
        component: () =>import ("../layout/admin.vue"),
        children: [
            {
                path: "users",
                name: "admin-users",
                component: () =>import ("../page/admin/users/index.vue"),
                meta: {permissions: ['user', 'delete user,create user,show user,create debts'] },
            },
                {
                    path: "users/create",
                    name: "admin-users-create",
                    component: () =>import ("../page/admin/users/create.vue"),
                },
                {
                    path: "users/:id/update",
                    name: "admin-users-update",
                    component: () =>import ("../page/admin/users/edit.vue"),
                },
                {
                    path: "users/:id/update",
                    name: "admin-users-update",
                    component: () =>import ("../page/admin/users/edit.vue"),
                },

            {
                path: "customer",
                name: "admin-customer",
                component: () =>import ("../page/admin/customer/index.vue"),
            },
                {
                    path: "customer/create",
                    name: "admin-customer-create",
                    component: () =>import ("../page/admin/customer/create.vue"),
                },
                {
                    path: "customer/:id/update",
                    name: "admin-customer-update",
                    component: () =>import ("../page/admin/customer/edit.vue"),
                },
                {
                    path: "customer/:customer",
                    name: "admin-customer-detail",
                    component: () => import("../page/admin/customer/list.vue"),
                },

            {
                path: "products",
                name: "admin-products",
                component: () =>import ("../page/admin/products/index.vue"),
            },
                {
                    path: "products/create",
                    name: "admin-products-create",
                    component: () =>import ("../page/admin/products/create.vue"),
                },
                {
                    path: "products/:products",
                    name: "admin-products-detail",
                    component: () => import("../page/admin/products/list.vue"),
                },
                {
                    path: "products/:id/update",
                    name: "admin-products-update",
                    component: () =>import ("../page/admin/products/edit.vue"),
                },
            {
                path: "contact",
                name: "admin-contact",
                component: () =>import ("../page/admin/contact/index.vue"),
            },
            {
                path: "status",
                name: "admin-status",
                component: () =>import ("../page/admin/status/index.vue"),
            },
                {
                    path: "status/create",
                    name: "admin-status-create",
                    component: () =>import ("../page/admin/status/create.vue"),
                },
                {
                    path: "status/:id/update",
                    name: "admin-status-update",
                    component: () =>import ("../page/admin/status/edit.vue"),
                },
            {
                path: "template",
                name: "admin-setting-template",
                component: () =>import ("../page/admin/template/index.vue"),
            },
            {
                path: "template-email",
                name: "admin-setting-email",
                component: () =>import ("../page/admin/templateEmail/index.vue"),
            },
            {
                path: "stores",
                name: "admin-stores",
                component: () =>import ("../page/admin/stores/index.vue"),
            },
                {
                    path: "stores/create",
                    name: "admin-stores-create",
                    component: () =>import ("../page/admin/stores/create.vue"),
                },
                {
                    path: "stores/:id/update",
                    name: "admin-stores-update",
                    component: () =>import ("../page/admin/stores/edit.vue"),
                },
                {
                    path: "permision/data/:id/add",
                    name: "admin-permisiondata-add",
                    component: () =>import ("../page/admin/permissionData/add.vue"),
                },
            {
                path: "order",
                name: "admin-order",
                component: () =>import ("../page/admin/order/index.vue")
            },
                {
                    path: "order/:id/edit",
                    name: "admin-order-update",
                    component: () =>import ("../page/admin/order/edit.vue"),
                },
                {
                    path: "order/:order",
                    name: "admin-order-detail",
                    component: () => import("../page/admin/order/roles.vue"),
                },
            {
                path: "account",
                name: "admin-account",
                component: () =>import ("../page/admin/account/index.vue")
            },
            {
                path: "debts",
                name: "admin-debts",
                component: () =>import ("../page/admin/debts/index.vue")
            },
                {
                    path: "debts/:debts",
                    name: "admin-debts-detail",
                    component: () => import("../page/admin/debts/list.vue"),
                },
            {
                path: "category",
                name: "admin-category",
                component: () =>import ("../page/admin/category/index.vue")
            },
                {
                    path: "category/create",
                    name: "admin-category-create",
                    component: () =>import ("../page/admin/category/create.vue")
                },
                {
                    path: "category/:id/update",
                    name: "admin-category-update",
                    component: () =>import ("../page/admin/category/edit.vue"),
                },
            {
                path: "analytic",
                name: "admin-analytic",
                component: () =>import ("../page/admin/analytic/index.vue")
            },
            {
                path: "summary",
                name: "admin-summary",
                component: () =>import ("../page/admin/summary/index.vue")
            },
            {
                path: "chart",
                name: "admin-chart",
                component: () => import ("../page/admin/chart/index.vue")
            },
            {
                path: "chart/compare",
                name: "admin-chart-compare",
                component: () => import ("../page/admin/chart/compare.vue")
            },
            {
                path: "roles",
                name: "admin-roles",
                component: () => import ("../page/admin/roles/index.vue")
            },
            {
                path: "roles/create",
                name: "admin-roles-create",
                component: () => import ("../page/admin/roles/create.vue")
            },
            {
                path: "roles/:id/edit",
                name: "admin-roles-edit",
                component: () => import ("../page/admin/roles/edit.vue")
            },
            {
                path: "roles/:id/data",
                name: "admin-roles-data",
                component: () => import ("../page/admin/roles/data.vue")
            },
            {
                path: "permission",
                name: "admin-permission",
                component: () => import ("../page/admin/permission/index.vue")
            },
            {
                path: "permission/:id/user",
                name: "admin-permission-user",
                component: () => import ("../page/admin/permission/edit.vue")
            },
            {
                path: "permission/data",
                name: "admin-permission-user-data",
                component: () => import ("../page/admin/permissionData/index.vue")
            },
            {
                path: "permission/data/:id/data",
                name: "admin-permission-user-data-edit",
                component: () => import ("../page/admin/permissionData/edit.vue")
            },
            {
                path: "permission/data/create",
                name: "admin-permission-user-data-create",
                component: () => import ("../page/admin/permissionData/create.vue")
            },
            {
                path: "sop",
                name: "sop",
                component: () => import ("../page/admin/sop/index.vue")
            },
            {
                path: "dashboard",
                name: "dashboard",
                component: () => import ("../page/admin/dashboard/index.vue")
            },
            {
                path: "account",
                name: "account",
                component: () =>import ("../page/admin/account/index.vue")
            },
            {
                path: "account/resetpassword",
                name: "account-resetpassword",
                component: () =>import ("../page/admin/account/resetpassword.vue")
            },
            {
                path: "salessummary",
                name: "salessummary",
                component: () =>import ("../page/admin/salessummary/index.vue")
            },
            {
                path: "manager",
                name: "admin-manager",
                component: () =>import ("../page/admin/manager/index.vue")
            },
            {
                path: "contractor",
                name: "admin-contractor",
                component: () =>import ("../page/admin/contractor/index.vue")
            },
            {
                path: "bidding-contractor",
                name: "admin-bidding-contractor",
                component: () =>import ("../page/admin/biddingContractor/index.vue")
            },
            {
                path: "marketing",
                name: "admin-marketing",
                component: () =>import ("../page/admin/marketing/index.vue")
            },
            {
                path: "bidding-order",
                name: "admin-bidding-order",
                component: () =>import ("../page/admin/biddingOrder/index.vue")
            },
            {
                path: "bidding-order-customer",
                name: "admin-bidding-order-customer",
                component: () =>import ("../page/admin/biddingOrderCustomer/index.vue")
            },
            {
                path: "bidding-debts",
                name: "admin-bidding-debts",
                component: () =>import ("../page/admin/biddingDebts/index.vue")
            },
            {
                path: "bidding-inventory",
                name: "admin-inventory",
                component: () =>import ("../page/admin/inventory/index.vue")
            },
            {
                path: "bidding-inventory-date",
                name: "admin-inventory-date",
                component: () =>import ("../page/admin/inventoryDate/index.vue")
            },
            {
                path: "admin-inventory-date-delete",
                name: "admin-inventory-date-delete",
                component: () =>import ("../page/admin/inventoryDateDelete/index.vue")
            },
            {
                path: "admin-bidding-contractor-order",
                name: "admin-bidding-contractor-order",
                component: () =>import ("../page/admin/contractorOrder/index.vue")
            },
        {
            path: "import",
            name: "admin-import",
            component: () =>import ("../page/admin/import/customer.vue")
        },
        {
            path: "import/product",
            name: "admin-product",
            component: () =>import ("../page/admin/import/product.vue")
        },
        {
            path: "import/winning-product",
            name: "admin-winning-product",
            component: () =>import ("../page/admin/import/winningproduct.vue")
        },
        {
            path: "import/debts-customer",
            name: "admin-debts-customer",
            component: () =>import ("../page/admin/import/debtcustomer.vue")
        },
        ]
    },
    {
        path: "/",
        component: () =>import ("../layout/auth.vue"),
        children: [
            {
                path: 'login',
                name: 'login',
                component: () =>import ("../page/auth/login.vue")
            },
            {
                path: 'resetpassword',
                name: 'resetpassword',
                component: () =>import ("../page/auth/forgotpassword.vue")
            }

        ]
    }
]

export default admin;
