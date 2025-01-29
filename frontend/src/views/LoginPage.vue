<template>
  <div class="login-page">
    <div class="left-section">
      <div class="logo-container">
        <img src="@/assets/logo.png" alt="Logo" class="logo" />
        <h1 class="site-name">Welcome BATMAN</h1>
      </div>
    </div>

    <div class="right-section">
      <div class="login-form">
        <h2 class="login-title">Login to your account</h2>
        <form @submit.prevent="handleLogin">
          <div class="input-group">
            <label for="email">Email</label>
            <div class="input-wrapper">
              <i class="icon fas fa-envelope"></i>
              <input
                  type="email"
                  id="email"
                  v-model="email"
                  required
                  placeholder="Enter your email"
                  :disabled="loading"
                  @input="clearError"
              />
            </div>
          </div>
          <div class="input-group">
            <label for="password">Password</label>
            <div class="input-wrapper">
              <i class="icon fas fa-lock"></i>
              <input
                  type="password"
                  id="password"
                  v-model="password"
                  required
                  placeholder="Enter your password"
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
              class="login-button"
              :disabled="loading || !isFormValid"
          >
            <span v-if="loading" class="loading-spinner">
              <i class="fas fa-spinner fa-spin"></i>
            </span>
            <span v-else>Login</span>
          </button>
        </form>
        <p class="register-link">
          For your first login, please
          <router-link to="/register" class="register-button">click here</router-link>
          to register.
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'

export default {
  setup() {
    const router = useRouter()
    const { login, error: authError, loading: authLoading } = useAuth()

    const email = ref('')
    const password = ref('')
    const error = ref('')
    const loading = ref(false)

    // Validation du formulaire
    const isFormValid = computed(() => {
      return email.value.trim() && password.value.trim() &&
          email.value.includes('@') && email.value.includes('.')
    })

    const clearError = () => {
      error.value = ''
    }

    const handleLogin = async () => {
      if (!isFormValid.value) return

      try {
        loading.value = true
        error.value = ''

        const result = await login(email.value, password.value)

        if (result.success) {
          router.push('/admin/dashboard')
        } else {
          error.value = result.error || 'Invalid credentials'
        }
      } catch (e) {
        error.value = 'Server error. Please try again later.'
        console.error('Login error:', e)
      } finally {
        loading.value = false
      }
    }

    return {
      email,
      password,
      error,
      loading,
      isFormValid,
      clearError,
      handleLogin
    }
  }
}
</script>
<style src="@/assets/LoginPage.css" scoped></style>
