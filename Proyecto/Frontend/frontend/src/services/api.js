// src/services/api.js
import axios from 'axios';

// Si en tu .env pones VITE_API_BASE incluyendo "/api", por ejemplo:
// VITE_API_BASE=http://127.0.0.1:8080/api
// entonces las llamadas serán: api.get('/productos') -> http://127.0.0.1:8080/api/productos
const baseURL = import.meta.env.VITE_API_BASE || 'https://api.storeproyect.shop/api';

const api = axios.create({
  baseURL,
  headers: {
    Accept: 'application/json',
  },
  // timeout: 10000, // opcional: tiempo max de espera
});

// helper para establecer o quitar header Authorization
export function setAuthToken(token) {
  if (token) {
    api.defaults.headers.common.Authorization = `Bearer ${token}`;
    localStorage.setItem('token', token);
  } else {
    delete api.defaults.headers.common.Authorization;
    localStorage.removeItem('token');
  }
}

// Si ya hay token en localStorage (arranque), setearlo automáticamente
const existing = localStorage.getItem('token');
if (existing) setAuthToken(existing);

export default api;
