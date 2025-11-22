<!-- src/views/AdminProductos.vue -->
<template>
  <div class="admin-productos page">
    <h2>Administrar Productos</h2>

    <div class="controls">
      <button class="btn" @click="openNew">Nuevo producto</button>
    </div>

    <div v-if="loading" class="loading">Cargando productos...</div>

    <table v-else class="tbl">
      <thead>
        <tr>
          <th>#</th>
          <th>Imagen</th>
          <th>SKU</th>
          <th>Nombre</th>
          <th>Precio</th>
          <th>Inventario</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="p in productos" :key="p.id">
          <td>{{ p.id }}</td>
          <td class="thumb-cell">
            <img v-if="p.imagen" :src="imgUrl(p.imagen)" alt="img" class="thumb" />
            <span v-else class="no-thumb">—</span>
          </td>
          <td>{{ p.sku }}</td>
          <td>{{ p.nombre }}</td>
          <td>{{ Number(p.precio).toFixed(2) }}</td>
          <td>{{ p.inventarios_count ?? p.inventarios?.length ?? '-' }}</td>
          <td>
            <button class="btn small" @click="openEdit(p)">Editar</button>
            <button class="btn small danger" @click="borrar(p.id)">Eliminar</button>
          </td>
        </tr>
      </tbody>
    </table>

    <div v-if="msg" class="msg" :class="{ error: msgError }">{{ msg }}</div>

    <!-- Modal (create / edit) -->
    <div v-if="showModal" class="modal-backdrop" @click.self="closeModal">
      <div class="modal">
        <h3>{{ editing ? 'Editar producto' : 'Nuevo producto' }}</h3>

        <div class="form-grid">
          <label>SKU</label>
          <input v-model="form.sku" placeholder="PXXXX" />

          <label>Nombre</label>
          <input v-model="form.nombre" />

          <label>Descripción</label>
          <textarea v-model="form.descripcion" rows="3"></textarea>

          <label>Precio</label>
          <input type="number" step="0.01" v-model.number="form.precio" />

          <label>Imagen (jpg/png) — max 2MB</label>
          <input type="file" accept="image/*" @change="onFileChange" />

          <div class="preview-col">
            <label>Preview</label>
            <div class="preview">
              <img v-if="previewUrl" :src="previewUrl" alt="preview" />
              <div v-else class="no-thumb">Sin imagen</div>
            </div>
          </div>
        </div>

        <div class="modal-actions">
          <button class="btn" @click="submit" :disabled="saving">
            {{ saving ? 'Guardando...' : (editing ? 'Guardar cambios' : 'Crear producto') }}
          </button>
          <button class="btn ghost" @click="closeModal">Cancelar</button>
        </div>

        <div v-if="formError" class="form-error">{{ formError }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import api from '../services/api';
import { useAuthStore } from '../stores/auth';

const auth = useAuthStore();

// estado
const productos = ref([]);
const loading = ref(false);
const msg = ref('');
const msgError = ref(false);

// modal / form
const showModal = ref(false);
const editing = ref(false);
const editingId = ref(null);
const saving = ref(false);
const formError = ref('');
const previewUrl = ref('');
const file = ref(null);

const form = ref({
  sku: '',
  nombre: '',
  descripcion: '',
  precio: null,
  // imagen no va aquí: usamos `file`
});

function imgUrl(path) {
  // si tu backend expone storage en /storage/...
  const base = import.meta.env.VITE_API_BASE?.replace(/\/api\/?$/,'') || 'http://127.0.0.1:8000';
  return `${base}/storage/${path}`;
}

async function fetchProductos() {
  loading.value = true;
  try {
    const res = await api.get('/productos');
    productos.value = res.data.data ?? res.data ?? [];
  } catch (e) {
    console.error(e);
    msg.value = 'Error cargando productos';
    msgError.value = true;
  } finally {
    loading.value = false;
  }
}

function resetForm() {
  form.value = { sku: '', nombre: '', descripcion: '', precio: null };
  file.value = null;
  previewUrl.value = '';
  formError.value = '';
  editing.value = false;
  editingId.value = null;
}

function openNew() {
  resetForm();
  showModal.value = true;
}

function openEdit(p) {
  resetForm();
  editing.value = true;
  editingId.value = p.id;
  form.value.sku = p.sku;
  form.value.nombre = p.nombre;
  form.value.descripcion = p.descripcion;
  form.value.precio = Number(p.precio);
  // si tiene imagen remote, mostrar preview
  if (p.imagen) previewUrl.value = imgUrl(p.imagen);
  showModal.value = true;
}

function closeModal() {
  showModal.value = false;
  resetForm();
}

function onFileChange(e) {
  const f = e.target.files[0];
  if (!f) return;
  // validaciones básicas
  if (!f.type.startsWith('image/')) {
    formError.value = 'Solo se permiten imágenes';
    return;
  }
  if (f.size > 2 * 1024 * 1024) {
    formError.value = 'Imagen demasiado grande (máx 2MB)';
    return;
  }
  file.value = f;
  previewUrl.value = URL.createObjectURL(f);
}

// crear o actualizar
async function submit() {
  formError.value = '';
  // validaciones frontend
  if (!form.value.sku || !form.value.nombre || !form.value.precio) {
    formError.value = 'Completa SKU, nombre y precio';
    return;
  }

  saving.value = true;
  try {
    const fd = new FormData();
    fd.append('sku', form.value.sku);
    fd.append('nombre', form.value.nombre);
    fd.append('descripcion', form.value.descripcion ?? '');
    fd.append('precio', form.value.precio);

    if (file.value) fd.append('imagen', file.value);

    if (editing.value && editingId.value) {
      // Laravel: multipart + method override
      fd.append('_method', 'PUT');
      await api.post(`/productos/${editingId.value}`, fd, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });
      msg.value = 'Producto actualizado';
      msgError.value = false;
    } else {
      await api.post('/productos', fd, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });
      msg.value = 'Producto creado';
      msgError.value = false;
    }

    closeModal();
    await fetchProductos();
  } catch (e) {
    console.error(e);
    formError.value = e.response?.data?.message || (e.response?.data?.errors ? JSON.stringify(e.response.data.errors) : e.message);
  } finally {
    saving.value = false;
  }
}

