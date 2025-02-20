import { reactive } from 'vue';
const globalState = reactive({
  baseUrl: 'http://192.168.1.128:8000',
  permission: [],
  baseApi:'http://192.168.1.101'
});
export default globalState;
