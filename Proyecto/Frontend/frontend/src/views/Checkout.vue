<!-- src/views/Checkout.vue -->
<template>
  <div class="page">
    <h1>Checkout</h1>

    <div v-if="cart.items.length === 0">
      <p>El carrito está vacío.</p>
      <router-link to="/productos">Volver a productos</router-link>
      </div>

    <div v-else>
      <ul>
        <li v-for="it in cart.items" :key="it.producto_id">
          {{ it.nombre }} — {{ it.cantidad }} x {{ (it.precio_unit ?? it.precio).toFixed(2) }} = {{ (it.cantidad * (it.precio_unit ?? it.precio)).toFixed(2) }}
          <button @click="remove(it.producto_id)">Quitar</button>
        </li>
      </ul>

      <p><strong>Total: </strong> {{ cart.subtotal.toFixed(2) }}</p>

      <div v-if="!auth.isLogged">
        <p>Debes iniciar sesión para finalizar la compra.</p>
        <router-link to="/login">Ir a Login</router-link>
      </div>

      <div v-else>
        <button @click="doCheckout" :disabled="processing">{{ processing ? 'Procesando...' : 'Pagar y crear venta' }}</button>

        <p v-if="error" style="color:red">{{ error }}</p>

        <div v-if="order">
          <h3>Venta creada (ID: {{ order.id }})</h3>
          <pre>{{ order }}</pre>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useCartStore } from '../stores/cart';
import { useAuthStore } from '../stores/auth';
import { useRouter } from 'vue-router';

const cart = useCartStore();
const auth = useAuthStore();
const router = useRouter();

const processing = ref(false);
const error = ref(null);
const order = ref(null);

function remove(id) { cart.removeItem(id); }

async function doCheckout() {
  processing.value = true;
  error.value = null;
  try {
    // si no está logueado, redirigir a login
    if (!auth.isLogged) {
      router.push('/login');
      return;
    }
    const res = await cart.checkout(); // usa api.post('/ventas')
    order.value = res;
  } catch (e) {
    if (e.response?.status === 401) {
      error.value = 'Debes iniciar sesión.';
    } else if (e.response?.status === 422) {
      error.value = JSON.stringify(e.response.data.errors || e.response.data);
    } else {
      error.value = e.message || 'Error al procesar pago';
    }
    console.error(e);
  } finally {
    processing.value = false;
  }
}
</script>

<style scoped>
.page { padding: 16px; }
button { margin-left: 8px; }
</style>
