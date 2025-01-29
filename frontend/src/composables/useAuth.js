import { ref, onMounted } from 'vue'
import axios from 'axios'

const api = axios.create({
    baseURL: 'http://localhost:4000/api',
    withCredentials: true,
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
    }
})

// Intercepteur pour ajouter le token XSRF aux requêtes
api.interceptors.request.use(
    config => {
        const token = localStorage.getItem('xsrfToken')
        if (token) {
            config.headers['X-XSRF-Token'] = token
        }
        return config
    },
    error => {
        return Promise.reject(error)
    }
)

// Intercepteur pour les réponses
api.interceptors.response.use(
    response => response,
    error => {
        console.error('Response Error:', error.response || error)
        if (error.response?.status === 401) {
            localStorage.removeItem('xsrfToken')
            localStorage.removeItem('user')
        }
        return Promise.reject(error)
    }
)

export function useAuth() {
    const user = ref(loadStoredUser())
    const error = ref(null)
    const loading = ref(false)

    function loadStoredUser() {
        const storedUser = localStorage.getItem('user')
        return storedUser ? JSON.parse(storedUser) : null
    }

    function saveUserToStorage(userData) {
        localStorage.setItem('user', JSON.stringify(userData))
        user.value = userData
    }

    // Vérifie l'état de l'authentification au montage
    onMounted(async () => {
        const token = localStorage.getItem('xsrfToken')
        if (token && !user.value) {
            try {
                const response = await checkAuth()
                saveUserToStorage(response.data.user)
            } catch (err) {
                console.error('Auth check failed:', err)
                localStorage.removeItem('xsrfToken')
                localStorage.removeItem('user')
            }
        }
    })

    const checkAuth = async () => {
        try {
            return await api.get('/users/me')
        } catch (err) {
            throw err
        }
    }

    const login = async (email, password) => {
        loading.value = true
        error.value = null

        try {
            console.log('Sending login request...')
            const response = await api.post('/users/sign_in', {
                email: email.trim(),
                password: password
            })

            console.log('Login response:', response.data)

            if (response.data.xsrf_token) {
                localStorage.setItem('xsrfToken', response.data.xsrf_token)

                const userData = {
                    id: response.data.user_id,
                    role: response.data.role
                }
                saveUserToStorage(userData)

                console.log('Stored user data:', userData)
                console.log('Stored XSRF token:', response.data.xsrf_token)

                return { success: true }
            }

            console.log('Invalid response format:', response.data)
            return {
                success: false,
                error: 'Invalid server response'
            }
        } catch (err) {
            console.error('Login error:', err.response?.data || err)
            return {
                success: false,
                error: err.response?.data?.error || 'Authentication failed'
            }
        } finally {
            loading.value = false
        }
    }

    const logout = async () => {
        try {
            await api.post('/users/sign_out')
        } catch (err) {
            console.error('Logout error:', err)
        } finally {
            user.value = null
            localStorage.removeItem('xsrfToken')
            localStorage.removeItem('user')
        }
    }

    const isAuthenticated = () => {
        const hasToken = !!localStorage.getItem('xsrfToken')
        const hasUser = !!localStorage.getItem('user')
        console.log('Auth check - Token:', hasToken, 'User:', hasUser)
        return hasToken && hasUser
    }

    const register = async (userData) => {
        loading.value = true
        error.value = null

        try {
            console.log('Sending registration request...')
            const response = await api.post('/users/sign_up', {
                email: userData.email.trim(),
                password: userData.password,
                username: userData.username.trim(),
                first_name: userData.firstName.trim(),
                last_name: userData.lastName.trim(),
                role: "user"
            })

            console.log('Registration response:', response.data)

            if (response.data.xsrf_token) {
                localStorage.setItem('xsrfToken', response.data.xsrf_token)

                const newUserData = {
                    id: response.data.user_id,
                    role: response.data.role
                }
                saveUserToStorage(newUserData)

                return { success: true }
            }

            return {
                success: false,
                error: 'Invalid server response'
            }
        } catch (err) {
            console.error('Registration error:', err.response?.data || err)
            return {
                success: false,
                error: err.response?.data?.error || 'Registration failed'
            }
        } finally {
            loading.value = false
        }
    }

    const addNew = async (userData) => {
        loading.value = true
        error.value = null

        try {
            console.log('Sending add new user request...')
            const response = await api.post('/users', {
                email: userData.email.trim(),
                username: userData.username.trim(),
                role: "user"
            })

            console.log('Add new response:', response.data)

            if (response.data) {
                return { success: true }
            }

            return {
                success: false,
                error: 'Invalid server response'
            }
        } catch (err) {
            console.error('Add new error:', err.response?.data || err)
            return {
                success: false,
                error: err.response?.data?.error || 'Add new failed'
            }
        } finally {
            loading.value = false
        }
    }

    return {
        user,
        error,
        loading,
        login,
        logout,
        isAuthenticated,
        checkAuth,
        register,
        addNew
    }
}