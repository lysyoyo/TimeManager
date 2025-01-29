<template>
    <div class="user-cards">
        <div class="user-card" v-for="user in sortedUsers" :key="user.id">
        <img :src="user.avatar" alt="User Avatar" class="avatar">
        <p class="user-name">{{ user.fullName }}</p>
        </div>
    </div>
  </template>

  <script>
  import users from '../../assets/data/users.json';

  export default {
    name: "UserList",
    data() {
      return {
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
  .user-cards {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
    gap: 10px;
    width: 100%;
  }

  .user-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    padding: 10px;
    margin: 0 auto;
  }

  .avatar {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    margin-bottom: 10px;
  }

  .user-name {
    font-size: 14px;
    font-weight: bold;
  }
  </style>
