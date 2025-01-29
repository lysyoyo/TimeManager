<template>
  <div class="working-time-container">
    <!-- Section Titre et Explication -->
    <div class="header-section">
      <h1>Working Time Overview</h1>
      <p class="page-description">
        Your working hours will be displayed below once the data is loaded.
      </p>
    </div>

    <!-- Section des Graphiques : ne s'affiche que si les données existent -->
    <div class="charts-section" v-if="dataLoaded">
      <div class="chart-card">
        <h3>Hours Worked Per Day</h3>
        <BarChart :data="barData" :options="chartOptions" />
        <p class="chart-description">
          A bar chart showing the hours worked per day.
        </p>
      </div>

      <div class="chart-card">
        <h3>Cumulative Working Hours</h3>
        <LineChart :data="lineData" :options="chartOptions" />
        <p class="chart-description">
          A line chart visualizing the cumulative working hours.
        </p>
      </div>

      <div class="chart-card">
        <h3>Task Distribution</h3>
        <PieChart :data="pieData" :options="chartOptions" />
        <p class="chart-description">
          A pie chart displaying the distribution of tasks.
        </p>
      </div>
    </div>

    <!-- Bouton de chargement des données -->
    <div class="actions-section">
      <button class="action-button" @click="fetchData">Fetch Data</button>
    </div>
  </div>
</template>

<script>
import { Bar, Line, Pie } from 'vue-chartjs';
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, LineElement, ArcElement, CategoryScale } from 'chart.js';

ChartJS.register(Title, Tooltip, Legend, BarElement, LineElement, ArcElement, CategoryScale);

export default {
  components: {
    BarChart: Bar,
    LineChart: Line,
    PieChart: Pie,
  },
  data() {
    return {
      dataLoaded: false, // Ajout de cette variable pour contrôler l'affichage des graphiques
      barData: {
        labels: [],
        datasets: [{ label: "Hours Worked", backgroundColor: "#42A5F5", data: [] }],
      },
      lineData: {
        labels: [],
        datasets: [{ label: "Cumulative Hours", borderColor: "#FF6384", backgroundColor: "rgba(255,99,132,0.2)", data: [] }],
      },
      pieData: {
        labels: [],
        datasets: [{ label: "Task Distribution", backgroundColor: ["#FF6384", "#36A2EB", "#FFCE56"], data: [] }],
      },
      chartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { position: 'top' } },
      },
    };
  },
  methods: {
    sanitizeData(data) {
      return data.map(label => label.replace(/</g, "&lt;").replace(/>/g, "&gt;"));
    },
    fetchData() {
      setTimeout(() => {
        const fetchedBarData = { labels: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"], data: [8, 7, 8, 6, 7] };
        const fetchedLineData = { labels: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"], data: [8, 15, 23, 29, 36] };
        const fetchedPieData = { labels: ["Project A", "Project B", "Project C"], data: [40, 35, 25] };

        this.barData.labels = this.sanitizeData(fetchedBarData.labels);
        this.barData.datasets[0].data = fetchedBarData.data;

        this.lineData.labels = this.sanitizeData(fetchedLineData.labels);
        this.lineData.datasets[0].data = fetchedLineData.data;

        this.pieData.labels = this.sanitizeData(fetchedPieData.labels);
        this.pieData.datasets[0].data = fetchedPieData.data;

        this.dataLoaded = true;
      }, 1000);
    },
  },
};
</script>

<style scoped>
.working-time-container {
  padding: 20px;
  background-color: #f5f5f5;
}

.header-section {
  text-align: center;
  margin-bottom: 30px;
}

.page-description {
  font-size: 1.2rem;
  color: #555;
}

.charts-section {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
}

.chart-card {
  background-color: #fff;
  padding: 20px;
  margin: 10px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  width: 30%;
}

.chart-card h3 {
  font-size: 1.5rem;
  margin-bottom: 10px;
  color: #333;
}

.chart-description {
  font-size: 0.9rem;
  color: #777;
  margin-top: 10px;
}

.actions-section {
  margin-top: 30px;
  text-align: center;
}

.action-button {
  background-color: #42A5F5;
  color: white;
  border: none;
  padding: 10px 20px;
  font-size: 1rem;
  border-radius: 5px;
  margin: 10px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.action-button:hover {
  background-color: #1E88E5;
}
</style>
