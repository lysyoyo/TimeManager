<template>
    <div class="modal" v-if="isOpen">
      <div class="modal-content">
        <div class="modal-header">
          <h2>New User</h2>
          <span class="close-btn" @click="closeModal">&times;</span>
        </div>
        <div class="modal-body">
          <!-- User Form -->
          <form @submit.prevent="submitForm">
            <div class="form-group">
              <label for="fullName">Full Name</label>
              <input type="text" id="fullName" v-model="fullName" placeholder="Enter full name" required />
            </div>
            <div class="form-group">
              <label for="email">Email</label>
              <input type="email" id="email" v-model="email" placeholder="Enter email" required />
            </div>
            <!--<div class="form-group">
              <label for="password">Password</label>
              <input type="password" id="password" v-model="password" placeholder="Enter password" required />
            </div>-->
            <div class="modal-footer">
              <button type="submit" class="save-btn">Save</button>
              <button type="button" class="cancel-btn" @click="closeModal">Cancel</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    props: {
      isOpen: {
        type: Boolean,
        required: true
      }
    },
    data() {
      return {
        fullName: '',
        email: '',
        password: ''
      };
    },
    methods: {
      closeModal() {
        this.$emit('close');
      },
      submitForm() {
        const userData = {
          fullName: this.fullName,
          email: this.email,
          password: this.password
        };
        console.log(userData);
        this.closeModal();
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
  
  .modal-content {
    background-color: #f4f4f9;
    padding: 20px;
    border-radius: 10px;
    width: 400px;
    box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
    text-align: center;
  }
  
  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  
  .close-btn {
    cursor: pointer;
    font-size: 24px;
  }
  
  .form-group {
    margin-bottom: 15px;
    text-align: left;
  }
  
  .form-group label {
    display: block;
    font-size: 14px;
    color: #333;
  }
  
  .form-group input {
    width: 100%;
    padding: 7px;
    font-size: 14px;
    border: 1px solid #ccc;
    border-radius: 5px;
    margin-top: 10px;
    margin-right: 20px;
  }
  
  .modal-footer {
    display: flex;
    justify-content: space-between;
    margin-top: 20px;
  }
  
  .save-btn {
    background-color: #8fb67d;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }
  
  .save-btn:hover {
    background-color: #2980b9;
  }
  
  .cancel-btn {
    background-color: #e74c3c;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }
  
  .cancel-btn:hover {
    background-color: #c0392b;
  }
  </style>
  