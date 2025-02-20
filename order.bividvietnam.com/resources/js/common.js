import axios from 'axios';
axios.get('/api/user/permissions')
.then(response => {
    permissions.value = response.data;
    console.log(permissions.value);
})
.catch(error => {
    console.error(error.response.data.message);
});
