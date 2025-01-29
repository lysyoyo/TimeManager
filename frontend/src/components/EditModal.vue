<template>
    <div class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <h3>Edit Profile</h3>
  
        <label>
          Name:
          <input v-model="editableProfile.name" type="text" />
        </label>
  
        <label>
          Email:
          <input v-model="editableProfile.email" type="email" />
        </label>
  
        <label>
          Phone:
          <input v-model="editableProfile.phone" type="tel" />
        </label>
  
        <label>
          Location:
          <input v-model="editableProfile.location" type="text" />
        </label>
  
       
  
        <div class="modal-actions">
          <button @click="saveChanges" class="save-button">Save Changes</button>
          <button @click="closeModal" class="cancel-button">Cancel</button>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: "EditModal",
    props: {
      profileData: {
        type: Object,
        required: true,
      },
    },
    data() {
      return {
        editableProfile: { ...this.profileData },
      };
    },
    methods: {
      saveChanges() {
        this.$emit("save", this.editableProfile);
        this.closeModal();
      },
      closeModal() {
        this.$emit("close");
      },
    },
  };
  </script>
  
  
  
  <style scoped>
  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
  }
  
  .modal-content {
    background: #fff;
    padding: 30px;
    border-radius: 10px;
    width: 400px;
    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
    text-align: center;
  }
  
  .modal-content h3 {
    margin-bottom: 20px;
  }
  
  .modal-content label {
    display: block;
    text-align: left;
    margin-bottom: 15px;
    font-weight: 500;
  }
  
  .modal-content input {
    width: 100%;
    padding: 8px;
    margin-top: 5px;
    margin-bottom: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
    font-size: 1rem;
  }
  
  .modal-actions {
    display: flex;
    justify-content: space-between;
  }
  
  .save-button {
    background-color: #4caf50;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;
    font-size: 1rem;
  }
  
  .cancel-button {
    background-color: #dc3545;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;
    font-size: 1rem;
  }
  </style>
  