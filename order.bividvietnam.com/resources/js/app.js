import './bootstrap';
import { createApp, onMounted } from "vue";
import App from './App.vue';
import globalState from './api.js';
import router from './router/index.js'
import axios from 'axios';
import VueToast from 'vue-toast-notification';
import 'vue-toast-notification/dist/theme-sugar.css';
import CKEditor from '@ckeditor/ckeditor5-vue';
import PrimeVue from 'primevue/config';
import MultiSelect from 'primevue/multiselect';
import 'primevue/resources/themes/aura-light-green/theme.css';
import "primevue/resources/primevue.min.css"; 
import "primeicons/primeicons.css";
import { TreeViewPlugin } from '@syncfusion/ej2-vue-navigations';
import '@syncfusion/ej2-base/styles/material.css';
import '@syncfusion/ej2-vue-navigations/styles/material.css';
import '@syncfusion/ej2-inputs/styles/material.css';
import '@syncfusion/ej2-buttons/styles/material.css';
import 'vue-search-select/dist/VueSearchSelect.css';
window.axios = axios;
axios.interceptors.response.use(
    response => {
        return response;
    },
    error => {
        if (error.response.status === 403) {
            router.push('/login');
        }
        return Promise.reject(error);
    }
);
axios.interceptors.request.use(config => {
    const token = localStorage.getItem('token');
    if (token !== undefined && token !== "" && token !== null) {
        var api = config.headers['API'];
        if (api == 'True') {
            return config;
        }
        config.headers['Authorization'] = `Bearer ${token}`;
    }
    return config;
}, error => {
    return Promise.reject(error);
});
const app =  createApp(App);
app.component('MultiSelect', MultiSelect);
app.use( CKEditor );
app.provide('globalState', globalState);
app.use(router);
app.use(PrimeVue);
app.use(TreeViewPlugin);
app.use(VueToast);
app.mount("#app");
window.app = app;
