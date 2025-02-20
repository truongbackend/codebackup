import axios from 'axios';

export async function fetchUserRoles() {
  try {
    const response = await axios.get('/api/user/roles');
    return response.data.roles;
  } catch (error) {
    console.error('Error fetching user roles:', error);
    throw error;
  }
}
