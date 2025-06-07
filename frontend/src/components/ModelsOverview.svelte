<script>
  let { models, selectedModel, onselectmodel } = $props();
  
  function selectModel(modelName) {
    onselectmodel?.(modelName);
  }
</script>

<div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6 mb-8 transition-colors duration-200">
  <h2 class="text-2xl font-semibold text-gray-800 dark:text-white mb-4">Data Models</h2>
  
  {#if models.length > 0}
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      {#each models as model}
        <div class="border border-gray-200 dark:border-gray-600 rounded-lg p-4 hover:shadow-md dark:hover:shadow-lg transition-shadow bg-white dark:bg-gray-700">
          <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">{model.name}</h3>
          <div class="text-sm text-gray-600 dark:text-gray-300 space-y-1">
            <p><span class="font-medium">Attributes:</span> {model.attributeCount}</p>
            <p><span class="font-medium">Relationships:</span> {model.relationshipCount}</p>
            <p><span class="font-medium">Entity Count:</span> {model.entityCount}</p>
          </div>
          <div class="mt-3">
            <button 
              onclick={() => selectModel(model.name)}
              class="text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 text-sm font-medium transition-colors duration-200"
            >
              {selectedModel === model.name ? 'Hide Details' : 'View Details →'}
            </button>
          </div>
        </div>
      {/each}
    </div>
  {:else}
    <!-- Empty state -->
    <div class="text-center py-8">
      <div class="text-gray-400 dark:text-gray-500 text-lg mb-2">No models found</div>
      <p class="text-gray-500 dark:text-gray-400">Make sure your Core Data model is properly configured.</p>
    </div>
  {/if}
</div>