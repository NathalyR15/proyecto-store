<!-- src/views/Admin.vue -->
<template>
  <div class="admin-page">
    <header class="admin-header">
      <div>
        <h1>Panel de Administración</h1>
        <div class="who">Usuario: <strong>{{ auth.user?.name ?? '—' }}</strong>
          <span class="role" v-if="auth.user">({{ auth.user.role }})</span>
        </div>
      </div>
    </header>

    <nav class="admin-nav" aria-label="Navegación administrativa">
      <!-- Enlaces que ADMIN y GERENTE deben ver -->
      <router-link to="/admin/productos" class="nav-link">Productos (CRUD)</router-link>
      <router-link to="/admin/traslados" class="nav-link">Traslados</router-link>
      <router-link :to="{ name: 'admin.ajustarStock', params: { id: 1 } }" class="nav-link">
        Ajustar stock (Sucursal 1)
      </router-link>

      <!-- Enlaces solo para GERENTE (Gerente = puede todo de admin + reportes + usuarios) -->
      <router-link v-if="isGerente" to="/admin/reportes" class="nav-link">Reportes</router-link>
      <router-link v-if="isGerente" to="/admin/usuarios" class="nav-link">Usuarios</router-link>
    </nav>

    <section class="admin-content">
      <router-view />
      <p style="color: #666;">Selecciona una opción de la izquierda</p>
    </section>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useAuthStore } from '../stores/auth';

const auth = useAuthStore();

// helper computed
const isGerente = computed(() => auth.user?.role === 'gerente');
const isAdmin = computed(() => auth.user?.role === 'admin');

// Nota: con esta lógica el "admin" ve solo los 3 enlaces básicos.
// el "gerente" ve esos 3 + "Reportes" y "Usuarios".
</script>

<style scoped>
.admin-page { padding: 1.25rem; font-family: Inter, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial; color:#ffffff; }

/* Header */
.admin-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:12px; }
.admin-header h1 { margin:0; font-size:1.25rem; }
.who { margin-top:6px; color:#ffffff; font-size:0.95rem; }
.role { color:#0ffc99; margin-left:6px; font-weight:600; }

/* Nav */
.admin-nav {
  display:flex;
  gap:0.5rem;
  margin-bottom:1rem;
  flex-wrap:wrap;
}
.nav-link {
  display:inline-block;
  background:#ffffff;
  color:rgb(83, 82, 82);
  padding:8px 12px;
  border-radius:6px;
  text-decoration:none;
  transition: transform .08s ease, box-shadow .08s ease;
}
.nav-link:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(0,0,0,0.12); }

/* Content area */
.admin-content { margin-top: 1rem; padding: 1rem; background: #fafafa; border-radius:8px; min-height:240px; box-shadow: 0 1px 4px rgba(16,24,40,0.04); }
</style>
