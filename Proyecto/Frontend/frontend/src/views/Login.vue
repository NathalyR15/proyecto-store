<!-- src/views/Login.vue -->
<template>
  <div style="max-width:420px;margin:2rem auto">
    <h2>Iniciar sesión</h2>
    <form @submit.prevent="doLogin">
      <div>
        <label>Email</label>
        <input v-model="email" type="email" required />
      </div>
      <div style="margin-top:.5rem">
        <label>Contraseña</label>
        <input v-model="password" type="password" required />
      </div>
      <div style="margin-top:1rem">
        <button type="submit">Entrar</button>
        <router-link to="/register" style="margin-left:1rem">Registrarse</router-link>
      </div>
      <p v-if="error" style="color:red">{{ error }}</p>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useAuthStore } from '../stores/auth';

const router = useRouter();
const route = useRoute();
const auth = useAuthStore();

const email = ref('');
const password = ref('');
const error = ref('');

async function doLogin() {
  error.value = '';
  try {
    await auth.login(email.value, password.value);
    const redirect = route.query.redirect || '/productos';
    router.push(redirect);
  } catch (e) {
    // manejo simple de errores
    if (e.response?.data?.message) error.value = e.response.data.message;
    else error.value = 'Error al iniciar sesión';
  }
}
</script>
