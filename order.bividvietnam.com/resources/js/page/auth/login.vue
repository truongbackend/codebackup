<template>
<div class="app-brand justify-content-center mb-0">
    <a href="" class="app-brand-link gap-2">
        <span class="img-logo">
            <img src="assets/img/avatars/logo.png" alt="">
        </span>
    </a>
</div>
<form @submit.prevent="login" id="formAuthentication" class="mb-3">
    <div class="mb-3">
        <label for="email" class="form-label">Email</label>
        <input type="text" class="form-control" id="email" name="email" v-model="student.email" placeholder="Enter your email" required autofocus />
    </div>
    <div class="mb-3 form-password-toggle">
        <div class="d-flex justify-content-between">
            <label class="form-label" for="password">Password</label>
            <router-link :to="{ name: 'resetpassword' }">
                <small class="color-blue">Quên mật khẩu</small>
            </router-link>
        </div>
        <div class="input-group input-group-merge">
            <input type="password" id="password" class="form-control" name="password" v-model="student.password" placeholder="&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;" aria-describedby="password" required />
            <span class="input-group-text cursor-pointer"><i class="bx bx-hide"></i></span>
        </div>
    </div>
    <div class="mb-3">
        <button class="btn btn-primary d-grid w-100 btn-dang-nhap" type="submit">Đăng nhập</button>
    </div>
</form>
</template>

<script>
import axios from 'axios';
import {
    defineComponent,
    ref,
    onMounted
} from 'vue';
import {
    useRouter
} from 'vue-router';
import {
    useToast
} from 'vue-toast-notification';
import {
    inject
} from 'vue';
export default defineComponent({
    setup() {
        const student = ref({
            email: '',
            password: ''
        });
        const user = ref({});
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const router = useRouter();
        const toast = useToast();
        const login = () => {
            if (!student.value.email || !student.value.password) {
                toast.error("Vui lòng điền đầy đủ email và mật khẩu");
                return;
            }
            axios.post('/api/login', student.value)
                .then(({
                    data
                }) => {
                    if (data.error) {
                        toast.error("Tài khoản hoặc mật khẩu không đúng");
                    } else {
                        const token = data.access_token;
                        fetchUserData();
                        loginApi();
                        localStorage.setItem('token', token);
                        toast.success("Đăng nhập thành công");
                        router.push({ name: 'dashboard' });
                    }
                })
                .catch((error) => {
                    console.error(error);
                    toast.error("Tài khoản hoặc mật khẩu không đúng. Xin hay nhập lại");
                });
        };
        const fetchUserData = async () => {
            try {
                const token = localStorage.getItem('token');
                if (!token) {
                    throw new Error('Token not found');
                }
                const response = await axios.get(`${baseUrl}/api/profile`, {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                });
                user.value = response.data;
                return user.value.username;
            } catch (error) {
                console.error(error);
                toast.error('Người dùng chưa đăng nhập');
            }
        };
        const loginApi = async () => {
            try {
                const username = await fetchUserData();
                const response = await axios.post('http://192.168.1.101/System/login', {
                    password: student.value.password,
                    userName: username,
                });
                if (response.status === 200) {
                    const data = response.data;
                    if (data.error) {
                        toast.error("Tài khoản hoặc mật khẩu không đúng");
                    } else {
                        const tokensApi = data.tokenId;
                        localStorage.setItem('tokensApi', tokensApi);
                    }
                } else {
                }
            } catch (error) {
                console.error(error);
            }
        };
        return {
            loginApi,
            student,
            login,
            user,
        };
    }
});
</script>
