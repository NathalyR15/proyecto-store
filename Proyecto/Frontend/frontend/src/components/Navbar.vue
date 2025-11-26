<!-- src/components/Navbar.vue -->
<template>
  <nav class="navbar">
    <div class="container">
      <div class="brand"><router-link to="/productos">HOLAAAAA
        
      </router-link></div>

      <div class="links">
        <router-link to="/productos">Productos</router-link>
        <router-link to="/sucursales">Sucursales</router-link>
        <router-link to="/cotizaciones">Cotización</router-link>

        <div class="spacer"></div>

        <span v-if="!auth.isLogged">
          <router-link to="/login">Login</router-link>
        </span>

        <span v-else class="user-block">
          <span class="user">{{ auth.user?.name }}</span>

          <!-- Mostrar botón que lleve al panel: etiqueta según rol -->
          <button
            v-if="auth.user?.role === 'admin'"
            class="btn-admin"
            @click="goAdmin"
          >Admin</button>

          <button
            v-else-if="auth.user?.role === 'gerente'"
            class="btn-admin"
            @click="goGerente"
          >Gerente</button>

          <button class="btn-logout" @click="logout">Logout</button>
        </span>
      </div>
    </div>
  </nav>
</template>

<script setup>

import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
const router = useRouter()
const auth = useAuthStore()

function logout() {
  auth.logout()
  router.push('/login')
}
function goAdmin() {
  router.push('/admin')      // panel Admin (admin only)
}
function goGerente() {
  router.push('/admin')      // reusa la misma /admin pero mostrará opciones de gerente
}
</script>

<style scoped>
.navbar{
  position: fixed;
  top:0; left:0; right:0;
  height:56px;
  background:#3f3f46;
  color:white;
  z-index:1000;
  box-shadow:0 1px 6px rgba(0,0,0,0.12);
}
.container{
  display:flex;
  align-items:center;
  gap:12px;
  padding:0 16px;
  height:100%;
  width:100%;
}
.brand a { color: white; text-decoration: none; font-weight:700; font-size:1.1rem; }
.links { display:flex; align-items:center; width:100%; gap:12px; }
.links a { color:#cfe2ff; text-decoration:none; padding:6px 8px; }
.spacer { flex:1; } /* empuja elementos a la derecha */
.user-block { display:flex; align-items:center; gap:8px; }
.btn-admin, .btn-logout { background:#111827; color:white; border-radius:6px; padding:6px 8px; border:0; cursor:pointer; }
</style>
