// src/stores/auth.js
import { defineStore } from 'pinia'
import api, { setAuthToken } from '../services/api'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: localStorage.getItem('token') || null,
    user: JSON.parse(localStorage.getItem('user') || 'null'),
    errorMsg: null,
  }),
  getters: {
    isLogged: (s) => !!s.token,
    userRole: (s) => s.user?.role ?? null,
  },
  actions: {
    setSession(token, user) {
      this.token = token
      this.user = user
      this.errorMsg = null
      // persistir
      localStorage.setItem('token', token)
      localStorage.setItem('user', JSON.stringify(user))
      setAuthToken(token)
    },
    clearSession() {
      this.token = null
      this.user = null
      this.errorMsg = null
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      setAuthToken(null)
    },
    async login(email, password) {
      try {
        const res = await api.post('/login', { email, password })
        // backend: { user, token }
        this.setSession(res.data.token, res.data.user)
        return res.data
      } catch (e) {
        this.errorMsg = e.response?.data?.message || 'Error en login'
        throw e
      }
    },
    async register(name, email, password, password_confirmation) {
      const res = await api.post('/register', { name, email, password, password_confirmation })
      this.setSession(res.data.token, res.data.user)
      return res.data
    },
    async logout() {
      try {
        // intenta invalidar token en backend (si está)
        await api.post('/logout')
      } catch (e) {
        console.warn('logout api error', e?.response?.status)
      }
      this.clearSession()
    }
  }
})
