<template>
<aside id="layout-menu" class="layout-menu menu-vertical menu bg-menu-theme background-custom">
    <div class="app-brand demo">
        <router-link :to="{ name: 'dashboard' }" class="app-brand-link">
            <span class="w-px-50">
                <img src="/assets/img/avatars/logo.png" alt="Avatar" class="w-px-50 h-auto rounded-circle" />
            </span>
            <span class="app-brand-text menu-text fw-bolder ms-6">BIVID Pharma</span>
        </router-link>
        <a href="javascript:void(0);" class="layout-menu-toggle menu-link text-large ms-auto d-block d-xl-none" id="close-menu">
            <i class="bx bx-chevron-left bx-sm align-middle" ></i>
        </a>
    </div>
    <div class="menu-inner-shadow"></div>
    <ul class="menu-inner py-1">
        <li class="menu-item">
            <router-link :to="{ name: 'dashboard' }" class="menu-link">
                <i class='menu-icon bx bxs-dashboard'></i>
                <div data-i18n="Analytics">Tổng quan</div>
            </router-link>
        </li>
        <li class="menu-item">
            <router-link :to="{ name: 'admin-inbox' }" class="menu-link">
                <i class='menu-icon bx bx-credit-card'></i>
                <div data-i18n="Authentications">Hộp thư</div>
            </router-link>
        </li>
        <li class="menu-item">
            <router-link :to="{ name: 'admin-order' }" class="menu-link" v-if="hasPermission('order')">
                <i class='menu-icon bx bx-shopping-bag'></i>
                <div data-i18n="Authentications">Đơn hàng</div>
            </router-link>
        </li>
        <li class="menu-item">
            <a href="javascript:void(0);" class="menu-link menu-toggle" v-if="hasPermission('order')">
                <i class='menu-icon bx bx-shopping-bag'></i>
                <div data-i18n="Authentications">Đơn hàng online</div>
            </a>
            <ul class="menu-sub">
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-order-baolong' }" class="menu-link">
                        <div data-i18n="Authentications">Bảo long</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-order-bileje' }" class="menu-link">
                        <div data-i18n="Authentications">Bileje</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-order-baolongpharm' }" class="menu-link">
                        <div data-i18n="Authentications">Baolongpharm</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-order-babyshop' }" class="menu-link">
                        <div data-i18n="Authentications">Babyshop</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-order-saigon' }" class="menu-link">
                        <div data-i18n="Authentications">Saigon</div>
                    </router-link>
                </li>
            </ul>
        </li>
        <li class="menu-item" v-if="hasPermission('customer')">
            <router-link :to="{ name: 'admin-customer' }" class="menu-link">
                <i class="menu-icon bx bx-group"></i>
                <div data-i18n="Authentications">Khách hàng</div>
            </router-link>
        </li>
        <li class="menu-item" v-if="hasPermission('debts')">
            <router-link :to="{ name: 'admin-debts' }" class="menu-link">
                <i class='menu-icon bx bx-credit-card'></i>
                <div data-i18n="Authentications">Công nợ</div>
            </router-link>
        </li>
        <li class="menu-item">
            <a href="javascript:void(0);" class="menu-link menu-toggle" v-if="checkRole('Admin')">
                <i class="menu-icon tf-icons bx bxl-product-hunt"></i>
                <div data-i18n="Authentications">Sản phẩm</div>
            </a>
            <ul class="menu-sub">
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-products' }" class="menu-link">
                        <div data-i18n="Authentications">Sản phẩm</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-category' }" class="menu-link" v-if="hasPermission('category')">
                        <div data-i18n="Authentications">Nhóm sản phẩm</div>
                    </router-link>
                </li>
            </ul>
        </li>
        
        
        <li class="menu-item">
            <a href="javascript:void(0);" class="menu-link menu-toggle">
                <i class="menu-icon tf-icons bx bxl-product-hunt"></i>
                <div data-i18n="Authentications">Quản lý cận Date</div>
            </a>
            <ul class="menu-sub">
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-expirationDate' }" class="menu-link">
                        <div data-i18n="Authentications">Kế hoạch bán hàng cận date <span class="badge rounded-pill bg-danger">
                                <i class="bi bi-star-fill"></i> New
                            </span></div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-implementationDate' }" class="menu-link" v-if="hasPermission('category')">
                        <div data-i18n="Authentications">      
                            Kết quả thực hiện bán hàng cận date
                        </div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-implementationReport' }" class="menu-link" v-if="hasPermission('category')">
                        <div data-i18n="Authentications">Báo cáo theo dõi bán hàng cận date</div>
                    </router-link>
                </li>
            </ul>
        </li>
        <li class="menu-item">
            <a href="javascript:void(0);" class="menu-link menu-toggle" v-if="checkRole('Admin')">
                <i class='menu-icon bx bx-lock-open-alt'></i>
                <div data-i18n="Authentications">Phân quyền</div>
            </a>
            <ul class="menu-sub">
                 <li class="menu-item">
                    <router-link :to="{ name: 'admin-stores' }" class="menu-link" v-if="hasPermission('stores')">
                        <div data-i18n="Authentications">Khu vực</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-roles' }" class="menu-link" v-if="checkRole('Admin')">
                        <div data-i18n="Authentications">Nhóm quyền</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-permission' }" class="menu-link" v-if="checkRole('Admin')">
                        <div data-i18n="Authentications">Người dùng</div>
                    </router-link>
                </li>
            </ul>
        </li>
        <li class="menu-item">
            <a href="javascript:void(0);" class="menu-link menu-toggle" v-if="checkRole('Admin')">
                <i class='menu-icon bx bx-cog'></i>
                <div data-i18n="Authentications">Thiết lập</div>
            </a>
            <ul class="menu-sub">
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-status' }" class="menu-link" v-if="hasPermission('status')">
                        <div data-i18n="Authentications">Trạng thái</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-setting-template' }" class="menu-link" v-if="checkRole('Admin')">
                        <div data-i18n="Authentications">Mẫu hóa đơn</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-setting-email' }" class="menu-link" v-if="checkRole('Admin')">
                        <div data-i18n="Authentications">Mẫu Email</div>
                    </router-link>
                </li>
            </ul>
        </li>
        <li class="menu-item">
            <a href="javascript:void(0);" class="menu-link menu-toggle" v-if="checkRole('Admin')">
                <i class='menu-icon bx bx-cog'></i>
                <div data-i18n="Authentications">Quản trị</div>
            </a>
            <ul class="menu-sub">
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-software' }" class="menu-link">
                        <div data-i18n="Authentications">Khoá phần mềm</div>
                    </router-link>
                </li>
            </ul>
        </li>
        <li class="menu-item">
            <router-link :to="{ name: 'admin-contact' }" class="menu-link">
                <i class="bx bxs-contact menu-icon"></i>
                <div data-i18n="Authentications">Liên hệ</div>
            </router-link>
        </li>
        <li class="menu-item">
            <router-link :to="{ name: 'admin-summary' }" class="menu-link" v-if="hasPermission('summary')">
                <i class="menu-icon bx bx-news"></i>
                <div data-i18n="Authentications">Tổng hợp</div>
            </router-link>
        </li>

        <li class="menu-item">
            <router-link :to="{ name: 'admin-analytic' }" class="menu-link" v-if="hasPermission('analytic')">
                <i class="menu-icon bx bx-bar-chart-alt"></i>
                <div data-i18n="Authentications">Thống kê quản lý</div>
            </router-link>
        </li>
        <li class="menu-item">
            <a href="javascript:void(0);" class="menu-link menu-toggle" v-if="hasPermission('chart')">
                <i class='menu-icon bx bx-chart'></i>
                <div data-i18n="Authentications">Thống kê</div>
            </a>
            <ul class="menu-sub">
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-chart' }" class="menu-link">
                        <div data-i18n="Authentications">Thống kê</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-chart-compare' }" class="menu-link">
                        <div data-i18n="Authentications">So sánh biểu đồ</div>
                    </router-link>
                </li>
            </ul>
        </li>
        <li class="menu-item">
            <a href="javascript:void(0);" class="menu-link menu-toggle">
                <i class='menu-icon bx bxs-file-doc'></i>
                <div data-i18n="Authentications">Báo cáo</div>
            </a>
            <ul class="menu-sub">
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-contractor' }" class="menu-link" v-if="hasPermission('contractor')" >
                        <div data-i18n="Authentications">Tổng quan thầu</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-bidding-contractor' }" class="menu-link" v-if="hasPermission('biddingParticipate')">
                        <div data-i18n="Authentications">Theo dõi tham gia thầu</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-bidding-contractor-order' }" class="menu-link" v-if="hasPermission('biddingContractorOrder')">
                        <div data-i18n="Authentications">Theo dõi tham gia bán hàng</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-marketing' }" class="menu-link" v-if="hasPermission('marketing')">
                        <div data-i18n="Authentications">Tổng quan marketing</div>
                    </router-link>
                </li>

                <li class="menu-item">
                    <router-link :to="{ name: 'admin-bidding-order-customer' }" class="menu-link" v-if="hasPermission('orderCustomer')">
                        <div data-i18n="Authentications">Tổng quan bán hàng</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-bidding-order' }" class="menu-link" v-if="hasPermission('biddingOrder')">
                        <div data-i18n="Authentications">Tổng quan bán hàng (theo chi nhánh , Sản phẩm)</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-bidding-debts' }" class="menu-link" v-if="hasPermission('biddingDebts')">
                        <div data-i18n="Authentications">Tổng quan công nợ phải thu</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-inventory' }" class="menu-link" v-if="hasPermission('biddingInventory')">
                        <div data-i18n="Authentications">Báo cáo tồn kho</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-inventory-date' }" class="menu-link" v-if="hasPermission('biddingInventoryDate')">
                        <div data-i18n="Authentications">Báo cáo tồn kho HSD dưới 12 tháng</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-inventory-date-delete' }" class="menu-link" v-if="hasPermission('inventoryDateDelete')">
                        <div data-i18n="Authentications">Báo cáo hàng huỷ</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'salessummary' }" class="menu-link" v-if="hasPermission('salessummary')">
                        <div data-i18n="Authentications">Báo cáo tổng hợp bán hàng , Công nợ theo ASM</div>
                    </router-link>
                </li>
            </ul>
        </li>
        <li class="menu-item">
            <router-link :to="{ name: 'admin-account' }" class="menu-link">
                <i class="menu-icon bx bxs-user-account"></i>
                <div data-i18n="Authentications">Tài khoản của tôi</div>
            </router-link>
        </li>
        <li class="menu-item">
            <a href="javascript:void(0);" class="menu-link menu-toggle" v-if="checkRole('Admin')">
                 <i class='menu-icon bx bx-import'></i>
                <div data-i18n="Authentications">Đồng bộ dữ liệu</div>
            </a>
            <ul class="menu-sub">
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-import' }" class="menu-link" v-if="checkRole('Admin')">
                        <div data-i18n="Authentications">Khách hàng</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-product' }" class="menu-link" v-if="checkRole('Admin')">
                        <div data-i18n="Authentications">Sản phẩm</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-winning-product' }" class="menu-link" v-if="checkRole('Admin')">
                        <div data-i18n="Authentications">Sản phẩm trúng thầu</div>
                    </router-link>
                </li>
                <li class="menu-item">
                    <router-link :to="{ name: 'admin-debts-customer' }" class="menu-link" v-if="checkRole('Admin')">
                        <div data-i18n="Authentications">Công nợ khách hàng</div>
                    </router-link>
                </li>
            </ul>
        </li>

    </ul>
</aside>
</template>

<script>
import axios from 'axios';
import {
    defineComponent,
    ref,
    onMounted,
    inject
} from 'vue';
import {
    fetchUserRoles
} from '@/utils/role.js';
import {
    fetchUserPermission
} from '@/utils/permission.js';
export default defineComponent({
    setup() {
        const globalState = inject('globalState');
        const userPermission = ref([]);
        const userRoles = ref([]);
        onMounted(async () => {
            try {
                userRoles.value = await fetchUserRoles();
                userPermission.value = await fetchUserPermission();
            } catch (error) {
                console.error('Error fetching user roles:', error);
            }
        });

        function hasPermission(args) {
            return Object.values(userPermission.value).includes(args);
        }

        function checkRole(args) {
            return userRoles.value.includes(args);
        }
        function DateTime() {
           const date = Date();
           console.log(date);
        }
        
        return {
            globalState,
            hasPermission,
            checkRole,
            userRoles,
            userPermission,
            DateTime
        };
    },
});
</script>
