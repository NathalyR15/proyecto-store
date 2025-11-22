// src/router/index.js
import { createRouter, createWebHistory } from 'vue-router';

// vistas públicas
import Productos from '../views/Productos.vue';
import Sucursales from '../views/Sucursales.vue';
import Login from '../views/Login.vue';
import Register from '../views/Register.vue';
import Checkout from '../views/Checkout.vue';
import Cotizaciones from '../views/Cotizaciones.vue';
import AdminAjustarStock from '../views/AdminAjustarStock.vue';

// vistas admin/gerente (pueden crearse si no existen)
import Admin from '../views/Admin.vue';
import AdminProductos from '../views/AdminProductos.vue';
import AdminTraslados from '../views/AdminTraslados.vue';
import AdminReportes from '../views/AdminReportes.vue';
import AdminUsuarios from '../views/AdminUsuarios.vue';

const routes = [
  { path: '/', redirect: '/productos' },

  // Tienda pública
  { path: '/productos', name: 'productos', component: Productos },
  { path: '/sucursales', name: 'sucursales', component: Sucursales },

  // Auth / flujo público
  { path: '/login', name: 'login', component: Login, meta: { guest: true } },
  { path: '/register', name: 'register', component: Register, meta: { guest: true } },

  { path: '/checkout', name: 'checkout', component: Checkout },
  { path: '/cotizaciones', name: 'cotizaciones', component: Cotizaciones },

  // Admin area (panel) - permitir acceso a usuarios autenticados con rol admin OR gerente.
  // El panel en sí es accesible para admin y gerente; cada enlace interno decide qué mostrar.
  {
    path: '/admin',
    name: 'admin.index',
    component: Admin,
    meta: { requiresAuth: true } // no "requiresAdmin" para que gerente también entre
  },
  // Rutas específicas del área administrativa:
  {
    path: '/admin/productos',
    name: 'admin.productos',
    component: AdminProductos,
    meta: { requiresAuth: true, requiresAdminOrGerente: true } // ambos pueden
  },
  {
    path: '/admin/traslados',
    name: 'admin.traslados',
    component: AdminTraslados,
    meta: { requiresAuth: true, requiresAdminOrGerente: true } // ambos pueden
  },
  {
    path: '/admin/usuarios',
    name: 'admin.usuarios',
    component: AdminUsuarios,
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/admin/reportes',
    name: 'admin.reportes',
    component: AdminReportes,
    meta: { requiresAuth: true, requiresGerente: true } // solo gerente (o admin si quieres)
  },

  // Ruta específica para ajustar stock de una sucursal
  {
    path: '/admin/sucursales/:id/ajustar',
    name: 'admin.ajustarStock',
    component: AdminAjustarStock,
    meta: { requiresAuth: true, requiresAdminOrGerente: true },
    props: true
  },

  // fallback
  { path: '/:pathMatch(.*)*', redirect: '/productos' },
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

// guard global: usa el store de auth (Pinia)
import { useAuthStore } from '../stores/auth';

router.beforeEach((to, from, next) => {
  const auth = useAuthStore();

  // si ruta requiere autenticación
  if (to.meta?.requiresAuth && !auth.isLogged) {
    return next({ name: 'login', query: { next: to.fullPath }});
  }

  // requiere "admin" estricto (si en el futuro usas)
  if (to.meta?.requiresAdmin) {
    if (!auth.isLogged) return next({ name: 'login', query: { next: to.fullPath }});
    if (auth.user?.role !== 'admin') return next({ name: 'productos' });
  }

  // requiere "gerente" (solo gerente) - si quieres permitir admin también, modifica la condición
  if (to.meta?.requiresGerente) {
    if (!auth.isLogged) return next({ name: 'login', query: { next: to.fullPath }});
    // si quieres que admin también vea reportes, cambia la condición a: if (!['gerente','admin'].includes(auth.user?.role))
    if (auth.user?.role !== 'gerente') return next({ name: 'productos' });
  }

  // requiere admin o gerente (either)
  if (to.meta?.requiresAdminOrGerente) {
    if (!auth.isLogged) return next({ name: 'login', query: { next: to.fullPath }});
    if (!['admin','gerente'].includes(auth.user?.role)) return next({ name: 'productos' });
  }

  // si es guest y ya estás autenticado, redirigir a tienda
  if (to.meta?.guest && auth.isLogged) {
    return next({ name: 'productos' });
  }

  return next();
});

export default router;
