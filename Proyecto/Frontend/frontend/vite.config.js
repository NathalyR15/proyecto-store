import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    host: true,
    port: 5173,
    proxy: {
      '/api': {
        target: 'http://host.docker.internal:8080',
        changeOrigin: true,
        secure: false
      },
      '/storage': {
        target: 'http://host.docker.internal:8080',
        changeOrigin: true,
        secure: false
      }
    }
  }
})
