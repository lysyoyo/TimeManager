<template>
  <div>
    <div class="dashboard-grid">
      <div>
        <div class="header">Overview</div>
        <UserOverviewCard />
        
      </div>
      <div>
        <div class="header">Top Users</div>
        <UserStatsCard />
        <br><br><br><br>
      </div>
    </div>
  </div>
</template>

<script>
import UserOverviewCard from '../components/admin_overview/UserOverviewCard.vue';
import UserStatsCard from '../components/admin_overview/UserStatsCard.vue';
import StatisticCard from '../components/admin_overview/StatisticCard.vue';

export default {
  name: 'AdminDashboard',
  components: {
    UserOverviewCard,
    UserStatsCard,
    StatisticCard,
  },
};
</script>

<style src="@/assets/AdminDashboard.css"></style>
