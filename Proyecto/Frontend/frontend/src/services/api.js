// src/services/api.js
import axios from 'axios';

const baseURL = import.meta.env.VITE_API_BASE || 'http://127.0.0.1:8000/api';

const api = axios.create({
  baseURL,
  headers: {
    Accept: 'application/json',
  },
});

// helper para establecer o quitar header Authorization
export function setAuthToken(token) {
  if (token) {
    // token puede venir como "1|abcd..." o solo como hash; backend usa "Bearer <token>"
    api.defaults.headers.common.Authorization = `Bearer ${token}`;
    localStorage.setItem('token', token);
  } else {
    delete api.defaults.headers.common.Authorization;
    localStorage.removeItem('token');
  }
}

// Si ya hay token en localStorage (arranque), setearlo automáticamente (usa la función)
const existing = localStorage.getItem('token');
if (existing) setAuthToken(existing);

export default api;
