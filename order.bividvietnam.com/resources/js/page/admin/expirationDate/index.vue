<template>
  <div class="col-md-12">
    <div class="card mb-4">
      <div class="card-body">
        <div class="row mb-3">
          <div class="col-md-6">
            <h4 class="fw-bold">Kế hoạch bán hàng cận Date</h4>
          </div>
          <div class="col-md-6">
            <button type="button" @click="printerReport" class="btn btn-outline-danger float-end">
              <i class="bx bx-printer"></i> In 
            </button>
          </div>
        </div>
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
                <th rowspan="2">Chỉ tiêu tháng {{ currentMonth }}</th>
                <th v-for="day in daysInMonth" :key="day" class="text-center">{{ day }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(expirationDates, index) in expirationDate" :key="index">
                <td>{{ index + 1 }}</td>
                <td>{{ expirationDates.ma_vt }}</td>
                <td>{{ expirationDates.ten_vt }}</td>
                <td>{{ expirationDates.ma_lo }}</td>
                <td>{{ expirationDates.dvt }}</td>
                <td>{{ formatDateVN(expirationDates.han_dung) }}</td>
                <td>{{ expirationDates.sl_thang1 }}</td>
                <template v-for="day in daysInMonth" :key="'data-' + day">
                  <td>{{ expirationDates[`sl_banngay${day}`] || ""}}</td>
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
import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';
export default defineComponent({
  setup() {
    const globalState = inject('globalState');
    const baseApi = globalState.baseApi;
    const expirationDate = ref([]);
    const currentDay = ref('');
    const currentDate = ref('');
    const currentMonth = ref('');
    const daysInMonth = ref([]);
    const tokenApi = localStorage.getItem('tokensApi');
    const baseUrl = globalState.baseUrl;
    const user = ref([]);
    const sales = ref([]);

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
      try {
        const users = await fetchUserData();
        const axiosConfig = {
          headers: {
            Authorization: `Bearer ${tokenApi}`,
            'Content-Type': 'application/json; charset=utf-8',
            API: 'True',
          },
        };

        const response = await axios.get(
          `${baseApi}/sales/chitieubanhangtonkhocandate/sale?ma_sale=hong.nguyenphuong&ma_cty=00${encodeURIComponent(
            users.company_select
          )}`,
          axiosConfig
        );

        expirationDate.value = response.data;
        return expirationDate.value;
      } catch (error) {
        console.log(error);
      }
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
    const printerReport = async () => {
      const ma_nv = expirationDate.value[0].ma_sale;
      const ten_nv = expirationDate.value[0].ten_sale;
      const year = new Date().getFullYear();
      const month = currentMonth.value;
      const day = currentDay.value;
      let tableRows = '';
      expirationDate.value.forEach((expirationDates, index) => {
        tableRows += `
          <tr>
            <td style="border: 1px solid #000;
            padding: 8px;
            text-align: center;">${index + 1}</td>
            <td style="border: 1px solid #000;
            padding: 8px;
            text-align: center;">${expirationDates.ma_vt}</td>
            <td class="namevt" style="border: 1px solid #000;
            padding: 8px;
            text-align: center;">${expirationDates.ten_vt}</td>
            <td style="border: 1px solid #000;
            padding: 8px;
            text-align: center;">${expirationDates.ma_lo}</td>
            <td style="border: 1px solid #000;
            padding: 8px;
            text-align: center;">${expirationDates.dvt}</td>
            <td style="border: 1px solid #000;
            padding: 8px;
            text-align: center;">${formatDateVN(expirationDates.han_dung)}</td>
            <td style="border: 1px solid #000;
            padding: 8px;
            text-align: center;">${expirationDates.sl_thang1}</td>
          </tr>
        `;
      });
      const content = `
        <div class="title-report" style="display: flex; flex-wrap: nowrap; justify-content: space-around; align-items: center;">
            <div class="logo" style="width: 20%; margin-left: -100px; text-align: center; margin-bottom: 20px;">
                <img src="/assets/img/avatars/logoo.png" alt="Signature" style="width: 150px;">
            </div>
            <div class="header-center" style="text-align: center;">
                <b>CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</b>
                <p><b>Độc lập – Tự do – Hạnh Phúc</b></p>
                <p><b>*********</b></p>
            </div>
        </div>
        <p style="text-align: end;"><i>TP. Hồ Chí Minh, ngày 1 tháng ${month} năm ${year}</i></p>
        <h1 style="text-align: center;">QUYẾT ĐỊNH</h1>
        <p style="text-align: center;"><i>(V/v: Giao chỉ tiêu bán hàng cận date)</i></p>
        <div style="text-align: center;">Tháng: ${month}</div>
        <div>
            <p><strong>Điều 1:</strong> Giao chỉ tiêu bán hàng cận date tháng ${month} cho nhân viên ${ma_nv} – ${ten_nv} với các nội dung cụ thể như sau:</p>
            <table style="width: 100%; border-collapse: collapse; border: 1px solid #000;">
                <thead style="background-color: #e9ecef;">
                    <tr>
                        <th style="border: 1px solid #000; padding: 8px; text-align: center; background-color: #f4f4f4;">STT</th>
                        <th style="border: 1px solid #000; padding: 8px; text-align: center; background-color: #f4f4f4;">Mã vật tư</th>
                        <th style="border: 1px solid #000; padding: 8px; text-align: center; background-color: #f4f4f4;">Tên vật tư</th>
                        <th style="border: 1px solid #000; padding: 8px; text-align: center; background-color: #f4f4f4;">Số lô</th>
                        <th style="border: 1px solid #000; padding: 8px; text-align: center; background-color: #f4f4f4;">Đơn vị tính</th>
                        <th style="border: 1px solid #000; padding: 8px; text-align: center; background-color: #f4f4f4;">Ngày hết hạn</th>
                        <th style="border: 1px solid #000; padding: 8px; text-align: center; background-color: #f4f4f4;">Chỉ tiêu tháng ${month}</th>
                    </tr>
                </thead>
                <tbody>
                    ${tableRows}
                </tbody>
            </table>
            <p><strong>Điều 2:</strong> Nhân viên ${ma_nv} – ${ten_nv} phải hoàn thành tối thiểu 85% chỉ tiêu đối với từng sản phẩm được giao của tháng. Trường hợp hoàn thành dưới mức tối thiểu sẽ bị chế tài theo quy định của công ty.</p>
            <p><strong>Điều 3:</strong> Giao Ban kiểm tra giám sát thực hiện việc giám sát, hỗ trợ, đôn đốc, nhắc nhở, đánh giá và tổng hợp kết quả hoàn thành của từng nhân viên hàng tuần, hàng tháng.</p>
            <p><strong>Điều 4:</strong> Quyết định có hiệu lực kể từ ngày ký. Nhân viên ${ma_nv} – ${ten_nv}, Quản lý kinh doanh khu vực (ASM), Ban giám đốc kênh bán hàng, Ban kiểm tra giám sát, Phòng hành chính nhân sự và các cán bộ, phòng ban liên quan chịu trách nhiệm thi hành quyết định này.</p>
        </div>
        <div class="footer" style="text-align: end; margin-top: 20px; margin-right: 93px;">
            <h3 style="margin-left: -85px;">TỔNG GIÁM ĐỐC</h3>
            <img src="/assets/img/avatars/chuky21321.png" alt="BIVID Logo" style="width: 150px; margin-right: -70px;">
            <h4 style="margin-right: 24px;">NGÔ ĐỨC BÌNH</h4>
        </div>
      `;
    const printWindow = window.open('', '', 'height=1200,width=800');
        printWindow.document.write(content);
        printWindow.document.close();
        printWindow.print();
    };
    const getSales = async () => {
  try {
    const users = await fetchUserData();
    const axiosConfig = {
      headers: {
        Authorization: `Bearer ${tokenApi}`,
        'Content-Type': 'application/json; charset=utf-8',
        API: 'True',
      },
    };
    const response = await axios.get(
      `${baseApi}/sales/all?ma_cty=00${encodeURIComponent(users.company_select)}`,
      axiosConfig
    );
    sales.value = response.data;
    console.log(sales.value)

    sales.value.forEach(async (sale) => {
      try {
        const employeeResponse = await axios.get(
          `${baseApi}/sales/chitieubanhangtonkhocandate/sale?ma_cty=002&ma_sale=${encodeURIComponent(sale.ma_user)}`,
          axiosConfig
        );

        const { ma_sale: ma_nv, ten_nhanvien: ten_nv } = sale;
        const currentDate = new Date();
        const month = currentDate.getMonth() + 1;
        const year = currentDate.getFullYear();

        const tableRows = employeeResponse.data
          .map((item, index) => `
            <tr>
              <td style="border: 1px solid #000; padding: 8px; text-align: center;">${index + 1}</td>
              <td style="border: 1px solid #000; padding: 8px; text-align: center;">${item.ma_vt}</td>
              <td style="border: 1px solid #000; padding: 8px; text-align: center;">${item.ten_vt}</td>
              <td style="border: 1px solid #000; padding: 8px; text-align: center;">${item.ma_lo}</td>
              <td style="border: 1px solid #000; padding: 8px; text-align: center;">${item.dvt}</td>
              <td style="border: 1px solid #000; padding: 8px; text-align: center;">${formatDateVN(item.han_dung)}</td>
              <td style="border: 1px solid #000; padding: 8px; text-align: center;">${item.sl_thang1}</td>
            </tr>
          `).join('');

        const content = `
          <div class="title-report" style="display: flex; flex-wrap: nowrap; justify-content: space-around; align-items: center;">
            <div class="logo" style="width: 20%; margin-left: -100px; text-align: center; margin-bottom: 20px;">
              <img src="/assets/img/avatars/logoo.png" alt="Signature" style="width: 150px;">
            </div>
            <div class="header-center" style="text-align: center;">
              <b>CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</b>
              <p><b>Độc lập – Tự do – Hạnh Phúc</b></p>
              <p><b>*********</b></p>
            </div>
          </div>
          <p style="text-align: end;"><i>TP. Hồ Chí Minh, ngày 1 tháng ${month} năm ${year}</i></p>
          <h1 style="text-align: center;">QUYẾT ĐỊNH</h1>
          <p style="text-align: center;"><i>(V/v: Giao chỉ tiêu bán hàng cận date)</i></p>
          <div style="text-align: center;">Tháng: ${month}</div>
          <div>
            <p><strong>Điều 1:</strong> Giao chỉ tiêu bán hàng cận date tháng ${month} cho nhân viên ${ma_nv} – ${ten_nv} với các nội dung cụ thể như sau:</p>
            <table style="width: 100%; border-collapse: collapse; border: 1px solid #000;">
              <thead style="background-color: #e9ecef;">
                <tr>
                  <th style="border: 1px solid #000; padding: 8px; text-align: center; background-color: #f4f4f4;">STT</th>
                  <th style="border: 1px solid #000; padding: 8px; text-align: center; background-color: #f4f4f4;">Mã vật tư</th>
                  <th style="border: 1px solid #000; padding: 8px; text-align: center; background-color: #f4f4f4;">Tên vật tư</th>
                  <th style="border: 1px solid #000; padding: 8px; text-align: center; background-color: #f4f4f4;">Số lô</th>
                  <th style="border: 1px solid #000; padding: 8px; text-align: center; background-color: #f4f4f4;">Đơn vị tính</th>
                  <th style="border: 1px solid #000; padding: 8px; text-align: center; background-color: #f4f4f4;">Ngày hết hạn</th>
                  <th style="border: 1px solid #000; padding: 8px; text-align: center; background-color: #f4f4f4;">Chỉ tiêu tháng ${month}</th>
                </tr>
              </thead>
              <tbody>
                ${tableRows}
              </tbody>
            </table>
            <p><strong>Điều 2:</strong> Nhân viên ${ma_nv} – ${ten_nv} phải hoàn thành tối thiểu 85% chỉ tiêu đối với từng sản phẩm được giao của tháng. Trường hợp hoàn thành dưới mức tối thiểu sẽ bị chế tài theo quy định của công ty.</p>
            <p><strong>Điều 3:</strong> Giao Ban kiểm tra giám sát thực hiện việc giám sát, hỗ trợ, đôn đốc, nhắc nhở, đánh giá và tổng hợp kết quả hoàn thành của từng nhân viên hàng tuần, hàng tháng.</p>
            <p><strong>Điều 4:</strong> Quyết định có hiệu lực kể từ ngày ký. Nhân viên ${ma_nv} – ${ten_nv}, Quản lý kinh doanh khu vực (ASM), Ban giám đốc kênh bán hàng, Ban kiểm tra giám sát, Phòng hành chính nhân sự và các cán bộ, phòng ban liên quan chịu trách nhiệm thi hành quyết định này.</p>
          </div>
          <div class="footer" style="text-align: end; margin-top: 20px; margin-right: 93px;">
            <h3 style="margin-left: -85px;">TỔNG GIÁM ĐỐC</h3>
            <img src="/assets/img/avatars/chuky21321.png" alt="BIVID Logo" style="width: 150px; margin-right: 20px;">
            <h4 style="margin-right: 24px;margin-top: 20px;">NGÔ ĐỨC BÌNH</h4>
          </div>
        `;
        await axios.post(
          `${baseUrl}/api/inbox`,
          {
            content,
            ma_sale: sale.ma_user,
          },
        );

        console.log(`Data for ${sale.ma_user} sent to inbox endpoint successfully.`);
      } catch (error) {
        console.error(`Error fetching or sending sales data for ${sale.name}:`, error);
      }
    });

    return sales.value;
  } catch (error) {
    console.error('Error in getSales:', error);
  }
};
const formatDateVN = (dateStr) => {
      const date = new Date(dateStr);
      if (isNaN(date.getTime())) return dateStr; 
      const day = date.getDate();
      const month = date.getMonth() + 1;
      const year = date.getFullYear();
      return `${day}-${month}-${year}`;
    };
    const scheduleMonthlyFunction = () => {
      const now = new Date();
      const nextExecutionDate = new Date(now.getFullYear(), now.getMonth() + 1, 1, 0, 0, 0);
      const timeUntilNextExecution = nextExecutionDate - now;
      setTimeout(() => {
        getSales();
        setInterval(() => {
          getSales();
        }, 30 * 24 * 60 * 60 * 1000); 
      }, timeUntilNextExecution);
      console.log(`Đã lập lịch chạy vào 00:00 ngày 1 của tháng sau: ${nextExecutionDate}`);
    };

    onMounted(() => {
      getExpirationDate();
      calculateCurrentDayAndMonth();
      scheduleMonthlyFunction();
    });

    return {
      expirationDate,
      currentDay,
      currentDate,
      currentMonth,
      daysInMonth,
      printerReport,
      formatDateVN,
    };
  },
});
</script>

<style scoped>
@media print {
  body {
    font-family: Arial, sans-serif;
  }

  .table {
    width: 100%;
    border-collapse: collapse;
  }

  .table th, .table td {
    border: 1px solid #000;
    padding: 8px;
    text-align: center;
  }

  .btn {
    display: none; /* Hide buttons on print */
  }

  .url, .timestamp {
    display: none;
  }
  @page {
    size: A4;
    margin: 20mm;
  }
}

</style>
