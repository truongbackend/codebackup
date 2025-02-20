<template>
  <div class="col-md-12">
    <div class="card mb-4">
      <div class="card-body">
        <h5 class="mb-0 text-center"></h5>
        <h3 class="text-primary mt-3 text-center">Kết quả thực hiện bán hàng cận date tháng {{ currentMonth }} / {{ 2024 }}</h3>
        <div class="table-responsive text-nowrap">
          <table class="table table-bordered">
            <thead>
              <tr>
                <th rowspan="2">STT</th>
                <th rowspan="2">Mã vật tư</th>
                <th rowspan="2">Tên vật tư</th>
                <th rowspan="2">Số lô</th>
                <th rowspan="2">Đơn vị tính</th>
                <th rowspan="2">Ngày hết hạn</th>
                <th rowspan="2">Chi tiêu tháng {{ currentMonth }}</th>
                <th v-for="day in daysInMonth" :key="day" class="text-center">{{ day }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(expirationDates, index) in expirationDate" :key="index">
                <td>{{ index + 1 }}</td>
                <td>{{ expirationDates.ma_vt }}</td>
                <td class="formart-customer">{{ expirationDates.ten_vt }}</td>
                <td>{{ expirationDates.ma_lo }}</td>
                <td>{{ expirationDates.dvt }}</td>
                <td>{{ expirationDates.han_dung }}</td>
                <td>{{ expirationDates.sl_thang1 }}</td>
                <template v-for="day in daysInMonth" :key="'data-' + day">
                  <td>{{ expirationDates[`sl_banngay${day}`] || 0 }}</td>
                </template>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import { defineComponent, ref, onMounted, inject } from 'vue';
export default {
  setup() {
    const globalState = inject('globalState');
    const baseApi = globalState.baseApi;
    const expirationDate = ref([]);
    const currentDay = ref('');
    const currentDate = ref('');
    const currentMonth = ref('');
    const tokenApi = localStorage.getItem('tokensApi');
    const baseUrl = globalState.baseUrl;
    const daysInMonth = ref([]);

    const user = ref([]);
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
        return user.value;
      } catch (error) {
        console.error(error);
        throw error;
      }
    };

    const getExpirationDate = async () => {
      const users = await fetchUserData();
      const axiosConfig = {
        headers: {
          Authorization: `Bearer ${tokenApi}`,
          'Content-Type': 'application/json; charset=utf-8',
          API: 'True',
        },
      };
      axios
        .get(
          `${baseApi}/sales/chitieubanhangtonkhocandate/sale?ma_sale=hong.nguyenphuong&ma_cty=00${encodeURIComponent(
            users.company_select
          )}`,
          axiosConfig
        )
        .then((response) => {
          expirationDate.value = response.data;
        })
        .catch((error) => {
          console.log(error);
        });
    };
    const calculateCurrentDayAndMonth = () => {
      const currentDateObj = new Date();
      currentDate.value = currentDateObj.toLocaleDateString('vi-VN');
      currentDay.value = currentDateObj.getDate();
      currentMonth.value = currentDateObj.getMonth() + 1;
      const year = currentDateObj.getFullYear();
      const month = currentMonth.value;
      const days = new Date(year, month, 0).getDate();
      daysInMonth.value = Array.from({ length: days }, (_, i) => i + 1);
    };

    onMounted(() => {
      getExpirationDate();
      calculateCurrentDayAndMonth();
    });

    return {
      expirationDate,
      currentDay,
      currentDate,
      currentMonth,
      daysInMonth,
    };
  },
};
</script>