// eliminar
async function borrar(id) {
  if (!confirm('Eliminar producto?')) return;
  try {
    await api.delete(`/productos/${id}`);
    msg.value = 'Producto eliminado';
    msgError.value = false;
    await fetchProductos();
  } catch (e) {
    console.error(e);
    msg.value = 'Error eliminando producto';
    msgError.value = true;
  }
}

onMounted(fetchProductos);
</script>

<style scoped>
.page { padding: 1rem; }
.controls { margin-bottom: 12px; }
.btn { background:#0b64a3; color:white; border:none; padding:8px 12px; border-radius:6px; cursor:pointer; }
.btn.small { padding:4px 8px; font-size:.9rem; }
.btn.ghost { background:transparent; border:1px solid #ccc; color:#111; }
.btn.danger { background:#a33; color:#fff; }
.tbl { width:100%; border-collapse: collapse; margin-top:8px; }
.tbl th, .tbl td { border: 1px solid #444; padding:8px; text-align:left; color:#eee; }
.thumb { width:48px; height:48px; object-fit:cover; border-radius:4px; display:block; }
.thumb-cell { width:64px; }
.no-thumb { color:#999; font-size:.9rem; }

/* modal */
.modal-backdrop { position:fixed; inset:0; background:rgba(0,0,0,0.6); display:flex; align-items:center; justify-content:center; z-index:2000; }
.modal { background:#111; color:#f5f5f5; padding:16px; border-radius:8px; width:720px; max-width:95%; box-shadow:0 8px 30px rgba(0,0,0,.6); }
.form-grid { display:grid; grid-template-columns: 1fr 1fr; gap:10px; align-items:start; }
.preview-col { grid-column: 1 / span 1; }
.preview { width:100%; height:100%; min-height:80px; display:flex; align-items:center; justify-content:center; background:#222; border-radius:6px; overflow:hidden; }
.preview img { max-width:100%; max-height:160px; display:block; }
.modal-actions { margin-top:12px; display:flex; gap:8px; }
.form-error { margin-top:8px; color:#ff7b7b; }
.msg { margin-top:12px; color:green; }
.msg.error { color:#ff9b9b; }
</style>
