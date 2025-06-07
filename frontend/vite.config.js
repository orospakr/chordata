import { defineConfig } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';

export default defineConfig({
  plugins: [svelte()],
  build: {
    outDir: '../Sources/chordata',
    emptyOutDir: false,
    rollupOptions: {
      output: {
        // Generate simple filenames for easier Swift integration
        entryFileNames: 'app.js',
        chunkFileNames: 'chunk.[hash].js',
        assetFileNames: (assetInfo) => {
          if (assetInfo.name === 'index.css') {
            return 'app.css';
          }
          return 'assets/[name].[hash][extname]';
        }
      }
    },
    // Optimize for size
    minify: 'terser',
    sourcemap: false
  },
  base: './'
});