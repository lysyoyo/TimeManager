<template>
    <div class="parent">
        <div class="user-stats-card">
        <div v-for="user in users" :key="user.id" class="user-stats">
            <img :src="user.avatar" alt="User Avatar" class="user-avatar" />
            <div class="user-info">
            <div class="username">{{ user.username }}</div>
            <div class="profession">{{ user.profession }}</div>
            </div>
            <div class="user-stats-info">
            <div class="working-time">{{ user.workingTime }} hours</div>
            <div class="user-rating">{{ renderStars(user.rating) }}</div>
            </div>
        </div>
        </div>
    </div>
  </template>
  
  <script>
  export default {
    name: "UserStatsCard",
    data() {
      return {
        users: [
          {
            id: 1,
            avatar: "https://randomuser.me/api/portraits/men/1.jpg",
            username: "John Doe",
            profession: "Software Engineer",
            workingTime: 40,
            rating: 4,
          },
          {
            id: 2,
            avatar: "https://randomuser.me/api/portraits/men/2.jpg",
            username: "Jane Smith",
            profession: "Project Manager",
            workingTime: 35,
            rating: 5,
          },
          {
            id: 3,
            avatar: "https://randomuser.me/api/portraits/men/3.jpg",
            username: "Emily Johnson",
            profession: "UX Designer",
            workingTime: 30,
            rating: 3,
          },
        ],
      };
    },
    methods: {
      renderStars(rating) {
        return Array.from({ length: 5 }, (_, index) => {
          return index < rating ? "★" : "☆";
        }).join("");
      },
    },
  };
  </script>
  
  <style scoped>
  .parent {
    background-color: #f8f9fa;
    border-radius: 20px;
    padding: 20px;
    transition: box-shadow 0.3s ease;
  }
  .user-stats-card {
    max-width: 700px;
    margin: 0 auto;
  }
  
  .user-stats {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 20px 10px;
    border-bottom: 1px solid #eee;
  }
  
  .user-stats:last-child {
    border-bottom: none;
  }
  
  .user-avatar {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    margin-right: 10px;
  }
  
  .user-info {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    flex-grow: 1;
  }
  
  .username {
    font-weight: bold;
  }
  
  .profession {
    color: #666;
  }
  
  .user-stats-info {
    text-align: right;
  }
  
  .working-time {
    margin-bottom: 5px;
    font-size: 17px;
    font-weight: bold;
    color: #8fb67d;
  }
  
  .user-rating {
    color: #ffa500;
  }
  </style>
  