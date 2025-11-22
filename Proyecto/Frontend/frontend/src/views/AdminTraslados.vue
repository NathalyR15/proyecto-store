<!-- src/views/AdminTraslados.vue -->
<template>
  <div class="admin-traslados page">
    <h2>Traslados entre Sucursales</h2>

    <div class="form">
      <label>Producto</label>
      <select v-model="form.producto_id">
        <option value="" disabled>-- selecciona --</option>
        <option v-for="p in productos" :key="p.id" :value="p.id">{{ p.nombre }}</option>
      </select>

      <label>Origen</label>
      <select v-model="form.origen_id">
        <option value="" disabled>-- selecciona --</option>
        <option v-for="s in sucursales" :key="s.id" :value="s.id">{{ s.nombre }}</option>
      </select>

      <label>Destino</label>
      <select v-model="form.destino_id">
        <option value="" disabled>-- selecciona --</option>
        <option v-for="s in sucursales" :key="s.id" :value="s.id">{{ s.nombre }}</option>
      </select>

      <label>Cantidad</label>
      <input type="number" v-model.number="form.cantidad" min="1" />

      <div>
        <button @click="crear" :disabled="busyCreate">Crear traslado</button>
        <button @click="resetForm" type="button">Limpiar</button>
      </div>
    </div>

    <h3>Traslados recientes</h3>
    <div v-if="loading">Cargando...</div>

    <table v-else class="tabla">
      <thead>
        <tr><th>ID</th><th>Producto</th><th>Origen</th><th>Destino</th><th>Cantidad</th><th>Estado</th><th>Acción</th></tr>
      </thead>
      <tbody>
        <tr v-for="t in traslados" :key="t.id">
          <td>{{ t.id }}</td>
          <td>{{ t.producto?.nombre ?? t.producto_id }}</td>
          <td>{{ t.origen?.nombre ?? t.origen_id }}</td>
          <td>{{ t.destino?.nombre ?? t.destino_id }}</td>
          <td>{{ t.cantidad }}</td>
          <td>{{ t.estado }}</td>
          <td>
            <button v-if="t.estado === 'pendiente'" @click="completar(t.id)" :disabled="busyComplete === t.id">
              {{ busyComplete === t.id ? 'Procesando...' : 'Completar' }}
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <div v-if="msg" class="msg">{{ msg }}</div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import api from '../services/api';

const productos = ref([]);
const sucursales = ref([]);
const traslados = ref([]);
const form = ref({ producto_id: null, origen_id: null, destino_id: null, cantidad: 1 });
const loading = ref(false);
const busyCreate = ref(false);
const busyComplete = ref(null);
const msg = ref('');

async function fetchAll(){
  loading.value = true;
  try {
    const [pRes, sRes, tRes] = await Promise.all([
      api.get('/productos'),
      api.get('/sucursales'),
      api.get('/traslados') // requiere token si está protegido
    ]);
    productos.value = pRes.data.data ?? pRes.data ?? [];
    sucursales.value = sRes.data.data ?? sRes.data ?? [];
    traslados.value = tRes.data.data ?? tRes.data ?? [];
  } catch(e){
    console.error(e);
    msg.value = e.response?.data?.message || 'Error cargando datos';
  } finally { loading.value = false; }
}

function resetForm() {
  form.value = { producto_id: null, origen_id: null, destino_id: null, cantidad: 1 };
}

async function crear(){
  msg.value = '';
  busyCreate.value = true;
  try {
    const payload = { ...form.value };
    await api.post('/traslados', payload);
    msg.value = 'Traslado creado';
    resetForm();
    await fetchAll();
  } catch(e){
    console.error(e);
    msg.value = e.response?.data?.error || e.response?.data?.message || 'Error creando traslado';
  } finally { busyCreate.value = false; }
}

async function completar(id){
  msg.value = '';
  busyComplete.value = id;
  try {
    await api.post(`/traslados/${id}/completar`);
    msg.value = 'Traslado completado';
    await fetchAll();
  } catch(e){
    console.error(e);
    msg.value = e.response?.data?.error || e.response?.data?.message || 'Error completando traslado';
  } finally {
    busyComplete.value = null;
  }
}

onMounted(fetchAll);
</script>

<style scoped>
.page { padding:1rem; }
.form { display:grid; gap:.5rem; max-width:540px; margin-bottom:1rem; }
.tabla { width:100%; border-collapse:collapse; margin-top:0.5rem; }
.tabla th, .tabla td { border:1px solid #ccc; padding:6px; }
.msg { color:green; margin-top:8px; }
</style>
