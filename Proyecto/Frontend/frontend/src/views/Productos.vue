<!-- src/views/Productos.vue -->
<template>
  <div class="page">
    <h1>Productos</h1>

    <div v-if="loading">Cargando...</div>

    <div v-else>
      <div class="controls">
        <label>Seleccionar sucursal:</label>
        <select v-model="sucursalId" @change="onSucursalChange">
          <option v-for="s in sucursales" :key="s.id" :value="s.id">
            {{ s.nombre }} — {{ s.ciudad || 'Sin ciudad' }}
          </option>
        </select>

        <router-link to="/cotizaciones" class="btn">Solicitar cotización</router-link>

        <!-- mini resumen del carrito -->
        <div class="cart-summary">
          <strong>Carrito:</strong>
          <span v-if="cart.count === 0"> vacío</span>
          <span v-else>{{ cart.count }} item(s) — Q{{ totalLabel }}</span>
          <router-link to="/checkout" v-if="cart.count">Ir a Checkout</router-link>
        </div>
      </div>

      <ul class="product-list">
        <li v-for="p in productos" :key="p.id" class="product-item">
          <div class="thumb">
            <img :src="imgUrl(p.imagen)" :alt="p.nombre" />
          </div>

          <div class="info">
            <div class="title">
              <strong>{{ p.sku }}</strong> — {{ p.nombre }}
              <span class="price">Q{{ formatPrice(p.precio) }}</span>
            </div>
            <div class="desc">{{ p.descripcion }}</div>
          </div>

          <div class="actions">
            <input type="number" v-model.number="qtys[p.id]" min="1" style="width:70px" />
            <button @click="addToCart(p)" :disabled="!sucursalId">Agregar</button>
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue';
import api from '../services/api';
import { useCartStore } from '../stores/cart';
import { useAuthStore } from '../stores/auth';

const productos = ref([]);
const sucursales = ref([]);
const loading = ref(true);
const sucursalId = ref(null);
const qtys = reactive({});

const cart = useCartStore();
const auth = useAuthStore();

// si cart.subtotal existe, úsalo; si no, calcula local
const totalLabel = computed(() => {
  if (typeof cart.subtotal === 'number') return cart.subtotal.toFixed(2);
  const total = cart.items.reduce((acc, it) => acc + it.cantidad * parseFloat(it.precio || it.precio_unit || 0), 0);
  return total.toFixed(2);
});

function formatPrice(v) {
  if (v == null) return '0.00';
  return Number(v).toFixed(2);
}

// Construye URL para la imagen. Si backend devuelve path relativo ('productos/xxx.jpg')
// lo convertimos a /storage/ + path usando el host/base API.
function imgUrl(imagenPath) {
  if (!imagenPath) {
    return '/placeholder-product.png'; // crea un placeholder en public/placeholder-product.png o cambiar a data-uri
  }
  // si ya viene como URL absoluta
  if (imagenPath.startsWith('http') || imagenPath.startsWith('data:')) return imagenPath;

  // si backend expone imágenes por /storage/{path}
  // determinamos base: si VITE_API_BASE existe y termina con /api lo quitamos
  const apiBase = import.meta.env.VITE_API_BASE || 'http://127.0.0.1:8000/api';
  let siteBase = apiBase;
  if (siteBase.endsWith('/api')) siteBase = siteBase.slice(0, -4);
  // asegúrate de que imagenPath no comience con slash
  const p = imagenPath.replace(/^\/+/, '');
  return `${siteBase}/storage/${p}`;
}

async function fetch() {
  loading.value = true;
  try {
    const [pRes, sRes] = await Promise.all([api.get('/productos'), api.get('/sucursales')]);
    productos.value = pRes.data.data ?? pRes.data ?? [];
    sucursales.value = sRes.data.data ?? sRes.data ?? [];
    if (sucursales.value.length && !sucursalId.value) {
      sucursalId.value = sucursales.value[0].id;
      cart.setSucursal(sucursalId.value);
    }
    productos.value.forEach(p => { qtys[p.id] = qtys[p.id] ?? 1; });
  } catch (e) {
    console.error('Error fetching productos/sucursales', e);
    productos.value = [];
    sucursales.value = [];
  } finally {
    loading.value = false;
  }
}

function onSucursalChange() {
  cart.setSucursal(sucursalId.value);
}

function addToCart(p) {
  const cantidad = Number(qtys[p.id]) || 1;
  if (typeof cart.add === 'function') {
    cart.add(p, cantidad);
  } else if (typeof cart.addItem === 'function') {
    cart.addItem({
      producto_id: p.id,
      producto: p,
      nombre: p.nombre,
      precio: p.precio,
      cantidad
    });
  } else {
    console.error('Método de añadir al carrito no encontrado en store', cart);
  }
}

onMounted(fetch);
</script>

<style scoped>
.page { padding: 1rem; }
.controls { display:flex; gap:1rem; align-items:center; margin-bottom:1rem; }
.product-list { list-style:none; padding:0; display:flex; flex-direction:column; gap:.75rem; }
.product-item { display:flex; gap:1rem; align-items:center; padding:0.5rem; border-bottom:1px solid #eee; }
.thumb img { width:96px; height:96px; object-fit:cover; border-radius:6px; background:#fff; }
.info { flex:1; }
.title { display:flex; align-items:center; gap:1rem; justify-content:space-between; }
.price { font-weight:700; color:#ffffff; }
.actions { display:flex; gap:.5rem; align-items:center; }
.cart-summary { margin-left:auto; }
.desc { color:#666; font-size:.9rem; margin-top:.25rem; }
</style>
