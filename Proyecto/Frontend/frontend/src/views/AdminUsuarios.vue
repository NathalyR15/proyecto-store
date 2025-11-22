<!-- src/views/AdminUsuarios.vue -->
<template>
  <div class="page">
    <h2>Gestión de Usuarios</h2>

    <div class="controls">
      <input v-model="q" placeholder="Buscar por nombre/email" @keyup.enter="load" />
      <button @click="load">Buscar</button>
    </div>

    <div v-if="loading">Cargando...</div>

    <div v-else>
      <table v-if="users.length">
        <thead>
          <tr><th>ID</th><th>Nombre</th><th>Email</th><th>Rol</th><th>Acciones</th></tr>
        </thead>
        <tbody>
          <tr v-for="u in users" :key="u.id">
            <td>{{ u.id }}</td>
            <td>{{ u.name }}</td>
            <td>{{ u.email }}</td>
            <td>
              <select v-model="u.role" @change="changeRole(u)">
                <option value="cliente">cliente</option>
                <option value="gerente">gerente</option>
                <option value="admin">admin</option>
              </select>
            </td>
            <td>
              <button @click="confirmDelete(u.id)">Eliminar</button>
            </td>
          </tr>
        </tbody>
      </table>

      <div v-else>No hay usuarios.</div>

      <div class="pagination" v-if="meta">
        <button @click="goto(meta.prev_page_url)" :disabled="!meta.prev_page_url">Anterior</button>
        <span> Página {{ meta.current_page }} / {{ meta.last_page }} </span>
        <button @click="goto(meta.next_page_url)" :disabled="!meta.next_page_url">Siguiente</button>
      </div>
    </div>

    <div v-if="msg" class="msg">{{ msg }}</div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import api from '../services/api';

const users = ref([]);
const loading = ref(false);
const msg = ref('');
const q = ref('');
const meta = ref(null);

async function load(url = null) {
  loading.value = true;
  msg.value = '';
  try {
    const endpoint = url ? url : `/admin/users${q.value ? '?q=' + encodeURIComponent(q.value) : ''}`;
    const res = await api.get(endpoint);
    // si viene paginado: res.data.data + meta
    const dat = res.data;
    if (dat.data) {
      users.value = dat.data;
      meta.value = {
        current_page: dat.current_page,
        last_page: dat.last_page,
        prev_page_url: dat.prev_page_url,
        next_page_url: dat.next_page_url
      };
    } else {
      users.value = dat;
      meta.value = null;
    }
  } catch (e) {
    console.error(e);
    msg.value = 'Error cargando usuarios';
  } finally {
    loading.value = false;
  }
}

async function changeRole(u) {
  msg.value = '';
  try {
    await api.put(`/admin/users/${u.id}`, { role: u.role });
    msg.value = `Rol actualizado para ${u.email}`;
  } catch (e) {
    console.error(e);
    msg.value = 'Error actualizando rol';
  }
}

function confirmDelete(id) {
  if (!confirm('Eliminar usuario?')) return;
  borrar(id);
}

async function borrar(id) {
  try {
    await api.delete(`/admin/users/${id}`);
    msg.value = 'Usuario eliminado';
    await load();
  } catch (e) {
    console.error(e);
    msg.value = 'Error eliminando usuario';
  }
}

function goto(url) {
  if (!url) return;
  // url viene absoluta; convertimos a ruta relativa para axios baseURL
  // si tu api baseURL pone /api/ delante, quita el dominio si existe
  const u = url.replace(window.location.origin + '/api', '');
  load(u);
}

load();
</script>

<style scoped>
.page{ padding:16px; }
.controls{ margin-bottom:8px; }
table{ width:100%; border-collapse:collapse; margin-top:8px; }
th,td{ border:1px solid #ddd; padding:8px; text-align:left; }
.msg{ margin-top:10px; color:green; }
.pagination{ margin-top:8px; }
</style>
