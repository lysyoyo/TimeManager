<template>
    <div class="register-form" v-if="isOpen">
        <h2 class="register-title">{{registerOrAddNew ? "Create your account" : "Add new user"}}</h2>
        <form @submit.prevent="handleRegister">
        <div class="input-group">
            <label for="username">Username</label>
            <div class="input-wrapper">
            <i class="icon fas fa-user"></i>
            <input
                type="text"
                id="username"
                v-model="formData.username"
                required
                placeholder="Enter your username"
                :disabled="loading"
                @input="clearError"
            />
            </div>
        </div>

        <div class="input-group" v-if="registerOrAddNew">
            <label for="firstName">First Name</label>
            <div class="input-wrapper">
            <i class="icon fas fa-user"></i>
            <input
                type="text"
                id="firstName"
                v-model="formData.firstName"
                required
                placeholder="Enter your first name"
                :disabled="loading"
                @input="clearError"
            />
            </div>
        </div>

        <div class="input-group" v-if="registerOrAddNew">
            <label for="lastName">Last Name</label>
            <div class="input-wrapper">
            <i class="icon fas fa-user"></i>
            <input
                type="text"
                id="lastName"
                v-model="formData.lastName"
                required
                placeholder="Enter your last name"
                :disabled="loading"
                @input="clearError"
            />
            </div>
        </div>

        <div class="input-group">
            <label for="email">Email</label>
            <div class="input-wrapper">
            <i class="icon fas fa-envelope"></i>
            <input
                type="email"
                id="email"
                v-model="formData.email"
                required
                placeholder="Enter your email"
                :disabled="loading"
                @input="clearError"
            />
            </div>
        </div>

        <div class="input-group" v-if="registerOrAddNew">
            <label for="password">Password</label>
            <div class="input-wrapper">
            <i class="icon fas fa-lock"></i>
            <input
                type="password"
                id="password"
                v-model="formData.password"
                required
                placeholder="Enter your password"
                :disabled="loading"
                @input="clearError"
            />
            </div>
        </div>

        <div class="input-group" v-if="registerOrAddNew">
            <label for="confirmPassword">Confirm Password</label>
            <div class="input-wrapper">
            <i class="icon fas fa-lock"></i>
            <input
                type="password"
                id="confirmPassword"
                v-model="formData.confirmPassword"
                required
                placeholder="Confirm your password"
                :disabled="loading"
                @input="clearError"
            />
            </div>
        </div>

        <div v-if="error" class="error-message">
            <i class="fas fa-exclamation-circle"></i>
            {{ error }}
        </div>

        <button
            type="submit"
            class="register-button"
            :disabled="loading || !isFormValid"
        >
            <span v-if="loading" class="loading-spinner">
            <i class="fas fa-spinner fa-spin"></i>
            </span>
            <span v-else>{{registerOrAddNew ? "Register" : "Add new"}}</span>
        </button>
        </form>

        <p class="login-link" v-if="registerOrAddNew">
        Already have an account? <router-link to="/login">Login here</router-link>
        </p>
        <button  v-if="!registerOrAddNew" type="button" class="cancel-btn" @click="closeModal">Cancel</button>
    </div>
  </template>
  
  <script>
  import { ref, computed } from 'vue'
  import { useRouter } from 'vue-router'
  import { useAuth } from '@/composables/useAuth'
  
  export default {
    name: "CreateNewAccount",
    props: {
        isOpen: {
            type: Boolean,
            required: true
        },
        registerOrAddNew: Boolean, // register -> true, addNew -> false,
    },
    methods: {
      closeModal() {
        this.$emit('close');
      },
    },
    setup(props) {
        const { registerOrAddNew, isOpen } = props;
      const router = useRouter()
      const { register, addNew, error: authError, loading: authLoading } = useAuth()
  
      const formData = ref({
        username: '',
        firstName: '',
        lastName: '',
        email: '',
        password: '',
        confirmPassword: ''
      })
  
      const error = ref('')
      const loading = ref(false)
  
      const isFormValid = computed(() => {
        const { username, firstName, lastName, email, password, confirmPassword } = formData.value
        if (registerOrAddNew) {
            return (
                username.trim() &&
                firstName.trim() &&
                lastName.trim() &&
                email.trim() &&
                password.trim() &&
                confirmPassword.trim() &&
                email.includes('@') &&
                password.length >= 6 &&
                password === confirmPassword
            )
        }
        return (
            username.trim() &&
            email.trim() &&
            email.includes('@')
        )
      })
  
      const clearError = () => {
        error.value = ''
      }
  
      const handleRegister = async () => {
        if (!isFormValid.value) {
          if (formData.value.password !== formData.value.confirmPassword) {
            error.value = 'Passwords do not match'
            return
          }
          if (formData.value.password.length < 6) {
            error.value = 'Password must be at least 6 characters long'
            return
          }
          return
        }
  
        try {
          loading.value = true
          error.value = ''
  
          const result = registerOrAddNew ? await register(formData.value) : await addNew(formData.value);
  
          if (result.success) {
            if (registerOrAddNew) {
                router.push('/admin/dashboard')
            } else {
                error.value = 'Registration successful'
            }
          } else {
            error.value = result.error || 'Registration failed'
          }
        } catch (e) {
          error.value = 'Server error. Please try again later.'
          console.error('Registration error:', e)
        } finally {
          loading.value = false
        }
      }
  
      return {
        formData,
        error,
        loading,
        isFormValid,
        registerOrAddNew,
        isOpen,
        clearError,
        handleRegister
      }
    }
  }
  </script>

