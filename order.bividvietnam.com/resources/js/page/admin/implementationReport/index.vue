<template>
  <div class="col-md-12">
    <div class="card mb-4">
      <div class="card-body">
        <h2 class="text-primary text-center mt-3">Báo cáo theo dõi bán hàng cận date</h2>
        <div class="row">
          <div class="col-md-3">
            <label for="fromDate" class="form-label">Từ ngày</label>
            <input v-model="selectedDate" class="form-control" type="date" id="fromDate">
          </div>
          <div class="col-md-3">
            <label for="toDate" class="form-label">Đến ngày</label>
            <input v-model="selectedDateEnd" class="form-control" type="date" id="toDate">
          </div>
        </div>
        <div class="row">
          <div class="col-md-3 mt-3 mb-3">
            <button type="button" class="btn btn-outline-danger" @click="getExpirationDate">
              <i class='bx bx-search-alt'></i> Xem kết quả
            </button>
          </div>
        </div>
        
        <div class="table-responsive text-nowrap table-scroll table-px">
          <table class="table table-bordered">
            <thead>
              <tr>
                <th rowspan="2">STT</th>
                <th rowspan="2">Mã vật tư</th>
                <th rowspan="2">Tên vật tư</th>
                <th rowspan="2">Số lô</th>
                <th rowspan="2">Đơn vị tính</th>
                <th rowspan="2">Ngày hết hạn</th>
                <th v-for="day in dateRange" :key="day" colspan="2" class="text-center">{{ day }}</th>
              </tr>
              <tr>
                <template v-for="day in dateRange" :key="day">
                  <th>Kế hoạch</th>
                  <th>Thực hiện</th>
                </template>
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
                <template v-for="day in dateRange" :key="'data-' + day">
                  <td>{{ expirationDates[`sl_ngay_${formatDate(day)}`] || 0 }}</td>
                  <td>{{ expirationDates[`sl_banngay_${formatDate(day)}`] || 0 }}</td>
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
export default defineComponent({
  setup() {
    const expirationDate = ref([]);
    const tokenApi = localStorage.getItem('tokensApi');
    const selectedDate = ref(''); 
    const selectedDateEnd = ref(''); 
    const globalState = inject('globalState');
    const baseApi = globalState.baseApi;
    const baseUrl = globalState.baseUrl;
    const user = ref([]);
    const dateRange = ref([]);

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
          'API': 'True',
        },
      };
      const params = new URLSearchParams();
      if (selectedDate.value) {
        params.append('tu_ngay', selectedDate.value);
      }
      if (selectedDateEnd.value) {
        params.append('den_ngay', selectedDateEnd.value);
      }

      axios
        .get(`${baseApi}/sales/chitieubanhangtonkhocandate/all?ma_sale=hong.nguyenphuong&ma_cty=00${encodeURIComponent(users.company_select)}`, {
          params: params,
          ...axiosConfig,
        })
        .then((response) => {
          expirationDate.value = response.data;
          calculateDateRange();
        })
        .catch((error) => {
          console.log(error);
        });
    };
    const calculateDateRange = () => {
      const start = new Date(selectedDate.value);
      const end = new Date(selectedDateEnd.value);
      const range = [];

      while (start <= end) {
        range.push(start.toLocaleDateString('vi-VN'));
        start.setDate(start.getDate() + 1);
      }
      dateRange.value = range;
    };

    const formatDate = (date) => {
      const d = new Date(date);
      const day = d.getDate().toString().padStart(2, '0');
      const month = (d.getMonth() + 1).toString().padStart(2, '0');
      return `${day}-${month}`;
    };

    onMounted(() => {
      calculateDateRange();
    });

    return {
      expirationDate,
      selectedDate,
      selectedDateEnd,
      getExpirationDate,
      dateRange,
      formatDate,
    };
  },
});
</script>
