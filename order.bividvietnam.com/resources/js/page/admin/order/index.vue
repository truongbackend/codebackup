<template>
    <div class="row">
        <div class="col-md-6">
            <h4 class="fw-bold">
                <span class="text-muted fw-light">Đơn hàng <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Danh sách đơn hàng
            </h4>
        </div>
        <div class="col-md-6" v-if="hasPermission('order.create')">
            <router-link :to="{ name: 'sop' }">
                <button type="button" class="btn btn-primary float-end"> <i class='bx bx-plus'></i>Thêm đơn
                    hàng</button>
            </router-link>
        </div>
    </div>
    <div class="card">
        <div class="card-header">
            <div class="input-group input-group-merge">
                <span class="input-group-text" id="basic-addon-search31"><i class="bx bx-search"></i></span>
                <input class="form-control" id="html5-search-input" v-model="searchKeyword" type="text" placeholder="Hãy nhập thông tin tìm kiếm...">
            </div>
            <div class="row mt-3">
                <div class="col-md-3">
                    <button type="button" class="btn btn-outline-danger" @click="searchOrder">
                        <i class='bx bx-search-alt'></i> Xem kết quả
                    </button>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive text-nowrap mb-4">
                <table class="table table-striped">
                    <thead>
                        <tr class="text-nowrap alert-secondary">
                            <th>#</th>
                            <th>Mã đơn hàng</th>
                            <th>Khách hàng</th>
                            <th>Người đặt</th>
                            <th>Khu vực</th>
                            <th>Trạng thái</th>
                            <th>Ngày đặt hàng</th>
                            <th>Tổng tiền</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(order, index) in order" :class="{ 'fw-bold': order.order_status === 1 }">
                            <td>{{ index + 1 }}</td>
                            <td>
                                <router-link :to="{ name: 'admin-order-update', params: { id: order.ID } }">{{ order.output_code }}</router-link>
                            </td>
                            <td class="formart-customer">{{ customer.find(x => x.ID == order.customer_id)?.customer_name }}</td>
                            <td>{{ users.find(x => x.id == order.user_init)?.display_name }}</td>
                            <td>{{ stores.find(x => x.ID == order.store_id)?.store_name }}</td>
                            <td>
                                <span class="badge rounded-pill bg-success" v-if="order.order_status === 1">
                                    Khởi tạo
                                </span>
                                <span class="badge rounded-pill bg-primary" v-if="order.order_status === 2">
                                    Xác nhận
                                </span>
                                <span class="badge rounded-pill bg-danger" v-if="order.order_status === 3">
                                    Huỷ
                                </span>
                                <span class="badge rounded-pill bg-warning" v-if="order.order_status === 5">
                                    Đang xử lý
                                </span>
                            </td>
                            <td>{{ formatDate(order.created) }}</td>
                            <td>{{ formatNumber(order.total_money) }}</td>
                            <td>
                                <div class="dropdown">
                                    <router-link :to="{ name: 'admin-order-update', params: { id: order.ID } }">
                                        <i class="bx bxs-edit text-dark"></i>
                                    </router-link>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-end pagination-reponsive">
                    <li class="page-item prev">
                        <a class="page-link" href="javascript:void(0);" @click="changePage('first')">
                            <i class="tf-icon bx bx-chevrons-left"></i>
                        </a>
                    </li>
                    <li class="page-item prev">
                        <a class="page-link" href="javascript:void(0);" @click="changePage(currentPage - 1)"><i class="tf-icon bx bx-chevron-left"></i></a>
                    </li>
                    <li v-for="page in displayedPages" :key="page" class="page-item" :class="{ active: page === currentPage }">
                        <a class="page-link" href="javascript:void(0);" @click="changePage(page)">{{ page }}</a>
                    </li>
                    <li class="page-item next">
                        <a class="page-link" href="javascript:void(0);" @click="changePage(currentPage + 1)"><i class="tf-icon bx bx-chevron-right"></i></a>
                    </li>
                    <li class="page-item next">
                        <a class="page-link" href="javascript:void(0);" @click="changePage('last')">
                            <i class="tf-icon bx bx-chevrons-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
    </template>
