<template>
  <div>
    <Bar 
      v-if="chartData" 
      :data="chartData" 
      :options="chartOptions" 
    />
  </div>
</template>

<script>
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
} from 'chart.js';

import { Bar } from 'vue-chartjs';

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);

export default {
  name: "StatisticCard",
  components: {
    Bar,
  },
  data() {
    return {
      chartData: null,
      chartOptions: {
        responsive: true,
        plugins: {
          legend: {
            display: true,
            position: 'top',
          },
          title: {
            display: true,
            // text: 'Weekly Statistics',
          },
        },
        scales: {
          x: {
            title: {
              display: true,
              // text: 'Weeks',
            },
          },
          y: {
            title: {
              display: true,
              // text: 'Values',
            },
          },
        },
      },
    };
  },
  mounted() {
    this.chartData = {
      labels: ["Week 1", "Week 2", "Week 3", "Week 4"],
      datasets: [
        {
          label: "Activity",
          backgroundColor: "#8fb67d",
          data: [12, 19, 3, 5],
        },
        {
          label: "Active users",
          backgroundColor: "#999999",
          data: [2, 3, 20, 8],
        },
        {
          label: "Working duration",
          backgroundColor: "#bfcfb7",
          data: [3, 10, 13, 15],
        },
      ],
    };
  },
};
</script>

<style scoped>
</style>
