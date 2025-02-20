<template>
    <div class="row">
      <div class="col-md-6">
        <h4 class="fw-bold">
          <span class="text-muted fw-light">
            Đơn hàng Online <i class="bx bx-chevron-right" style="font-size: 40px;"></i>
          </span>
          Danh sách đơn hàng
        </h4>
      </div>
    </div>
    <div class="card">
      <div class="card-header justify-content-between">
        <h5 class="card-title m-0">Saigon</h5>
      </div>
      <div class="card-body">
        <div class="table-responsive text-nowrap mb-4">
          <table class="table table-striped">
            <thead>
              <tr class="text-nowrap alert-secondary">
                <th>#</th>
                <th>Mã đơn hàng</th>
                <th>Khách hàng</th>
                <th>Số điện thoại</th>
                <th>Email</th>
                <th>Trạng thái</th>
                <th>Ngày đặt hàng</th>
                <th>Tổng tiền</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(orderBaoLongs, index) in orderBaoLong" :key="orderBaoLongs.id" @click="showOrderDetails(orderBaoLongs.id)">
                <td>{{ index + 1 }}</td>
                <td class="text-primary">
                  <a
                    href="javascript:void(0);"
                    @click.prevent="showOrderDetails(orderBaoLongs.id)"
                    data-bs-toggle="modal"
                    data-bs-target="#basicModal"
                  >
                    {{ orderBaoLongs.id }}
                  </a>
                </td>

                <td>{{ orderBaoLongs.billing.first_name }} {{ orderBaoLongs.billing.last_name }}</td>
                <td>{{ orderBaoLongs.billing.phone }}</td>
                <td>{{ orderBaoLongs.billing.email }}</td>
                <td v-if="orderBaoLongs.status === 'completed'">Xác nhận</td>
                <td v-if="orderBaoLongs.status === 'processing'"><span class="badge rounded-pill bg-success"> Khởi tạo </span></td>
                <td v-if="orderBaoLongs.status === 'cancelled'">Huỷ</td>
                <td>{{ orderBaoLongs.date_created }}</td>
                <td>{{ formatNumber(orderBaoLongs.total) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    <div class="modal fade" id="basicModal" tabindex="-1" aria-hidden="true" v-if="selectedOrder">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Chi tiết đơn hàng #{{ selectedOrder.id }}</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <p><strong>Khách hàng:</strong> {{ selectedOrder.billing.first_name }} {{ selectedOrder.billing.last_name }}</p>
            <p><strong>Số điện thoại:</strong> {{ selectedOrder.billing.phone }}</p>
            <p><strong>Email:</strong> {{ selectedOrder.billing.email }}</p>
            <p><strong>Địa chỉ:</strong> {{ selectedOrder.billing.address_1 }}</p>
            <p><strong>Thành phố:</strong> {{ selectedOrder.billing.city }}</p>
            <p><strong>Trạng thái:</strong> <span v-if="selectedOrder.status === 'completed'">Xác nhận</span> <span v-if="selectedOrder.status === 'processing'">Khởi tạo</span><span v-if="selectedOrder.status === 'cancelled'">Huỷ</span></p>
            <p><strong>Thanh toán:</strong> {{ selectedOrder.payment_method_title }}</p>
            <p><strong>Ngày đặt hàng:</strong> {{ selectedOrder.date_created }}</p>
            <p><strong>Tổng tiền:</strong> {{ formatNumber(selectedOrder.total) }}</p>
            <table class="table">
              <thead>
                <tr class="text-nowrap alert-secondary">
                  <th>#</th>
                  <th>Sản phẩm</th>
                  <th>Số lượng</th>
                  <th>Giá bán</th>
                  <th>Tổng</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(item, index) in selectedOrder.line_items" :key="item.id">
                  <td>{{ index + 1 }}</td>
                  <td>{{ item.name }}</td>
                  <td>{{ item.quantity }}</td>
                  <td>{{ formatNumber(item.price) }}</td>
                  <td>{{ formatNumber(item.total) }}</td>
                </tr>
              </tbody>
            </table>
            <p><strong>Cập nhật trạng thái đơn hàng:</strong>
                <div class="row mb-3">
                    <label class="col-sm-5 col-form-label" for="basic-default-message">Trạng thái</label>
                    <div class="col-sm-7">
                      <select class="form-select" v-model="statusOrderOnline" id="exampleFormControlSelect1" aria-label="Default select example">
                        <option value="processing">Khởi tạo</option>
                        <option value="completed">Đã hoàn thành</option>
                        <option value="cancelled">Huỷ</option>
                      </select>
                    </div>
                </div>
            </p>
          </div>
          <div class="modal-footer">
            <button type="button" @click="editOrderDetails(selectedOrder.id)" class="btn btn-primary" data-bs-dismiss="modal">Cập nhật</button>
            <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Đóng</button>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  import { defineComponent, ref, onMounted } from 'vue';
  import { useToast } from 'vue-toast-notification';
  
  export default defineComponent({
    setup() {
      const orderBaoLong = ref([]);
      const selectedOrder = ref(null);
      const statusOrderOnline = ref([]); 
      const toast = useToast();
  
      const getOrder = () => {
        axios
          .get(
            `https://saigon24.vn/wp-json/wc/v3/orders?consumer_key=ck_7584421d74166600e5ae60f05d8e8873c63aad44&consumer_secret=cs_4e5009c071b12e12855209fd71685a9e01cff73a`
          )
          .then((response) => {
            orderBaoLong.value = response.data;
          })
          .catch((error) => {
            console.error('Error fetching orders:', error);
          });
      };
  
      const formatNumber = (value) => {
        return new Intl.NumberFormat('vi-VN').format(value);
      };
  
      const showOrderDetails = (orderId) => {
      axios
        .get(
          `https://saigon24.vn/wp-json/wc/v3/orders/${orderId}?consumer_key=ck_7584421d74166600e5ae60f05d8e8873c63aad44&consumer_secret=cs_4e5009c071b12e12855209fd71685a9e01cff73a`
        )
        .then((response) => {
          selectedOrder.value = response.data;
          statusOrderOnline.value = selectedOrder.value.status;
        })
        .catch((error) => {
          console.error('Error fetching order details:', error);
        });
    };

      const editOrderDetails = (orderId) => {
      axios
        .put(
          `https://saigon24.vn/wp-json/wc/v3/orders/${orderId}?consumer_key=ck_7584421d74166600e5ae60f05d8e8873c63aad44&consumer_secret=cs_4e5009c071b12e12855209fd71685a9e01cff73a`,
          {
            status: statusOrderOnline.value, 
          }
        )
        .then((response) => {
          selectedOrder.value = response.data;
          toast.success('Cập nhật trạng thái thành công!'); 
          getOrder(); 
        })
        .catch((error) => {
          console.error('Error updating order status:', error);
          toast.error('Có lỗi xảy ra khi cập nhật trạng thái.');
        });
    };
  
      onMounted(() => {
        getOrder();
      });
  
      return {
        orderBaoLong,
        selectedOrder,
        showOrderDetails,
        formatNumber,
        statusOrderOnline,
        editOrderDetails,
        
      };
    },
  });
  </script>
  