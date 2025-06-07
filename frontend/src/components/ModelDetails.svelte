<script lang="ts">
  import type { ModelData } from '../types';
  
  let { models, selectedModel }: {
    models: ModelData[];
    selectedModel: string | null;
  } = $props();
  
  const currentModel = $derived(models.find((m: ModelData) => m.name === selectedModel));
</script>

{#if currentModel}
  <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6 transition-colors duration-200">
    <h2 class="text-2xl font-semibold text-gray-800 dark:text-white mb-4">Model Details</h2>
    
    <h3 class="text-xl font-medium text-gray-900 dark:text-white mb-4">{currentModel.name}</h3>
    
    <!-- Attributes -->
    <div class="mb-6">
      <h4 class="text-lg font-medium text-gray-800 dark:text-gray-200 mb-2">Attributes</h4>
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-600">
          <thead class="bg-gray-50 dark:bg-gray-700">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Name</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Type</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Optional</th>
            </tr>
          </thead>
          <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-600">
            {#each currentModel.attributes as attribute}
              <tr class="hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors duration-150">
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white">{attribute.name}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">{attribute.type}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">{attribute.optional ? 'Yes' : 'No'}</td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
    </div>
    
    <!-- Relationships -->
    {#if currentModel.relationships.length > 0}
      <div class="mb-6">
        <h4 class="text-lg font-medium text-gray-800 dark:text-gray-200 mb-2">Relationships</h4>
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-600">
            <thead class="bg-gray-50 dark:bg-gray-700">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Name</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Destination</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Type</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Optional</th>
              </tr>
            </thead>
            <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-600">
              {#each currentModel.relationships as relationship}
                <tr class="hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors duration-150">
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white">{relationship.name}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">{relationship.destinationEntity}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">{relationship.toMany ? 'To Many' : 'To One'}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">{relationship.optional ? 'Yes' : 'No'}</td>
                </tr>
              {/each}
            </tbody>
          </table>
        </div>
      </div>
    {/if}
    
    <!-- Object Instances -->
    {#if currentModel.instances.length > 0}
      <div>
        <h4 class="text-lg font-medium text-gray-800 dark:text-gray-200 mb-2">
          Object Instances 
          <span class="text-sm font-normal text-gray-500 dark:text-gray-400">
            (showing first {currentModel.instances.length} of {currentModel.entityCount})
          </span>
        </h4>
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-600">
            <thead class="bg-gray-50 dark:bg-gray-700">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Object ID</th>
                {#each currentModel.attributes as attribute}
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">{attribute.name}</th>
                {/each}
              </tr>
            </thead>
            <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-600">
              {#each currentModel.instances as instance}
                <tr class="hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors duration-150">
                  <td class="px-6 py-4 whitespace-nowrap text-xs text-gray-400 dark:text-gray-500 font-mono max-w-xs truncate">{instance.objectID.split('/').pop()}</td>
                  {#each currentModel.attributes as attribute}
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-white max-w-xs truncate">{instance.attributeValues[attribute.name] || 'nil'}</td>
                  {/each}
                </tr>
              {/each}
            </tbody>
          </table>
        </div>
      </div>
    {:else}
      <div class="mt-6">
        <h4 class="text-lg font-medium text-gray-800 dark:text-gray-200 mb-2">Object Instances</h4>
        <div class="text-center py-8 bg-gray-50 dark:bg-gray-700 rounded-lg">
          <div class="text-gray-400 dark:text-gray-500 text-lg mb-2">No instances found</div>
          <p class="text-gray-500 dark:text-gray-400">This entity has no data objects.</p>
        </div>
      </div>
    {/if}
  </div>
{/if}