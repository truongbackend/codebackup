<template>
<div class="layout-wrapper layout-content-navbar">
    <div class="layout-container">
        <div class="layout-page">
            <AdminNav />
            <AdminHeader />
            <div class="content-wrapper">
                <div class="container-fluid flex-grow-1 container-p-y">
                    <router-view></router-view>
                </div>
            </div>
        </div>
    </div>
</div>
</template>

<script>
import AdminHeader from "../components/AdminHeader.vue";
import AdminNav from "../components/AdminNav.vue";
import axios from 'axios';
import {
    defineComponent,
    onMounted
} from 'vue';
const loadScript = (src) => {
    return new Promise((resolve, reject) => {
        const script = document.createElement('script');
        script.src = src;
        script.onload = resolve;
        script.onerror = reject;
        document.head.appendChild(script);
    });
};
export default defineComponent({
    setup() {
        onMounted(async () => {
            try {
                await loadScript('/assets/vendor/js/menu.js');
                await loadScript('/assets/js/custom.js');
                await loadScript('/assets/js/main.js');
                await loadScript('/assets/js/ui-toasts.js');
            } catch (error) {
                console.error('Error loading scripts:', error);
            }
        });
    },
    components: {
        AdminHeader,
        AdminNav,
    }
});
</script>
