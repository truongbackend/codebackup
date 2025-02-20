<template>
<div class="container-xxl background-auth">
    <div class="authentication-wrapper authentication-basic container-p-y">
        <div class="authentication-inner py-4">
            <div class="card">
                <div class="card-body">
                    <router-view></router-view>
                </div>
            </div>
        </div>
    </div>
</div>
</template>

<script>
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
                await loadScript('/assets/js/main.js');
                await loadScript('/assets/js/ui-toasts.js');
            } catch (error) {
                console.error('Error loading scripts:', error);
            }
        });
        return {};
    },
});
</script>
