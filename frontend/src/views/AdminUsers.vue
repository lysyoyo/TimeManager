<template>
    <div>
      <UserTable />
    </div>
  </template>
  
  <script>
  import UserTable from '../components/admin_users/UserTable.vue';

  export default {
    name: 'AdminUsers',
    components: {
      UserTable,
    },
  };
  </script>
  