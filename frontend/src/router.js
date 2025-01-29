import { createRouter, createWebHistory } from 'vue-router';
import AdminLayout from './views/AdminLayout.vue';
import AdminDashboard from './views/AdminDashboard.vue';
import AdminUsers from './views/AdminUsers.vue';
import AdminUserWorkingTime from './views/AdminUserWorkingTime.vue';
import UserLayout from './views/UserLayout.vue';  
import Dashboard from './views/Dashboard.vue';     
import Profile from './views/Profile.vue';            
import WorkingTime from './views/WorkingTime.vue';    
import LoginPage from './views/LoginPage.vue';
import RegisterPage from './views/RegisterPage.vue';


const routes = [

  {
    path: '/login',
    name: 'LoginPage',
    component: LoginPage,
  },
  {
    path: '/register',
    name: 'RegisterPage',
    component: RegisterPage,
  },
  {
    path: '/admin',
    component: AdminLayout,
    children: [
      {
        path: '',
        redirect: { name: 'AdminDashboard' }, // Redirection par défaut vers Admin Dashboard
      },
      {
        path: 'dashboard',
        name: 'AdminDashboard',
        component: AdminDashboard,
      },
      {
        path: 'users',
        name: 'AdminUsers',
        component: AdminUsers,
      },
      {
        path: 'user-workingtime',
        name: 'AdminUserWorkingTime',
        component: AdminUserWorkingTime,
      },
      {
        path: 'profile',
        name: 'AdminProfile',
        component: Profile,
      },
     
     
    ],
  },
  {
    path: '/user',
    component: UserLayout,
    children: [
      {
        path: '',
        redirect: { name: 'UserDashboard' }, // Redirection par défaut vers User Dashboard
      },
      {
        path: 'dashboard',
        name: 'UserDashboard',
        component: Dashboard,
      },
      {
        path: 'profile',
        name: 'UserProfile',
        component: Profile,
      },
      {
        path: 'WorkingTime',
        name: 'UserWorkingTime',
        component: WorkingTime,
      },
  
    ],
  },
  {
    path: '/',
    redirect: '/user/dashboard', // Redirection de la racine vers un point de départ
  },
  {
    path: '/:catchAll(.*)',
    redirect: '/user/dashboard', // Redirection en cas de page non trouvée
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
