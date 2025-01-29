<template>
  <div>
    <div v-if="loading" class="loading">
      <i class="fas fa-spinner fa-spin"></i>
      Loading users...
    </div>

    <div v-else>
      <h2>User Information</h2>
      <table>
        <thead>
        <tr>
          <th>FULL NAME</th>
          <th>USERNAME</th>
          <th>EMAIL</th>
          <th>ROLE</th>
          <!-- <th>STATUS</th>
          <th>LAST WORKING TIME</th> -->
          <th>ACTION</th>
        </tr>
        </thead>
        <tbody>
        <tr v-for="user in users" :key="user.id">
          <td>
            <div class="user-info">
              <div class="avatar">
                <i class="fas fa-user"></i>
              </div>
              <span class="user-name">{{ user.first_name }} {{ user.last_name }}</span>
            </div>
          </td>
          <td>
            <div class="user-info">
              <span class="user-name">{{ user.username }}</span>
            </div>
          </td>
          <td>{{ user.email }}</td>
          <td>
            {{ user.role }}
          </td>
          <!-- <td>
              <span
                  class="status-icon"
                  :style="{ backgroundColor: getStatusColor(user.role) }"
              ></span>
            {{ user.role == 'admin' ? 'active' : 'inactive' }}
          </td>
          <td>last working time</td> -->
          <td>
            <button @click="toggleDropdown(user.id)" class="clock-button">
              {{ isClockedOut ? 'Clock In' : 'Clock Out' }}
            </button>
            <router-link
                :to="{ name: 'AdminUserWorkingTime', query: { userId: user.id }}"
                class="working-time-link"
            >Show working time</router-link>

            <div v-if="selectedUserId === user.id" class="dropdown-modal">
              <h3>Select Start Time</h3>
              <input type="datetime-local" v-model="selectedTime" />

              <div class="modal-actions">
                <button @click="confirmTime" class="confirm-btn">Confirm</button>
                <button @click="closeDropdown" class="cancel-btn">Cancel</button>
              </div>
            </div>
          </td>
        </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import axios from 'axios';

export default {
  setup() {
    const users = ref([]);
    const loading = ref(true);
    const isClockedOut = ref(false);
    const selectedTime = ref(null);
    const selectedUserId = ref(-1);

    const fetchUsers = async () => {
      try {
        loading.value = true;
        const response = await axios.get('http://localhost:4000/api/users', {
          withCredentials: true,
          headers: {
            'Content-Type': 'application/json',
            'X-XSRF-Token': localStorage.getItem('xsrfToken')
          }
        });
        users.value = response.data;
      } catch (error) {
        console.error('Error fetching users:', error);
      } finally {
        loading.value = false;
      }
    };

    const getStatusColor = (role) => {
      switch (role.toLowerCase()) {
        case "admin":
          return "#8fb67d";
        case "user":
          return "orange";
        default:
          return "gray";
      }
    };

    const toggleDropdown = (userId) => {
      selectedUserId.value = userId;
    };

    const closeDropdown = () => {
      selectedUserId.value = -1;
    };

    const confirmTime = () => {
      if (selectedTime.value) {
        isClockedOut.value = true;
        closeDropdown();
      }
    };

    onMounted(() => {
      fetchUsers();
    });

    return {
      users,
      loading,
      isClockedOut,
      selectedTime,
      selectedUserId,
      getStatusColor,
      toggleDropdown,
      closeDropdown,
      confirmTime
    };
  }
};
</script>

<style scoped>
table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  font-weight: normal;
  padding: 12px;
  text-align: left;
  border: none;
}

th {
  background-color: #f2f2f2;
}

.user-info {
  display: flex;
  align-items: center;
}

.user-name {
  font-weight: bold;
}

.avatar {
  width: 30px;
  height: 30px;
  background-color: #8fb67d;
  border-radius: 50%;
  margin-right: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.avatar i {
  color: white;
  font-size: 16px;
}

.status-icon {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  display: inline-block;
  margin-right: 5px;
}

.clock-button {
  background-color: #8fb67d;
  color: white;
  padding: 8px 9px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  margin-right: 10px;
}

.clock-button:hover {
  background-color: #7cb342;
}

.working-time-link {
  color: #8fb67d;
  text-decoration: none;
  margin-left: 10px;
}

.working-time-link:hover {
  text-decoration: underline;
}

.dropdown-modal {
  background-color: white;
  border: 1px solid #ddd;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  padding: 15px;
  position: absolute;
  margin-top: -120px;
  border-radius: 5px;
  z-index: 100;
}

.modal-actions {
  margin-top: 10px;
}

.modal-actions button {
  margin-right: 10px;
  padding: 6px 12px;
  border-radius: 4px;
  border: none;
  cursor: pointer;
}

.confirm-btn {
  background-color: #8fb67d;
  color: white;
}

.cancel-btn {
  background-color: #dc3545;
  color: white;
}

th:nth-child(1),
td:nth-child(1) {
  width: 15%;
}

th:nth-child(2),
td:nth-child(2) {
  width: 15%;
}

th:nth-child(3),
td:nth-child(3) {
  width: 15%;
}

th:nth-child(4),
td:nth-child(4) {
  width: 10%;
}

th:nth-child(5),
td:nth-child(5) {
  width: 10%;
}

th:nth-child(6),
td:nth-child(6) {
  width: 10%;
}

th:nth-child(7),
td:nth-child(7) {
  width: 15%;
}

.loading {
  text-align: center;
  padding: 20px;
  color: #666;
}

.loading i {
  margin-right: 8px;
  color: #8fb67d;
}
</style>