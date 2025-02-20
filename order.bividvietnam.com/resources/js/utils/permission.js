import axios from 'axios';
export async function fetchUserPermission() {
  try {
    const response = await axios.get('/api/user/permission');
    return response.data.permissions;

  } catch (error) {
    console.error('Error fetching user permissions:', error);
    throw error;
  }
}
