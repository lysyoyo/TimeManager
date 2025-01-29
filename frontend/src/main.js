// src/main.js
import { createApp } from 'vue';
import App from './App.vue';
import router from './router'; // Assure-toi d'importer le routeur
import ElementPlus from 'element-plus';
import 'element-plus/dist/index.css'; // Import CSS cho Element Plus

const app = createApp(App);

app.use(ElementPlus); // Sử dụng Element Plus
app.mount('#app');

createApp(App).use(router).mount('#app');
