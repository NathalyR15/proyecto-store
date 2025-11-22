<!-- src/views/AdminReportes.vue -->
<template>
  <div class="page">
    <h1>Reportes</h1>

    <section>
      <h3>Top productos
        <small style="margin-left:12px;">
          <label>Sucursal:
            <select v-model.number="sucursalFilter" @change="onSucursalChange">
              <option :value="0">Todas</option>
              <option v-for="s in sucursales" :key="s.id" :value="s.id">{{ s.nombre }}</option>
            </select>
          </label>
        </small>
      </h3>

      <table v-if="topProductos.length">
        <thead><tr><th>Producto</th><th v-if="showSucursalCol">Sucursal</th><th>Vendidos</th></tr></thead>
        <tbody>
          <tr v-for="p in topProductos" :key="p.id + '-' + (p.mes ?? '')">
            <td>{{ p.nombre }}</td>
            <td v-if="showSucursalCol">{{ p.sucursal ?? '-' }}</td>
            <td>{{ p.vendidos ?? p.cantidad ?? 0 }}</td>
          </tr>
        </tbody>
      </table>
      <div v-else class="empty">No hay datos para Top productos.</div>
    </section>

    <section style="margin-top:20px">
      <h3>Stock bajo</h3>
      <table v-if="stockBajo.length">
        <thead><tr><th>Producto</th><th>Sucursal</th><th>Cantidad</th></tr></thead>
        <tbody>
          <tr v-for="r in stockBajo" :key="r.id + '-' + r.sucursal">
            <td>{{ r.nombre }}</td>
            <td>{{ r.sucursal }}</td>
            <td>{{ r.cantidad }}</td>
          </tr>
        </tbody>
      </table>
      <div v-else class="empty">No hay productos con stock bajo (menos de 10) actualmente.</div>
    </section>

    <section style="margin-top:20px; max-width:900px">
      <h3>
        Ventas por mes
        <small>(año:
          <input v-model.number="anio" style="width:90px" />
          <button @click="loadVentas">Cargar</button>)</small>
      </h3>
      <canvas id="ventasChart" style="width:100%; height:320px"></canvas>
    </section>

    <section style="margin-top:24px">
      <h3>Reportes extra</h3>
      <div style="display:flex;gap:8px;align-items:center">
        <button @click="downloadReporteProductosMes">Productos por mes (CSV)</button>
        <button @click="downloadReporteClientesFrecuentes">Clientes frecuentes (CSV)</button>
        <button @click="openRangoFecha">Reporte compras por rango</button>
      </div>
    </section>

    <!-- modal simple para rango de fechas -->
    <div v-if="showRango" class="modal-backdrop" @click.self="showRango=false">
      <div class="modal">
        <h4>Reporte por rango de fecha</h4>
        <div style="display:flex; gap:8px; align-items:center;">
          <label>Desde <input type="date" v-model="rDesde" /></label>
          <label>Hasta <input type="date" v-model="rHasta" /></label>
        </div>
        <div style="margin-top:8px; display:flex; gap:8px;">
          <button @click="downloadReporteRango" :disabled="downloadingRange">{{ downloadingRange ? 'Descargando...' : 'Descargar CSV' }}</button>
          <button @click="showRango=false">Cerrar</button>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import api from '../services/api';
import Chart from 'chart.js/auto';

const topProductos = ref([]);
const stockBajo = ref([]);
const sucursales = ref([]);
const anio = ref(new Date().getFullYear());
const sucursalFilter = ref(0);
let chart = null;
const showSucursalCol = ref(false);

const showRango = ref(false);
const rDesde = ref('');
const rHasta = ref('');
const downloadingRange = ref(false);

async function loadTop(){
  const qs = sucursalFilter.value ? `?sucursal_id=${sucursalFilter.value}` : '';
  const res = await api.get(`/reportes/top-productos${qs}`);
  topProductos.value = res.data ?? [];
  // mostrar columna sucursal cuando filtramos por sucursal (o si filas contienen sucursal)
  showSucursalCol.value = !!sucursalFilter.value || (topProductos.value.length && topProductos.value[0].sucursal !== undefined);
}

async function loadStockBajo(){
  const res = await api.get('/reportes/stock-bajo');
  stockBajo.value = res.data ?? [];
}

async function loadSucursales(){
  const res = await api.get('/sucursales');
  sucursales.value = res.data.data ?? res.data ?? [];
}

async function loadVentas(){
  const res = await api.get(`/reportes/ventas-mes?anio=${anio.value}`);
  const data = res.data ?? [];
  const labels = Array.from({length:12}, (_,i)=> `${i+1}`);
  const totals = Array(12).fill(0);
  data.forEach(r => { const m = Number(r.mes); if(m>=1&&m<=12) totals[m-1] = parseFloat(r.total); });
  const ctx = document.getElementById('ventasChart').getContext('2d');
  if(chart) chart.destroy();
  chart = new Chart(ctx, {
    type: 'bar',
    data:{ labels, datasets:[{ label:`Ventas ${anio.value}`, data: totals }]},
    options:{ responsive:true, scales:{ y:{ beginAtZero:true } } }
  });
}

function onSucursalChange(){
  loadTop();
}

async function downloadCSVFromEndpoint(path, filename = 'reporte.csv') {
  try {
    const res = await api.get(path, { responseType: 'blob' });
    const blob = new Blob([res.data], { type: res.headers['content-type'] || 'text/csv' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    a.remove();
    URL.revokeObjectURL(url);
  } catch (err) {
    console.error('Error descargando CSV', err);
    alert('Error descargando CSV: ' + (err.response?.data?.message || err.message || JSON.stringify(err)));
  }
}

function downloadReporteProductosMes(){
  downloadCSVFromEndpoint('reportes/productos-por-mes?format=csv', 'productos_por_mes.csv');
}
function downloadReporteClientesFrecuentes(){
  downloadCSVFromEndpoint('reportes/clientes-frecuentes?format=csv', 'clientes_frecuentes.csv');
}

function openRangoFecha(){ showRango.value = true; }

async function downloadReporteRango(){
  // validación clara y logging para depurar si algo falla
  console.log('descargar rango', rDesde.value, rHasta.value);
  if(!rDesde.value || !rHasta.value){ alert('Selecciona ambas fechas'); return; }
  // enviar formato yyyy-mm-dd
  downloadingRange.value = true;
  try {
    const desde = encodeURIComponent(rDesde.value);
    const hasta = encodeURIComponent(rHasta.value);
    const url = `reportes/compras-por-rango?desde=${desde}&hasta=${hasta}&format=csv`;
    await downloadCSVFromEndpoint(url, `compras_${rDesde.value}_a_${rHasta.value}.csv`);
    showRango.value = false;
  } catch(e){
    console.error(e);
    alert('Error generando reporte por rango');
  } finally {
    downloadingRange.value = false;
  }
}

onMounted(async () => {
  await Promise.all([loadTop(), loadStockBajo(), loadVentas(), loadSucursales()]);
});
</script>

<style scoped>
.page{ padding:16px;}
table{ width:100%; border-collapse:collapse; margin-bottom:10px}
th,td{ border:1px solid #ddd; padding:8px; text-align:left;}
.empty{ color:#666; margin:8px 0; }
.modal-backdrop{ position:fixed; inset:0; display:flex; align-items:center; justify-content:center; background:rgba(0,0,0,.4) }
.modal{ background:#fff; color:#111; padding:16px; border-radius:8px; min-width:300px }
</style>
