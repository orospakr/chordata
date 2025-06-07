<script>
  let { error } = $props();
</script>

<div class="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-4 mb-8">
  <div class="text-red-800 dark:text-red-200">
    <strong>Error:</strong> {error}
  </div>
</div>