<template>
<h4 class="fw-bold py-3 mb-4">Tài khoản của tôi</h4>
<div class="row">
    <div class="col-md-12">
        <div class="card mb-4">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h5 class="mb-0">Thông tin người dùng</h5>
            </div>
            <div class="card-body">
                <form id="formAccountSettings" @submit.prevent="submitForm">
                    <div class="row">
                        <div class="mb-3 col-md-6">
                            <label for="firstName" class="form-label">Tên nhân viên</label>
                            <input class="form-control" v-model="user.display_name" type="text" id="firstName" name="firstName" autofocus readonly />
                        </div>
                        <div class="mb-3 col-md-6">
                            <label for="email" class="form-label">Email</label>
                            <input class="form-control" v-model="user.email" type="email" id="email" name="email" placeholder="john.doe@example.com" readonly />
                        </div>
                        <div class="mb-3 col-md-6">
                            <label class="form-label" for="phoneNumber">Số điện thoại</label>
                            <div class="input-group input-group-merge">
                                <span class="input-group-text">VN (+84)</span>
                                <input type="text" id="phoneNumber" name="phoneNumber" v-model="user.phone" class="form-control" placeholder="202 555 0111" />
                            </div>
                        </div>
                        <div class="mb-3 col-md-6">
                            <label for="address" class="form-label">Mã khách hàng</label>
                            <input type="text" readonly class="form-control" id="address" name="address" v-model="user.customerCode" placeholder="Mã khách hàng" />
                        </div>
                        <div class="mb-3 col-md-6">
                            <label for="email" class="form-label">Công ty</label>
                             <input class="form-control" v-model="companyName" type="text" id="company" name="company" placeholder="Tên công ty" />
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</template>

<script>
import {
    defineComponent,
    ref,
    onMounted
} from 'vue';
import {
    useToast
} from 'vue-toast-notification';
import axios from 'axios';
import {
    inject
} from 'vue';
export default defineComponent({
    setup() {
        const user = ref({
            username: "",
            email: "",
            phone: "",
            customerCode: "",
        });
        const toast = useToast();
        const companies = ref([]);
        const companyName = ref("");
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
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
                getCompany();
            } catch (error) {
                console.error(error);
                toast.error('Người dùng chưa đăng nhập');
            }
        };
        const getCompany = () => {
            axios
                .get(`${baseUrl}/api/profileCompany`)
                .then((response) => {
                    companies.value = response.data.company;
                    const selectedCompany = companies.value.find(company => company.id === user.value.company_select);
                    if (selectedCompany) {
                        companyName.value = selectedCompany.name;
                    }
                })
                .catch((error) => {});
        }
        onMounted(() => {
            fetchUserData();
        });
        return {
            user,
            companies,
            getCompany,
            companyName
        };
    },
});
</script>