<style scoped>
    .register-form {
      background-color: white;
      padding: 40px;
      border-radius: 10px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
      width: 80%;
      max-width: 400px;
      margin: 0 auto; /* Centrer le formulaire */
      text-align: center; /* Centre le texte et les éléments enfants */
    }
    
    .register-title {
      color: #333;
      margin-bottom: 20px;
    }
    
    /* Groupes de champs d'input avec icônes */
    .input-group {
      margin-bottom: 20px;
    }
    
    .input-group label {
      display: block;
      margin-bottom: 8px;
      color: #333;
      font-weight: bold;
    }
    
    /* Conteneur pour l'input et l'icône */
    .input-wrapper {
      position: relative;
    }
    
    /* Champs d'input */
    .input-wrapper input {
      width: 80%; /* Ajuste la largeur pour centrer */
      padding: 12px 15px;
      padding-left: 45px;
      border: 1px solid #ccc;
      border-radius: 25px;
      background-color: #f9f9f9;
      box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.05);
      transition: all 0.3s ease;
      font-size: 1rem;
      margin: 0 auto; /* Centrer l'input */
    }
    
    .input-wrapper input:focus {
      border-color: #8fb67d;
      background-color: white;
      outline: none;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
    
    /* Icônes pour les champs d'input */
    .icon {
      position: absolute;
      left: 15px;
      top: 50%;
      transform: translateY(-50%);
      color: #aaa;
      font-size: 18px;
      transition: color 0.3s ease;
    }
    
    .input-wrapper input:focus + .icon {
      color: #8fb67d;
    }
    
    /* Bouton d'inscription */
    .register-button {
      width: 80%; /* Ajuster la largeur du bouton */
      padding: 12px;
      background-color: #8fb67d;
      border: none;
      border-radius: 5px;
      color: white;
      font-size: 16px;
      cursor: pointer;
      transition: background-color 0.3s;
      margin: 20px auto; /* Centrer le bouton */
    }
    
    .register-button:hover {
      background-color: #7aa669;
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
    
        
    .cancel-btn {
        width: 80%;
        padding: 12px;
        background-color: #e74c3c;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
    }
    
    .cancel-btn:hover {
        background-color: #c0392b;
    }
    
    /* ------ Styles Responsives ------ */
    @media (max-width: 768px) {
      .register-form {
        width: 90%;
        padding: 20px;
      }
    
      .register-title {
        font-size: 1.5rem;
      }
    
      .register-button {
        padding: 10px;
      }
    }
    
    @media (max-width: 480px) {
      .register-form {
        width: 95%;
      }
    
      .register-title {
        font-size: 1.2rem;
      }
    
      .register-button {
        font-size: 14px;
      }
    }
    </style>
    