<template>
<div class="card mb-4">
    <div class="table-responsive">
        <div class="card-body">
        <div>
            <div v-html="templateContent"></div>
        </div>
        </div>
    </div>
</div>
    
</template>

<script>
import axios from 'axios';
import { ref, onMounted, inject } from 'vue';
import { useRoute } from 'vue-router';
import { ModelListSelect } from 'vue-search-select';

export default {
  components: {
    ModelListSelect,
  },
  setup() {
    const route = useRoute();
    const boxInbox = ref([]);
    const template = ref([]);
    const globalState = inject('globalState');
    const baseUrl = globalState.baseUrl;
    
    const getInbox = () => {
      axios
        .get(`${baseUrl}/api/inbox/${route.params.id}/edit`)
        .then((response) => {
          boxInbox.value = response.data.inBox;
          template.value = boxInbox.value['templates'];
        })
        .catch((error) => {
          console.log(error);
        });
    };

    onMounted(() => {
      getInbox();
    });

    return {
      templateContent: template, 
    };
  },
};
</script>
<style>

@media print {
  body {
    font-family: Arial, sans-serif;
  }

  .table {
    width: 100%;
    border-collapse: collapse;
  }

  .table th, .table td {
    border: 1px solid #000;
    padding: 8px;
    text-align: center;
  }

  .btn {
    display: none; /* Hide buttons on print */
  }

  .url, .timestamp {
    display: none;
  }
  @page {
    size: A4;
    margin: 20mm;
  }
}

</style>