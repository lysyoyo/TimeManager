<template>
  <div class="parent">
    <div class="card-grid">
      <div>
        <NumberCard
          id="1"
          title="Active users" 
          number="7780" 
          unit="" 
          :percentage="30"
        />
      </div>
      <div>
        <NumberCard
          id="2"
          title="Total working time" 
          number="1535" 
          unit="hours"
          :percentage="-15"  
        />
      </div>
    </div>
    <div>
      <h2>Statistic</h2>
      <StatisticCard /> 
  </div>
  </div>
</template>

<script>
import users from '../../assets/data/users.json';
import UserList from './UserList.vue';
import NumberCard from './NumberCard.vue';
import StatisticCard from './StatisticCard.vue';

export default {
  name: "UserOverviewCard",
  components: {
    UserList,
    NumberCard,
    StatisticCard,
  },
  data() {
    return {
      totalUsers: 50,
      order: 'alphabet',
      screenWidth: window.innerWidth,
      users: users
    };
  },
  computed: {
    sortedUsers() {
      let sorted = [...this.users];
      if (this.order === 'alphabet') {
        sorted.sort((a, b) => a.fullName.localeCompare(b.fullName));
      } else {
        sorted.sort((a, b) => b.fullName.localeCompare(a.fullName));
      }

      // Return 5 or 10 users based on screen width
      return  this.screenWidth <= 768 ? sorted.slice(0, 4)
        : this.screenWidth <= 1224 ? sorted.slice(0, 6)
        : this.screenWidth <= 1500 ? sorted.slice(0, 8)
        : sorted.slice(0, 10);
    }
  },
  mounted() {
    window.addEventListener('resize', this.updateScreenWidth);
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.updateScreenWidth);
  },
  methods: {
    updateScreenWidth() {
      this.screenWidth = window.innerWidth;
    },
    sortUsers() {
    }
  }
};
</script>

<style scoped>

.parent {
    background-color: #faf8f8;
    border-radius: 20px;
    padding: 20px;
    /* box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2); */
    /* margin: 0px auto; */
    /* max-width: 1200px; */
    transition: box-shadow 0.3s ease;
  }

.card-grid {
  padding: 20px;
  display: grid;
  grid-template-columns: 5fr 5fr;
  gap: 2vw;
}

.user-list-container {
  padding: 30px 10px 10px 10px;
  max-width: 1200px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.right-section {
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
}

.total-users {
  font-size: 28px;
  font-weight: bold;
  margin-bottom: 15px;
  text-align: left;
}

.filter {
  font-size: 14px;
}

.filter label {
  margin-right: 5px;
}

.filter select {
  border-radius: 5px;
}

.see-all-btn {
  padding: 8px 16px;
  background-color: #8fb67d;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 5px;
}

.see-all-btn:hover {
  background-color: #219150;
}

.filter a {
  font-size: 16px;
  font-weight: 500;
  display: block;
  margin-top: 10px; 
  color: rgb(112, 112, 112);
  text-decoration: none;
}

.filter a:hover {
  text-decoration: underline; /* Add underline on hover */
}
</style>
