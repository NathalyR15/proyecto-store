<!-- src/views/Sucursales.vue -->
<template>
  <section>
    <h2>Sucursales</h2>
    <div v-if="loading">Cargando sucursales…</div>
    <div v-else>
      <div v-if="sucursales.length === 0">No hay sucursales.</div>
      <ul>
        <li v-for="s in sucursales" :key="s.id" style="margin-bottom:8px">
          <strong>{{ s.nombre }}</strong> — {{ s.ciudad }}
          <button v-if="isAdmin" @click="irAjustar(s.id)">[Ajustar stock]</button>
        </li>
      </ul>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import api from '../services/api'
import { useAuthStore } from '../stores/auth'
import { useRouter } from 'vue-router'

const sucursales = ref([])
const loading = ref(true)
const auth = useAuthStore()
const router = useRouter()

const isAdmin = computed(() => auth.user?.role === 'admin')

onMounted(async () => {
  try {
    const res = await api.get('/sucursales')
    // si tu backend devuelve paginación: res.data.data
    sucursales.value = Array.isArray(res.data) ? res.data : (res.data.data ?? [])
  } catch (e) {
    console.error('error al cargar sucursales', e)
    // opcional: mostrar mensaje al usuario
  } finally {
    loading.value = false
  }
})

function irAjustar(id) {
  // si quieres proteger ruta desde frontend:
  if (!auth.isLogged) return router.push('/login')
  router.push(`/admin/sucursales/${id}/ajustar`)
}
</script>
