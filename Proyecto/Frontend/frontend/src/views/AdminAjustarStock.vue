<!-- src/views/AdminAjustarStock.vue -->
<template>
  <div>
    <h2>Ajustar stock - Sucursal {{ sucursalId }}</h2>

    <div v-if="loading">Cargando inventario...</div>

    <div v-else>
      <table>
        <thead>
          <tr><th>Producto</th><th>Cantidad</th><th>Acción</th></tr>
        </thead>
        <tbody>
          <tr v-for="it in inventario" :key="it.id">
            <td>{{ it.producto.nombre }}</td>
            <td>
              <input type="number" v-model.number="quantities[it.producto_id]" />
            </td>
            <td>
              <button @click="ajustar(it.producto_id)">Guardar</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <router-link to="/sucursales">Volver</router-link>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import api from '../services/api';
import { useRoute } from 'vue-router';

const route = useRoute();
const sucursalId = route.params.id;
const inventario = ref([]);
const quantities = ref({});
const loading = ref(true);

async function fetchInventario() {
  loading.value = true;
  try {
    const res = await api.get(`/sucursales/${sucursalId}/inventario`);
    inventario.value = res.data;
    // inicializar cantidades en inputs
    inventario.value.forEach(i => quantities.value[i.producto_id] = i.cantidad);
  } catch (e) {
    console.error(e);
  } finally {
    loading.value = false;
  }
}

async function ajustar(producto_id) {
  const cantidad = quantities.value[producto_id] ?? 0;
  try {
    const res = await api.post(`/inventario/${sucursalId}/ajustar`, { producto_id, cantidad });
    // actualizar localmente
    const idx = inventario.value.findIndex(x => x.producto_id === producto_id);
    if (idx !== -1) inventario.value[idx].cantidad = res.data.cantidad;
    alert('Stock actualizado');
  } catch (e) {
    alert('Error al actualizar: ' + (e.response?.data?.message ?? e.message));
  }
}

onMounted(fetchInventario);
</script>
