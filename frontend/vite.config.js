import { defineConfig } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';

export default defineConfig(({ command, mode }) => {
  const isDev = mode === 'development' || process.env.NODE_ENV === 'development';
  
  return {
    plugins: [svelte({
      compilerOptions: {
        dev: true // Force development mode always
      },
      hot: false, // Disable HMR to avoid issues
      preprocess: [], // TypeScript preprocessing is handled by Vite
      onwarn: (warning, handler) => {
        // Handle TypeScript warnings
        if (warning.code === 'css-unused-selector') return;
        handler(warning);
      }
    })],
    define: {
      __DEV__: true, // Define development flag
      'process.env.NODE_ENV': '"development"' // Force development environment
    },
    mode: 'development', // Force development mode
    build: {
      outDir: '../Sources/chordata/assets',
      emptyOutDir: true,
      rollupOptions: {
        output: {
          // Generate simple filenames for easier Swift integration
          entryFileNames: 'app.js',
          chunkFileNames: 'chunk.[hash].js',
          assetFileNames: (assetInfo) => {
            if (assetInfo.name === 'style.css' || assetInfo.name === 'index.css') {
              return 'app.css';
            }
            return 'assets/[name].[hash][extname]';
          }
        }
      },
      // Development build for debugging
      minify: false,
      sourcemap: true,
      cssCodeSplit: false // Ensure CSS is bundled in one file with sourcemap
    },
    base: './'
  };
});