import { reactive } from 'vue';
const globalState = reactive({
    baseUrl: 'https://testorder.bividvietnam.com',
  permission: [],
  baseApi:'https://portal.bividvietnam.com:63231'
});
export default globalState;
