// src/stores/cart.js
import { defineStore } from 'pinia';
import api from '../services/api';

export const useCartStore = defineStore('cart', {
  state: () => ({
    items: [], // { producto_id, nombre, precio, precio_unit?, cantidad }
    sucursalId: null,
  }),
  getters: {
    count: (s) => s.items.reduce((a,b) => a + Number(b.cantidad), 0),
    subtotal: (s) => s.items.reduce((a,b) => a + Number(b.cantidad) * Number(b.precio_unit ?? b.precio ?? 0), 0),
  },
  actions: {
    // setear sucursal (id)
    setSucursal(id) {
      this.sucursalId = Number(id);
    },

    // agregar item, si ya existe sumar cantidad
    addItem(item) {
      const pid = Number(item.producto_id);
      let exist = this.items.find(x => Number(x.producto_id) === pid);
      if (exist) {
        exist.cantidad = Number(exist.cantidad) + Number(item.cantidad || 1);
        if (item.precio_unit) exist.precio_unit = item.precio_unit;
      } else {
        this.items.push({
          producto_id: pid,
          nombre: item.nombre,
          precio: Number(item.precio),
          precio_unit: item.precio_unit ? Number(item.precio_unit) : undefined,
          cantidad: Number(item.cantidad || 1)
        });
      }
    },

    removeItem(producto_id) {
      this.items = this.items.filter(i => Number(i.producto_id) !== Number(producto_id));
    },

    clear() {
      this.items = [];
      // mantenemos sucursalId por si el usuario quiere seguir comprando en la misma sucursal
    },

    // crear cotizacion (pública) -> payload que espera backend
    async cotizar(cliente_email = null) {
      if (!this.sucursalId) throw new Error('Selecciona una sucursal antes de cotizar.');
      if (!this.items.length) throw new Error('Carrito vacío.');

      const payload = {
        sucursal_id: Number(this.sucursalId),
        cliente_email: cliente_email || null,
        items: this.items.map(i => ({ producto_id: Number(i.producto_id), cantidad: Number(i.cantidad) }))
      };

      const res = await api.post('/cotizaciones', payload);
      return res.data;   // importante

    },

    // checkout -> crea venta (requiere token)
    async checkout() {
      if (!this.sucursalId) throw new Error('Selecciona una sucursal antes de pagar.');
      if (!this.items.length) throw new Error('Carrito vacío.');

      const payload = {
        sucursal_id: Number(this.sucursalId),
        items: this.items.map(i => ({
          producto_id: Number(i.producto_id),
          cantidad: Number(i.cantidad),
          precio: Number(i.precio_unit ?? i.precio ?? 0)
        }))
      };

      const res = await api.post('/ventas', payload); // requiere Authorization en headers
      this.clear();
      return res.data;
    }
  }
});
