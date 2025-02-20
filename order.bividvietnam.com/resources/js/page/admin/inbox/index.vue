<template>
  <div class="col-md-12">
    <h4 class="fw-bold py-3 mb-4">
          <span class="text-muted fw-light">Danh sách/</span> Quyết định 
      </h4>
      <div class="card mb-4">
        <div class="table-responsive text-nowrap">
          <div class="card-body">
            <div class="table-responsive text-nowrap mb-4">
                <table class="table table-striped">
                    <thead>
                        <tr class="text-nowrap alert-secondary">
                            <th>STT</th>
                            <th>Tiêu đề</th>
                            <th>Ngày gửi</th>
                            <th>Người gửi</th>
                        </tr>
                    </thead>
                    <tbody>
                      <tr v-for="(boxInboxs, index) in boxInbox" :key="index">
                        <td>{{ index+1 }}</td>
                        <td>
                          <router-link :to="{ name: 'admin-inbox-edit', params: { id: boxInboxs.id } }">{{ boxInboxs.name }}</router-link>
                        </td>
                        <td>
                          {{boxInboxs.date }}
                        </td>
                        <td>
                          Ngô Đức Bình
                        </td>
                      </tr>
                    </tbody>
                </table>
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
    ref,
    onMounted,
    watchEffect,
    computed
} from 'vue';
import {
    inject
} from 'vue';
import { ModelListSelect } from 'vue-search-select';
export default {
    components: {
        ModelListSelect,
    },
    setup() {
      const boxInbox = ref([]);
      const globalState = inject('globalState');
      const baseUrl = globalState.baseUrl;
      const getInbox = () => {
            axios
                .get(`${baseUrl}/api/inbox`)
                .then((response) => {
                  boxInbox.value = response.data.inbox;   
                })
                .catch((error) => {
                    console.log(error);
                });
        };
        onMounted(() => {
          getInbox();
        });
        return {
          boxInbox,

        };
    }
    
  }
  
  
  </script>
  