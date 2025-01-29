<template>
  <div>
    <div v-if="currentUser" class="user-info">
      <div class="user-info">
        <div class="avatar">
          <i class="fas fa-user"></i>
        </div>
        <span class="font-bold">{{ currentUser.username }} - {{ currentUser.first_name }} {{ currentUser.last_name }}</span>
      </div>
      <div>
        <div v-if="!showModalAddWorkingTime">
          <button @click="toggleDropdown()" class="new-working-time-btn">
            + New Working Time
          </button>
        </div>
        <div v-if="showModalAddWorkingTime" class="dropdown-modal">
          <h3>Select Working Time</h3>
          <span class="font-bold">Start time</span> <input type="datetime-local" v-model="selectedStartTime" />
          <br>
          <span class="font-bold">End time</span> <input type="datetime-local" v-model="selectedEndTime" :min="minEndDate" />
          <div class="modal-actions">
            <button @click="confirmWorkingTime" class="confirm-btn">Confirm</button>
            <button @click="closeDropdown" class="cancel-btn">Cancel</button>
          </div>
        </div>
      </div>
    </div>

    <div v-if="workingTimesData">
      <table>
        <thead>
          <tr>
            <th>Date range</th>
            <th>Starting Time</th>
            <th>Ending Time</th>
            <th>Duration (hours)</th>
            <th>Added at</th>
            <th>Updated at</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(entry, index) in workingTimesData" :key="index">
            <td><div class="font-bold">{{ formatDateRange(entry.start, entry.end) }}</div></td>
            <td><div class="font-bold">{{ formatDate(entry.start) }}</div></td>
            <td><div class="font-bold">{{ formatDate(entry.end) }}</div></td>
            <td><div class="font-bold">{{ calculateDuration(entry.start, entry.end) }}</div></td>
            <td>{{ formatDate(entry.inserted_at) }}</td>
            <td>{{ formatDate(entry.updated_at) }}</td>
            <td>
              <button @click="toggleEditDropdown(entry.id, entry.start, entry.end)" class="clock-button">
                Edit
              </button>
              <div v-if="selectedWorkingTimeId === entry.id" class="dropdown-modal">
                <h3>Select Working Time</h3>
                <span class="font-bold">Start time</span> <input type="datetime-local" v-model="selectedStartTime" />
                <br>
                <span class="font-bold">End time</span> <input type="datetime-local" v-model="selectedEndTime"  :min="minEndDate"/>
                <div class="modal-actions">
                  <button @click="confirmEditWorkingTime" class="confirm-btn">Confirm</button>
                  <button @click="closeEditDropdown" class="cancel-btn">Cancel</button>
                </div>
              </div>  
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="grid-container">
        <div v-if="chartWeeklyStartEndData" class="grid-item">
          <p class="font-bold">Start Time and End Time</p>
          <line-chart :data="chartWeeklyStartEndData" :chart-options="chartOptions"></line-chart>
        </div>

        <div v-if="chartWeeklyTotalData" class="grid-item">
          <p class="font-bold">Total working time</p>
          <Bar :data="chartWeeklyTotalData" :options="taskChartOptions" />
        </div>

        <!-- <div class="grid-item  pie-chart">
          <p>Chart</p>
          <Pie :data="pieChartData" :options="pieChartOptions" />
        </div> -->
      </div>
  </div>
</template>

<script>
import { ref, watch, computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import axios from 'axios';
import { Line, Bar, Pie   } from 'vue-chartjs';
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  LineElement,
  BarElement,
  ArcElement,
  CategoryScale,
  LinearScale,
  PointElement
} from 'chart.js';

ChartJS.register(Title, Tooltip, Legend, LineElement, CategoryScale, LinearScale, PointElement, BarElement, ArcElement);

