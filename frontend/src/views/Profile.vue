<template>
  <div class="profile-container">
    <!-- En-tête du profil avec avatar et infos de l'utilisateur -->
    <div class="profile-header">
      <img class="profile-avatar" :src="userAvatar" alt="User Avatar" />
      <div class="profile-info">
        <h2 class="profile-name">{{ profileData.name }}</h2>
        <p class="profile-role">{{ profileData.role }}</p>
        <button class="edit-button" @click="openEditModal">Edit Profile</button>
      </div>
    </div>

    <!-- Détails du profil sous forme de cartes -->
    <div class="profile-details">
      <div class="detail-card" v-for="(detail, index) in profileDetails" :key="index">
        <h3>{{ detail.label }}</h3>
        <p>{{ detail.value }}</p>
      </div>
    </div>

    <!-- Section des actions -->
    <div class="profile-actions">
      <button class="action-button logout">Delete</button>
    </div>

    <!-- Modale pour éditer le profil -->
    <EditModal
      v-if="isEditModalOpen"
      :profileData="editableProfile"
      @save="saveProfile"
      @close="closeEditModal"
    />
  </div>
</template>

<script>
import userAvatarImage from '@/assets/usertest.jpg';
import EditModal from '@/components/EditModal.vue';

export default {
  name: "Profile",
  components: {
    EditModal,
  },
  data() {
    return {
      userAvatar: userAvatarImage,
      isEditModalOpen: false,
      profileData: {
        name: "Sandra Bratford",
        role: "Software Engineer",
        email: "sandra.bratford@example.com",
        phone: "+1 234 567 890",
      },
      editableProfile: {},
    };
  },
  computed: {
    profileDetails() {
      return [
        { label: "Email", value: this.profileData.email },
        { label: "Phone", value: this.profileData.phone },
        { label: "Location", value: "San Francisco, CA" },
        { label: "Joined", value: "January 15, 2022" },
      ];
    },
  },
  methods: {
    openEditModal() {
      this.editableProfile = { ...this.profileData };
      this.isEditModalOpen = true;
    },
    closeEditModal() {
      this.isEditModalOpen = false;
    },
    saveProfile(updatedProfile) {
      this.profileData = { ...updatedProfile };
      this.closeEditModal();
    },
  },
};
</script>

<style src="@/assets/profile.css"></style>
