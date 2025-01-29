<template>
  <header class="admin-header">
    <div class="search-bar">
      <input type="text" placeholder="Search Here" v-model="searchQuery" />
    </div>
    <div class="actions">
      <button v-if="!isModalOpen" class="new-user-btn" @click="openModal">+ New User</button>
      <div v-if="isModalOpen" class="modal">
        <CreateNewAccount :registerOrAddNew="false" :isOpen="isModalOpen" @close="closeModal"></CreateNewAccount>
      </div>
    </div>
  </header>
</template>

<script>
import UserModal from './UserModal.vue';
import CreateNewAccount from './common/create_new_account.vue';

export default {
  name: "AdminHeader",
  components: {
    UserModal,
    CreateNewAccount,
  },
  data() {
    return {
      isModalOpen: false
    };
  },
  methods: {
    openModal() {
      this.isModalOpen = true;
    },
    closeModal() {
      this.isModalOpen = false;
    }
  }
};
</script>

<style scoped>

.modal {
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
  }

.admin-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  background-color: #fff;
}

.search-bar {
  flex: 1;
}

.search-bar input {
  width: 100%;
  max-width: 300px;
  padding: 10px;
  border-radius: 5px;
  border: 1px solid #ccc;
}

.actions {
  margin-left: 20px;
}

.new-user-btn {
  background-color: #8fb67d;
  color: white;
  border: none;
  padding: 10px 15px;
  border-radius: 5px;
  cursor: pointer;
}
.new-user-btn:hover {
  background-color: #219150;
}
</style>
