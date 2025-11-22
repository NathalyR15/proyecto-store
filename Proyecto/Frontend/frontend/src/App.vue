<!-- src/App.vue -->
<template>
  <div id="app">
    <Navbar />
    <main>
      <router-view />
    </main>
  </div>
</template>

<script setup>
import Navbar from './components/Navbar.vue'
</script>

<style>
/* opcional: margen para evitar que el contenido quede debajo del navbar */
main {
  padding-top: 72px; /* ajusta si tu navbar es de otra altura */
}
</style>
