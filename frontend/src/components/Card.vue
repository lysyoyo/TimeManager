<template>
    <div class="card-container">
      <div class="card">
        <div class="card-content">
          <span class="card-title">{{ totalUser }}</span>
          <span class="card-title" v-if="role === 'admin'">Je suis admin</span>
          <i class="fas fa-user icon"></i> <!-- Icon user -->
        </div>
        <a href="/admin/user-list" class="more-infos">More Infos</a>
      </div>
    </div>
</template>

<script>
export default {
  name: "Card",
  props: {
    role: String,
    totalUser: String
  },
  methods: {
    goToUserList() {
      this.$router.push({ name: 'user-list' }); // router à liste user
    },
  },
};
</script>

<style scoped>
.card-container {
  display: flex;
  justify-content: space-around; /* Centrez les 2 cartes */
  margin-top: 20px; /* Distance du haut de la page à la carte */
}

.card {
  background-color: #8fb67d; /* background du card */
  border-radius: 10px; /* Bo tròn viền của card */
  padding: 20px;
  width: 200px; 
  position: relative; /* Để căn icon bên phải */
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2); /* Ombre subtile autour de la carte */
  transition: transform 0.3s ease, box-shadow 0.3s ease; /* Transition pour effet de zoom et ombre */
}

.card:hover {
  transform: scale(1.05); /* Zoom léger sur survol */
  box-shadow: 0px 10px 20px rgba(0, 0, 0, 0.3); /* Ombre plus marquée au survol */
}

.card-content {
  display: flex;
  justify-content: space-between; /* Căn giữa tiêu đề và icon */
  align-items: center; /* Căn giữa theo chiều dọc */
}

.card-title {
  font-size: 18px; 
  color: white; 
}

.icon {
  color: white; 
  font-size: 24px; 
}

.more-infos {
  display: block; /* Để link xuống dòng */
  margin-top: 10px; 
  color: white;
  text-decoration: underline; 
}
</style>