export default {
  name: 'WorkingTime',
  components: {
    'line-chart': Line,
    Bar,
    Pie,
  },
  setup() {
    const route = useRoute();
    const currentUserId = ref(route.query.userId);
    const currentUser = ref(null);
    const workingTimesData = ref(false);
    const showModalAddWorkingTime = ref(false);
    const selectedWorkingTimeId = ref(-1);
    const selectedStartTime = ref(null);
    const selectedEndTime = ref(null);
    const chartWeeklyTotalData = ref(false);
    const chartWeeklyStartEndData = ref(false);
    const loading = ref(true);

    // Does not work
    const minEndDate = computed(() => {
      if (!selectedStartTime.value) return null;
      return new Date(selectedStartTime.value).toISOString().slice(0, 16);
    });

    const formatDate = (dateStr) => {
      const date = new Date(dateStr);
      const pad = (num) => String(num).padStart(2, '0');

      const year = date.getFullYear();
      const month = pad(date.getMonth() + 1);
      const day = pad(date.getDate());
      const hours = pad(date.getHours());
      const minutes = pad(date.getMinutes());
      const seconds = pad(date.getSeconds());

      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    };

    const fetchUser = async () => {
      try {
        loading.value = true;
        const response = await axios.get(`http://localhost:4000/api/users/${currentUserId.value}`, {
          withCredentials: true,
          headers: {
            'Content-Type': 'application/json',
            'X-XSRF-Token': localStorage.getItem('xsrfToken')
          }
        });
        currentUser.value = response.data;
      } catch (error) {
        console.error('Error fetching users:', error);
      } finally {
        loading.value = false;
      }
    };

    const fetchWorkingTimes = async () => {
      try {
        const response = await axios.get(`http://localhost:4000/api/workingtime/${currentUserId.value}`, {
          withCredentials: true,
          headers: {
            'Content-Type': 'application/json',
            'X-XSRF-Token': localStorage.getItem('xsrfToken')
          }
        });
        workingTimesData.value = response.data;
      } catch (error) {
        console.error('Error fetching users:', error);
      } finally {
        refreshWeeklyWorkingData();
      }
    };

    watch(selectedStartTime, (newStartTime) => {
      if (newStartTime && selectedEndTime.value) {
        const start = new Date(newStartTime);
        const end = new Date(selectedEndTime.value);

        if (end <= start) {
          const newEnd = new Date(start.getTime() + 60 * 60 * 1000);
          selectedEndTime.value = newEnd.toISOString().slice(0, 16); // Format for datetime-local
        }
      }
    });

    watch(selectedEndTime, (newEndTime) => {
      if (newEndTime && selectedStartTime.value) {
        const start = new Date(selectedStartTime.value);
        const end = new Date(newEndTime);
        if (end <= start) {
          const adjustedEnd = new Date(start.getTime());
          selectedEndTime.value = adjustedEnd.toLocaleString('sv-SE', { timeZone: 'Europe/Paris' }).replace(' ', 'T');
        }
      }
    });

    const addNewWorkingTime = async (start, end) => {
      try {
        loading.value = true;
        const formattedStart = formatDate(start);
        const formattedEnd = formatDate(end);

        const response = await axios.post(
          `http://localhost:4000/api/workingtime/${currentUserId.value}`,
          {
            start: formattedStart,
            end: formattedEnd,
          },
          {
            withCredentials: true,
            headers: {
              'Content-Type': 'application/json',
              'X-XSRF-Token': localStorage.getItem('xsrfToken')
            }
          }
        );
      } catch (error) {
        console.error('Error adding working time:', error);
      } finally {
        loading.value = false;
        fetchWorkingTimes();
      }
    };

    const editWorkingTime = async (wkId, start, end) => {
      try {
        loading.value = true;
        const formattedStart = formatDate(start);
        const formattedEnd = formatDate(end);

        const response = await axios.get(
          `http://localhost:4000/api/workingtime/${wkId}/edit`,
          {
            start: formattedStart,
            end: formattedEnd,
          },
          {
            withCredentials: true,
            headers: {
              'Content-Type': 'application/json',
              'X-XSRF-Token': localStorage.getItem('xsrfToken')
            }
          }
        );
      } catch (error) {
        console.error('Error adding working time:', error);
      } finally {
        loading.value = false;
        fetchWorkingTimes();
      }
    };

    // Add new working time
    const toggleDropdown = () => {
      showModalAddWorkingTime.value = true;
    };

    const closeDropdown = () => {
      showModalAddWorkingTime.value = false;
    };

    const confirmWorkingTime = () => {
      if (selectedStartTime.value != null && selectedEndTime.value != null) {
        addNewWorkingTime(selectedStartTime.value, selectedEndTime.value);
        closeDropdown();
      }
    };

    // Edit working time
    const toggleEditDropdown = (wkId, startTime, endTime) => {
      selectedWorkingTimeId.value = wkId;
      selectedStartTime.value = startTime;
      selectedEndTime.value = endTime;
    };

    const closeEditDropdown = () => {
      selectedWorkingTimeId.value = -1;
      selectedStartTime.value = null;
      selectedEndTime.value = null;
    };

    const confirmEditWorkingTime = () => {
      if (selectedWorkingTimeId.value > 0 && selectedStartTime.value != null && selectedEndTime.value != null) {
        editWorkingTime(selectedWorkingTimeId.value, selectedStartTime.value, selectedEndTime.value);
        closeEditDropdown();
      }
    };


    //
    const calculateDuration = (start, end) => {
      const startDate = new Date(start);
      const endDate = new Date(end);
      const durationMs = endDate - startDate;
      const durationHours = durationMs / (1000 * 60 * 60);
      return durationHours.toFixed(0);
    };

    // Function to format date range (e.g., "2024-10-18 -> 2024-10-19" or "2024-10-18" if the same day)
    const formatDateRange = (start, end) => {
      const startDate = new Date(start);
      const endDate = new Date(end);

      const formatDate = (date) => {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
      };

      const formattedStart = formatDate(startDate);
      const formattedEnd = formatDate(endDate);

      if (formattedStart === formattedEnd) {
        return formattedStart;
      }

      return `${formattedStart} - ${formattedEnd}`;
    };

    // chart 2
    function getLast7Days() {
      const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
      const last7Days = [];
      
      const currentDate = new Date();

      for (let i = 0; i < 7; i++) {
        const date = new Date(currentDate);
        date.setDate(currentDate.getDate() - i);
        
        const dayOfWeek = daysOfWeek[date.getDay()];
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        
        last7Days.push(`${dayOfWeek} ${day}-${month}`);
      }

      return last7Days.reverse();
    }

    const refreshWeeklyWorkingData = () => {
      const labels = getLast7Days();
      const weeklyData = Array(7).fill(0);
      const weeklyStartData = Array(7).fill(25);
      const weeklyEndData = Array(7).fill(-1);

      const startDate = new Date();
      startDate.setHours(0, 0, 0, 0);
      startDate.setDate(startDate.getDate() - 6);

      const endDate = new Date();
      endDate.setHours(24, 0, 0, 0);
      endDate.setDate(endDate.getDate() - 6);

      if (workingTimesData.value) {
        for (let i = 0; i < 7; i++) {
          workingTimesData.value.forEach((wkTime) => {
            const startTime = new Date(wkTime.start);
            const endTime = new Date(wkTime.end);
            if (startTime < endDate && endTime > startDate) {
              const startOk = startTime > startDate ? startTime : startDate;
              const endOk = endTime < endDate ? endTime : endDate;
              const durationInHours = parseFloat(((endOk - startOk) / (1000 * 60 * 60)).toFixed(2));
              weeklyData[i] += durationInHours;
              //
              const startOkDecimal = parseFloat((startOk.getHours() + startOk.getMinutes() / 60).toFixed(2));
              if (weeklyStartData[i] > startOkDecimal)
              {
                weeklyStartData[i] = startOkDecimal;
              }
            }
          });
          startDate.setDate(startDate.getDate() + 1);
          endDate.setDate(endDate.getDate() + 1);
        }
      }
      
      for (let i = 0; i < 7; i++) {
        if (weeklyStartData[i] > 24) {
          weeklyStartData[i] = 0;
        }
        weeklyEndData[i] = (weeklyData[i] || 0) + (weeklyStartData[i] || 0);
        if (weeklyEndData[i] > 24) {
          weeklyEndData[i] = 24;
        }
      }

      chartWeeklyTotalData.value = {
        labels,
        datasets: [
          {
            label: 'Total Working Hours',
            data: weeklyData,
            backgroundColor: '#afc8a3',
          },
        ],
      };

      chartWeeklyStartEndData.value = {
        labels,
        datasets: [
          {
            label: 'Start Time',
            data: weeklyStartData,
            borderColor: '#6DBF43',
            backgroundColor: '#6DBF43',
            fill: false,
            pointBackgroundColor: '#6DBF43',
            pointBorderColor: '#6DBF43',
            tension: 0.8,
          },
          {
            label: 'End Time',
            data: weeklyEndData,
            borderColor: '#999999',
            backgroundColor: '#999999',
            fill: false,
            pointBackgroundColor: '#999999',
            pointBorderColor: '#999999',
            tension: 0.2,
          },
        ],
      };
    };
  
    onMounted(() => {
      fetchUser();
      fetchWorkingTimes();
    });


    return {
      currentUserId,
      currentUser,
      workingTimesData,
      loading,
      showModalAddWorkingTime,
      selectedWorkingTimeId,
      selectedStartTime,
      selectedEndTime,
      minEndDate,
      chartWeeklyTotalData,
      chartWeeklyStartEndData,
      formatDate,
      calculateDuration,
      formatDateRange,
      toggleDropdown,
      closeDropdown,
      confirmWorkingTime,
      toggleEditDropdown,
      closeEditDropdown,
      confirmEditWorkingTime
    };
  },
  data() {
    return {
      chartOptions: {
        responsive: true,
        scales: {
          x: {
            title: {
              display: false,
              text: 'Last 7 days',
            },
          },
          y: {
            title: {
              display: true,
              text: 'Time (hours)',
            },
            min: 0,
            max: 24,
            ticks: {
              stepSize: 1,
            },
          },
        },
        plugins: {
          legend: {
            position: 'top',
          },
        },
      },

      taskChartOptions: {
        responsive: true,
        scales: {
          x: {
            title: {
              display: false,
              text: 'Last 7 days',
            },
          },
          y: {
            title: {
              display: true,
              text: 'Duration (hours)',
            },
            min: 0,
            ticks: {
              stepSize: 1,
            },
          },
        },
        plugins: {
          legend: {
            display: false,
          },
          tooltip: {
            callbacks: {
              label: (context) => `Total working time: ${context.raw}`,
            },
          },
        },
      },
       pieChartData: {
        labels: ['Working Days', 'Weekends', 'Paid Leave'],
        datasets: [
          {
            data: [22, 8, 2],
            backgroundColor: ['#afc8a3', '#999999', '#cccccc'],
          },
        ],
      },

      pieChartOptions: {
        responsive: true,
        plugins: {
          legend: {
            position: 'top',
          },
          tooltip: {
            callbacks: {
              label: (context) => `${context.label}: ${context.raw} days`,
            },
          },
        },
      },
    };
  },
}
</script>

<style scoped>
/*  */
.user-info {
  display: flex;
  align-items: center;
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


.font-bold {
  font-weight: bold;
}

.new-working-time-btn {
  position: absolute;
  right: 0;
  padding: 8px 12px;
  background-color: #8fb67d;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

/* modal edit working time */
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

/* modal add working time */
.dropdown-modal {
  right: 0;
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

/*  */
table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
}

th, td {
  padding: 8px;
  text-align: center;
  border: 1px solid #ddd;
}

th {
  background-color: #f4f4f4;
}

.grid-container {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  margin-top: 20px;
  justify-content: center;
  align-items: center;
}

.grid-item {
  max-width: 40vw;
  min-width: 32vw;
  margin: 0 auto;
}

.grid-item.pie-chart {
  max-width: 430px;
  margin: 0 auto;
}

.line-chart {
  max-width: 100%;
  margin: 0 auto;
}

.bar-chart {
  max-width: 600px;
  margin: 0 auto;
}

.user-info {
  display: flex;
  align-items: center;
  position: relative;
  margin-bottom: 20px;
}

.avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  margin-right: 10px;
}

</style>
