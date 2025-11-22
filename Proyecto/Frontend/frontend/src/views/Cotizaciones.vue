<!-- src/views/Cotizaciones.vue -->
<template>
  <div class="page">
    <h1>Cotización</h1>

    <div v-if="cart.count === 0">
      <p>Carrito vacío</p>
      <router-link to="/productos">Volver a productos</router-link>
      </div>

    <div v-else>
      <table>
        <thead><tr><th>Producto</th><th>Cant</th><th>Precio</th><th>Subtotal</th></tr></thead>
        <tbody>
          <tr v-for="it in cart.items" :key="it.producto_id">
            <td>{{ it.nombre }}</td>
            <td>{{ it.cantidad }}</td>
            <td>{{ it.precio.toFixed(2) }}</td>
            <td>{{ (it.cantidad * parseFloat(it.precio)).toFixed(2) }}</td>
          </tr>
        </tbody>
      </table>

      <p>Total: <strong>{{ cart.subtotal.toFixed(2) }}</strong></p>

      <div class="form">
        <label>Correo (opcional)</label>
        <input v-model="email" placeholder="cliente@ejemplo.com" />
      </div>

      <div>
        <button @click="onCotizar" :disabled="busy">Generar cotización</button>
        <button @click="goToCheckout">Ir a Checkout</button>
      </div>

      <div v-if="msg" class="msg">{{ msg }}</div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useCartStore } from '../stores/cart';
import { useRouter } from 'vue-router';

const cart = useCartStore();
const router = useRouter();
const email = ref('');
const busy = ref(false);
const msg = ref('');

async function onCotizar() {
  busy.value = true;
  msg.value = '';
  try {
    // cart.cotizar debe devolver res.data (el objeto cotizacion)
    const res = await cart.cotizar(email.value || null);
    // res puede venir como objeto o en res.data; normalizamos:
    const cot = res?.data ?? res;
    const id = cot?.id;
    if (id) {
      msg.value = `Cotización creada correctamente. ID: ${id}`;
      // Abrir PDF en nueva pestaña:
      const pdfUrl = `${import.meta.env.VITE_API_BASE || 'http://127.0.0.1:8000/api'}/cotizaciones/${id}/pdf`;
      window.open(pdfUrl, '_blank');
    } else {
      msg.value = 'Cotización creada (no se recibió id).';
      console.log('cotizacion response', res);
    }
  } catch (e) {
    msg.value = e.response?.data?.message || e.response?.data?.error || e.message || 'Error creando cotización';
    console.error(e);
  } finally { busy.value = false; }
}


function goToCheckout(){ router.push('/checkout'); }
</script>

<style scoped>
.page { padding: 16px; }
table { width:100%; border-collapse: collapse; margin-bottom: 12px; }
th,td { border:1px solid #ddd; padding:8px; text-align:left; }
.form { margin:8px 0; }
.msg { margin-top:8px; color: rgb(255, 6, 6); }
</style>
