<template>
<div class="app-brand justify-content-center mb-0">
        <a href="" class="app-brand-link gap-2">
            <span class="img-logo">
                <img src="assets/img/avatars/logo.png" alt="">
            </span>
        </a>
    </div>
<form id="formAuthentication" class="mb-3" @submit.prevent="resetPassword">
    <div class="mb-3">
        <label for="email" class="form-label">Email</label>
        <input type="text" class="form-control" v-model="student.email" placeholder="Hãy nhập email" autofocus />
    </div>
    <button type="submit" class="btn btn-primary d-grid w-100" :disabled="isSaving">Gửi</button>
</form>
<div class="text-center">
    <router-link :to="{ name: 'login' }" class="d-flex align-items-center justify-content-center">
        <i class="bx bx-chevron-left scaleX-n1-rtl bx-sm"></i>
        Quay lại trang đăng nhập
    </router-link>
</div>
</template>

<script>
import axios from 'axios';
import {
    defineComponent,
    ref
} from 'vue';
import {
    useToast
} from 'vue-toast-notification';

export default defineComponent({
    setup() {
        const student = ref({
            email: '',
        });
        const isSaving = ref(false);
        const toast = useToast();

        const resetPassword = () => {
            if (!student.value.email) {
                toast.error("Vui lòng nhập địa chỉ email.");
                return;
            }
            if (isSaving.value) {
                return;
            }

            isSaving.value = true;
            axios.post('/api/forgot-password', student.value)
                .then(({
                    data
                }) => {
                    if (data.message) {
                        toast.success(data.message);
                    } else {
                        toast.error("Có lỗi xảy ra. Vui lòng thử lại sau.");
                    }
                })
                .catch((error) => {
                    console.error(error);
                    toast.error("Có lỗi xảy ra. Vui lòng thử lại sau.");
                })
                .finally(() => {
                    isSaving.value = false;
                });
        };
        return {
            student,
            resetPassword,
            isSaving,
        };
    },
});
</script>
