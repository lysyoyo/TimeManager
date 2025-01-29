<template>
  <div class="card-parent">
    <div class="card-container">
      <!-- Card Profil Utilisateur -->
      <div class="card">
        <div class="card-content">
          <span class="card-title">User Profile</span>
          <i class="fas fa-user icon"></i> <!-- Icon utilisateur -->
        </div>
        <p class="card-info">Bruce Wayne</p> <!-- Affiche le nom de l'utilisateur -->
        <p class="card-info">Position: CEO</p>
        <p class="card-info">Total Hours This Month: 120 hours</p>
        <a href="#" class="more-infos">More Infos</a>
      </div>

      <!-- Card Heures Travaillées -->
      <div class="card">
        <div class="card-content">
          <span class="card-title">Working Time</span>
          <i class="fas fa-clock icon"></i> <!-- Icon horloge -->
        </div>
        <p class="card-info">Total Hours This Week: 35 hours</p> <!-- Heures travaillées -->
        <p class="card-info">Remaining to Goal: 5 hours</p> <!-- Objectif restant -->
        <a href="#" class="more-infos">More Infos</a>
      </div>

      <!-- Card Performances -->
      <div class="card">
        <div class="card-content">
          <span class="card-title">Performance</span>
          <i class="fas fa-chart-line icon"></i> <!-- Icon performance -->
        </div>
        <p class="card-info">10% more productivity than last week</p> <!-- Performances personnelles -->
        <p class="card-info">Average Hours Per Day: 7 hours</p>
        <a href="#" class="more-infos">See Detailed Stats</a>
      </div>

      <!-- Card Distribution des Tâches -->
      <div class="card">
        <div class="card-content">
          <span class="card-title">Task Distribution</span>
          <i class="fas fa-tasks icon"></i> <!-- Icon des tâches -->
        </div>
        <p class="card-info">Most time spent on Project A: 40%</p> <!-- Distribution des tâches -->
        <p class="card-info">Project B: 35%, Project C: 25%</p>
        <a href="#" class="more-infos">See More Details</a>
      </div>
    </div>
  </div>
</template>


  
<script>
export default {
  name: "CardUser",
  methods: {
    goToUserList() {
      this.$router.push({ name: 'user-list' }); // Redirection vers la liste des utilisateurs
    },
  },
};
</script>

  
<style scoped>
/* Card Parent : Design global */
.card-parent {
  background-color: white;
  border-radius: 20px;
  padding: 30px;
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
  margin: 20px auto;
  max-width: 1200px;
  transition: box-shadow 0.3s ease;
}

/* Effet au survol du card parent */
.card-parent:hover {
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

/* Conteneur des cartes à l'intérieur du card parent */
.card-container {
  display: grid;
  grid-template-columns: repeat(2, 1fr); /* 2 colonnes pour afficher les cartes en grille */
  gap: 20px;
  margin-top: 20px;
}

/* Style de chaque carte */
.card {
  background-color: #8fb67d;
  border-radius: 10px;
  padding: 20px;
  position: relative;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease, box-shadow 0.3s ease, background-color 0.3s ease;
}

/* Effet hover pour les cartes */
.card:hover {
  transform: translateY(-10px);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
  background-color: #6d8f60;
}

/* Contenu de la carte (titre + icône) */
.card-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

/* Titre de la carte */
.card-title {
  font-size: 18px;
  font-weight: bold;
  color: white;
}

/* Icône de la carte */
.icon {
  color: white;
  font-size: 24px;
}

/* Informations additionnelles dans la carte */
.card-info {
  margin-top: 10px;
  font-size: 14px;
  color: #f0f0f0;
}

/* Lien "More Infos" */
.more-infos {
  display: block;
  margin-top: 10px;
  color: white;
  text-decoration: underline;
  font-weight: bold;
  transition: color 0.3s ease;
}

/* Effet au survol du lien */
.more-infos:hover {
  color: #62b062;
}

/* Responsive : ajustement pour petits écrans */
@media (max-width: 768px) {
  .card-container {
    grid-template-columns: 1fr; /* Une seule colonne sur petits écrans */
  }
}
</style>
