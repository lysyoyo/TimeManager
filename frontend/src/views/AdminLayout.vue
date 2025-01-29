<template>
  <div class="admin-layout">
    <div class="sidebar-container">
      <div class="sidebar">
        <div class="sidebar-header">
          <img src="@/assets/logo.png" alt="Logo" class="site-logo" />
          <h1 class="site-name">BATMAN - Admin</h1>
        </div>
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
          <span data-cy="logout" class="menu-text">Logout</span>
        </li>
      </ul>
    </div>

    <div class="content">
      <div class="header-title">
        <h2>{{ currentPage }}</h2>
      </div>
    </div>

    <div class="main-content">
      <AdminHeader />
      <div class="content">
        <router-view />
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRouter, useRoute  } from 'vue-router';
import { useAuth } from '@/composables/useAuth';
import AdminHeader from "../components/AdminHeader.vue";

export default {
  name: "AdminLayout",
  components: {
    AdminHeader,
  },
  setup() {
    const router = useRouter();
    const route = useRoute();
    const { logout } = useAuth();

    const activeItem = ref(0);
    const menuItems = ref([
      // { name: "Dashboard", icon: "fas fa-home", route: "/admin/dashboard" },
      { name: "Users", icon: "fas fa-users", route: "/admin/users" },
      { name: "My profile", icon: "fas fa-user", route: "/admin/profile" },
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

    const setActiveItemByRoute = () => {
      if (route.path.includes("/admin/dashboard")) {
        activeItem.value = 0;
      } else if (route.path.includes("/admin/user")) {
        activeItem.value = 0;
      } else if (route.path.includes("/admin/profile")) {
        activeItem.value = 1;
      } else {
        activeItem.value = 2;
      }
    };

    onMounted(setActiveItemByRoute);

    return {
      activeItem,
      menuItems,
      selectItem,
      handleLogout
    };
  }
};
</script>

<style src="@/assets/AdminLayout.css" scoped></style>
