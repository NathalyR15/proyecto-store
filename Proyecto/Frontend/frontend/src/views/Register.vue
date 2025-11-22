<template>
  <div>
    <h2>Register</h2>
    <form @submit.prevent="doRegister">
      <input v-model="name" placeholder="Name" />
      <input v-model="email" placeholder="Email" />
      <input v-model="password" type="password" placeholder="Password" />
      <input v-model="password_confirmation" type="password" placeholder="Confirm password" />
      <button type="submit">Register</button>
    </form>
    <p v-if="error">{{ error }}</p>
  </div>
</template>

<script>
import { ref } from 'vue';
import { useAuthStore } from '../stores/auth';
import { useRouter } from 'vue-router';

export default {
  setup() {
    const auth = useAuthStore();
    const router = useRouter();
    const name = ref('');
    const email = ref('');
    const password = ref('');
    const password_confirmation = ref('');
    const error = ref(null);

    async function doRegister(){
      try {
        await auth.register(name.value, email.value, password.value, password_confirmation.value);
        router.push('/productos');
      } catch(e) {
        error.value = e.response?.data?.message || 'Error registro';
      }
    }

    return { name, email, password, password_confirmation, doRegister, error };
  }
}
</script>
