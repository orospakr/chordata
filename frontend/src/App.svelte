<script lang="ts">
  import { onMount } from 'svelte';
  import type { ModelData } from './types';
  import Header from './components/Header.svelte';
  import ModelsOverview from './components/ModelsOverview.svelte';
  import ModelDetails from './components/ModelDetails.svelte';
  import LoadingState from './components/LoadingState.svelte';
  import ErrorState from './components/ErrorState.svelte';

  let models = $state<ModelData[]>([]);
  let loading = $state(true);
  let error = $state<string | null>(null);
  let selectedModel = $state<string | null>(null);

  onMount(() => {
    loadModels();
  });

  async function loadModels() {
    try {
      loading = true;
      error = null;
      
      const response = await fetch('/api/models');
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      models = await response.json();
    } catch (err) {
      error = err instanceof Error ? err.message : 'Failed to load models';
      console.error('Error loading models:', err);
    } finally {
      loading = false;
    }
  }

  function selectModel(modelName: string) {
    selectedModel = selectedModel === modelName ? null : modelName;
  }
</script>

<div class="bg-gray-50 dark:bg-gray-900 min-h-screen transition-colors duration-200">
  <div class="container mx-auto px-4 py-8">
    <Header />
    
    {#if loading}
      <LoadingState />
    {:else if error}
      <ErrorState {error} />
    {:else}
      <ModelsOverview {models} onselectmodel={(modelName: string) => selectModel(modelName)} {selectedModel} />
      
      {#if selectedModel}
        <ModelDetails {models} {selectedModel} />
      {/if}
    {/if}
  </div>
</div>