<template>
  <div class="sidebar-container">
    <div class="sidebar">
      <div class="sidebar-header">
        <img src="@/assets/logo.png" alt="Logo" class="site-logo" />
        <h1 class="site-name">BATMAN - User</h1>
      </div>

      <ul class="menu-list">
        <li
            v-for="(item, index) in menuItems"
            :key="index"
            :class="{ active: activeItem === index }"
            @click="selectItem(index, item.route)"
            class="menu-item"
        >
          <span class="icon">
            <i :class="item.icon"></i>
          </span>
          <span class="menu-text">{{ item.name }}</span>
        </li>
        <hr class="divider">
        <li
            :class="{ active: activeItem === 'logout' }"
            @click="handleLogout"
            class="menu-item"
        >
          <span class="icon"><i class="fas fa-sign-out-alt"></i></span>
          <span class="menu-text">Logout</span>
        </li>
      </ul>
    </div>

    <div class="content">
      <div class="page-header">
        <h2>{{ pageTitle }}</h2>
        <hr class="page-title-divider">
      </div>
      <CardUser v-if="$route.path === '/user/dashboard'" />
      <router-view />
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuth } from '@/composables/useAuth';
import CardUser from '../components/CardUser.vue';
import UserHeader from "../components/UserHeader.vue";
import UserContent from "../components/UserContent.vue";

export default {
  data() {
    return {
      activeItem: 0,
      menuItems: [
        { name: "Dashboard", route: "/user/dashboard" },
        { name: "Profile", route: "/user/profile" },
        { name: "Working Time", route: "/user/WorkingTime" },
      ],
    };
  },
  computed: {
    iconClasses() {
      return {
        "Dashboard": "fas fa-home",
        "Profile": "fas fa-user",
        "Working Time": "fas fa-clock"
      };
    }
  },
  name: "UserLayout",
  components: {
    CardUser,
    UserHeader,
    UserContent,
  },
  setup() {
    const router = useRouter();
    const { logout } = useAuth();

    const activeItem = ref(0);
    const menuItems = ref([
      { name: "Dashboard", icon: "fas fa-home", route: "/user/dashboard" },
      { name: "Profile", icon: "fas fa-user", route: "/user/profile" },
      { name: "Working Time", icon: "fas fa-clock", route: "/user/WorkingTime" },
    ]);

    const selectItem = async (index, route) => {
      activeItem.value = index;
      router.push(route);
    };

    const handleLogout = async () => {
      try {
        await logout();
        router.push('/login');
      } catch (error) {
        console.error('Logout error:', error);
        router.push('/login');
      }
    };

    return {
      activeItem,
      menuItems,
      selectItem,
      handleLogout
    };
  }
};
</script>

<style scoped>
/* Styles pour le layout utilisateur */
.header-title {
  font-size: 20px;
  display: flex;
  align-items: center;
  margin-top: 60px;
}

.sidebar-container {
  display: flex;
  height: 100vh;
}

.sidebar {
  width: 200px;
  background-color: #f8f9fa;
  padding: 20px;
}

/* Intégration du logo avec les mêmes propriétés que dans l'admin layout */
.sidebar-header {
  text-align: center;
  margin-bottom: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.site-logo {
  width: 200px; /* Largeur du logo */
  height: auto; /* Conserve les proportions */
  margin-top: -20%;
  margin-bottom: -55px; /* Ajuste l'espacement entre le logo et le texte */
}

.site-name {
  font-size: 1.5rem; /* Taille du texte */
  font-weight: bold;
  color: #333; /* Couleur sombre */
}

/* Menu */
.menu-list {
  list-style-type: none;
  padding: 0;
}

.menu-item {
  display: flex;
  align-items: center;
  padding: 15px 10px;
  cursor: pointer;
  transition: background-color 0.3s ease;
  border-radius: 15px;
  margin-bottom: 10px;
}

.menu-item .icon {
  margin-right: 40px;
  color: gray;
  font-size: 18px;
  width: 25px; /* Correction de la largeur de l'icône */
  text-align: center;
}

.menu-item .menu-text {
  color: gray;
  text-align: left;
  flex-grow: 1;
}

.menu-item.active {
  background-color: #8fb67d;
  color: white;
  font-weight: bold;
}

.menu-item.active .icon {
  color: white;
}

.menu-item:hover {
  background-color: #666;
}

.divider {
  border: 0;
  height: 1px;
  background-color: #ccc;
  margin: 15px 0;
}

.content {
  flex-grow: 1;
  padding: 20px;
  background-color: #fff;
}
</style>
