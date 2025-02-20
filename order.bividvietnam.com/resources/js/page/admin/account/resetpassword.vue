<template>
    <h4 class="fw-bold py-3 mb-4">
      <span class="text-muted fw-light">Tài khoản của tôi <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Đổi mật khẩu
    </h4>
    <div class="row">
      <div class="col-md-12">
        <div class="card mb-4">
          <div class="card-header d-flex align-items-center justify-content-between">
            <h5 class="mb-0">Cập nhật mật khẩu</h5>
          </div>
          <div class="card-body">
            <form id="formAccountDeactivation" @submit.prevent="updatePassword">
              <div id="accordionThree" class="accordion-collapse " aria-labelledby="headingThree" data-bs-parent="#accordionExample">
                <div class="mb-3">
                  <input type="password" class="form-control" v-model="password.currentPassword" placeholder="Mật khẩu hiện tại" />
                  <small class="text-danger text-start-center" v-if="errors.current_password">{{ errors.current_password[0] }}</small>
                </div>
                <div class="mb-3">
                  <input type="password" class="form-control" v-model="password.newPassword" placeholder="Mật khẩu mới" />
                  <small class="text-danger text-start-center" v-if="errors.new_password">{{ errors.new_password[0] }}</small>
                </div>
                <div class="mb-3">
                  <input type="password" class="form-control" v-model="password.confirmNewPassword" placeholder="Nhập lại mật khẩu mới" />
                  <small class="text-danger text-start-center" v-if="errors.confirm_password">{{ errors.confirm_password[0] }}</small>
                </div>
              </div>
              <div class="row mb-3">
                <div class="col-sm-12 text-end">
                    <button type="submit" class="btn btn-primary me-sm-2">Lưu</button>
                    <router-link :to="{ name: 'admin-account' }" class="btn btn-danger ">
                                    Hủy
                                </router-link>
                </div>
                </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import { defineComponent, ref } from 'vue';
  import { useToast } from 'vue-toast-notification';
  import axios from 'axios';
  import { inject } from 'vue';
  
  export default defineComponent({
    setup() {
      const user = ref({
        username: "",
        email: "",
        phone: "",
        customerCode: "",
      });
      const toast = useToast();
      const globalState = inject('globalState');
      const baseUrl = globalState.baseUrl;
      const password = ref({
        currentPassword: "",
        newPassword: "",
        confirmNewPassword: "",
      });
      const errors = ref({
        current_password: [],
        new_password: [],
        confirm_password: []
      });
  
      const updatePassword = async () => {
        try {
          const token = localStorage.getItem('token');
          if (!token) {
            throw new Error('Token not found');
          }
          const data = {
            current_password: password.value.currentPassword,
            new_password: password.value.newPassword,
            confirm_password: password.value.confirmNewPassword,
          };
          const response = await axios.post(`${baseUrl}/api/update-password`, data, {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          });
          if (response.status === 200) {
          toast.success('Mật khẩu đã được cập nhật thành công');
          password.value.currentPassword = "";
          password.value.newPassword = "";
          password.value.confirmNewPassword = "";
        } else {
          const errorData = response.data;
          errors.value = {
            current_password: errorData.current_password ? errorData.current_password[0] : "",
            new_password: errorData.new_password ? errorData.new_password[0] : "",
            confirm_password: errorData.confirm_password ? errorData.confirm_password[0] : ""
          };
        }
      } catch (error) {
        console.error(error);
        toast.error('Có lỗi xảy ra khi cố gắng cập nhật mật khẩu.');
      }
    };
  
      return {
        user,
        password,
        updatePassword,
        errors,
      };
    },
  });
  </script>
  