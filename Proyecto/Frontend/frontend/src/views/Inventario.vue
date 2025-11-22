<template>
  <div>
    <h2>Inventario sucursal {{ id }}</h2>
    <ul>
      <li v-for="i in inventario" :key="i.id">
        {{ i.producto.nombre }} — {{ i.cantidad }}
      </li>
    </ul>
  </div>
</template>

<script>
import api from '../services/api';
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';

export default {
  setup() {
    const route = useRoute();
    const id = route.params.id;
    const inventario = ref([]);
    onMounted(async () => {
      const res = await api.get(`/sucursales/${id}/inventario`);
      inventario.value = res.data;
    });
    return { inventario, id };
  }
}
</script>