<script>
import axios from 'axios';
import { defineComponent, ref, computed, onMounted } from 'vue';
import { useToast } from 'vue-toast-notification';
import { inject } from 'vue';
import { fetchUserPermission } from '@/utils/permission.js';
import printJS from 'print-js';

export default defineComponent({
  setup() {
    const userPermission = ref([]);
    const toast = useToast();
    const globalState = inject('globalState');
    const baseUrl = globalState.baseUrl;
    const searchKeyword = ref('');
    const currentPage = ref(1);
    const customer = ref([]);
    const itemsPerPage = 10;
    const users = ref([]);
    const stores = ref([]);
    const order = ref([]);
    const status = ref([]);
    const template = ref([]);
    let totalPages = ref(0);
    const maxDisplayedPages = 4;
    const maxDisplayedLeft = Math.floor(maxDisplayedPages / 2);
    const maxDisplayedRight = Math.ceil(maxDisplayedPages / 2);
    const displayedPages = computed(() => {
      let startPage = Math.max(currentPage.value - maxDisplayedLeft, 1);
      let endPage = Math.min(currentPage.value + maxDisplayedRight, totalPages.value);
      if (endPage - startPage + 1 < maxDisplayedPages) {
        if (currentPage.value <= maxDisplayedLeft) {
          endPage = Math.min(endPage + maxDisplayedPages - (endPage - startPage + 1), totalPages.value);
        } else {
          startPage = Math.max(startPage - (maxDisplayedPages - (endPage - startPage + 1)), 1);
        }
      }
      return Array.from({ length: endPage - startPage + 1 }, (_, i) => startPage + i);
    });

    const getOrder = () => {
      axios
        .get(`${baseUrl}/api/order`, {
          params: {
            page: currentPage.value,
            per_page: itemsPerPage,
            keyword: searchKeyword.value,
          },
        })
        .then((response) => {
          order.value = response.data.order.data;
          customer.value = response.data.customer;
          totalPages.value = response.data.order.last_page;
          stores.value = response.data.stores;
          users.value = response.data.users;
          status.value = response.data.status;
        })
        .catch((error) => {
          console.log(error);
        });
    };

    const formatNumber = (value) => {
      if (value !== undefined && value !== null) {
        return new Intl.NumberFormat('vi-VN').format(value);
      } else {
        return '';
      }
    };
    const changePage = (page) => {
      if (page === 'first') {
        currentPage.value = 1;
      } else if (page === 'last') {
        currentPage.value = totalPages.value;
      } else if (page >= 1 && page <= totalPages.value) {
        currentPage.value = page;
      }
      getOrder();
    };
    onMounted(async () => {
      try {
        userPermission.value = await fetchUserPermission();
      } catch (error) {
        console.error('Error fetching user roles:', error);
      }
      getOrder();
    });
    function hasPermission(args) {
      return Object.values(userPermission.value).includes(args);
    }
    const formatDate = (dateString) => {
      const date = new Date(dateString);
      const day = String(date.getDate()).padStart(2, '0');
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const year = date.getFullYear();
      const hours = String(date.getHours()).padStart(2, '0');
      const minutes = String(date.getMinutes()).padStart(2, '0');
      const seconds = String(date.getSeconds()).padStart(2, '0');
      return `${day}-${month}-${year} ${hours}:${minutes}:${seconds}`;
    };
    return {
      order,
      searchKeyword,
      currentPage,
      displayedPages,
      changePage,
      customer,
      stores,
      users,
      status,
      template,
      hasPermission,
      formatNumber,
      searchOrder: getOrder,
      formatDate,
    };
  },
});
</script>
