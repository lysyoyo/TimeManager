<template>
  <div class="register-page">
    <div class="left-section">
      <div class="logo-container">
        <img src="@/assets/logo.png" alt="Logo" class="logo" />
        <h1 class="site-name">Welcome BATMAN</h1>
      </div>
    </div>

    <div class="right-section">
      <CreateNewAccount :registerOrAddNew="true" :isOpen="true"></CreateNewAccount>
    </div>
  </div>
</template>

<script>
import CreateNewAccount from '../components/common/create_new_account.vue';

export default {
  components: {
    CreateNewAccount,
  },
}
</script>
  
  <style scoped>
  .register-page {
    display: flex;
    flex-wrap: wrap;
    font-family: 'Arial', sans-serif;
    margin: 0;
    padding: 0;
    width: 100vw;
    height: 100vh;
    overflow: hidden;
    position: fixed;
    background-image: url('@/assets/horloge.png');
    background-size: cover;
    background-position: center;
  }
  
  /* Section gauche avec le logo */
  .left-section {
    flex: 1;
    background-color: rgba(248, 249, 250, 0.8);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
  }
  
  .logo-container {
    text-align: center;
  }
  
  .logo {
    width: 85%;
    margin-bottom: -150px; 
  }
  
  .site-name {
    font-size: 3rem;
    font-family: 'Cinzel', serif;
    font-weight: 700; 
    font-style: italic; 
    color: #333;
    text-transform: uppercase; 
    letter-spacing: 0.05em; 
  }
  
  /* Section droite avec le formulaire d'inscription */
  .right-section {
    flex: 1;
    background-color: rgba(143, 182, 125, 0.8);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
  }
  
  /* Lien de connexion */
  .login-link {
    text-align: center;
    margin-top: 15px;
    color: #333;
  }
  
  .login-link a {
    color: #8fb67d;
    text-decoration: none;
  }
  
  .login-link a:hover {
    text-decoration: underline;
  }
  
  /* ------ Styles Responsives ------ */
  @media (max-width: 768px) {
    .register-page {
      flex-direction: column;
      height: auto;
    }
  
    .left-section, .right-section {
      width: 100%;
    }
  
    .logo {
      width: 50%;
      margin-bottom: -100px;
    }
  
    .site-name {
      font-size: 1.5rem;
    }
  }
  
  @media (max-width: 480px) {
    .logo {
      width: 40%;
      margin-bottom: -50px;
    }
  
    .site-name {
      font-size: 1.2rem;
    }
  }
  </style>
  