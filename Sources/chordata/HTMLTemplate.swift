import Foundation

/// HTML template for the Chordata Core Data Inspector dashboard
struct HTMLTemplate {
    static let dashboard = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chordata - Core Data Inspector</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
        <script>
            tailwind.config = {
                darkMode: 'class'
            }
        </script>
    </head>
    <body class="bg-gray-50 dark:bg-gray-900 min-h-screen transition-colors duration-200">
        <div class="container mx-auto px-4 py-8" x-data="chordataApp()">
            <!-- Header -->
            <div class="mb-8 flex justify-between items-start">
                <div>
                    <h1 class="text-4xl font-bold text-gray-900 dark:text-white mb-2">Chordata</h1>
                    <p class="text-gray-600 dark:text-gray-400">Core Data Inspector</p>
                </div>
                
                <!-- Dark Mode Toggle -->
                <button 
                    @click="toggleDarkMode()"
                    class="p-2 rounded-lg bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 transition-colors duration-200"
                    :title="darkMode ? 'Switch to light mode' : 'Switch to dark mode'"
                >
                    <!-- Sun icon for light mode -->
                    <svg x-show="darkMode" class="w-5 h-5 text-yellow-500" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 6.464A1 1 0 106.465 5.05l-.708-.707a1 1 0 00-1.414 1.414l.707.707zm1.414 8.486l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 1.414zM4 11a1 1 0 100-2H3a1 1 0 000 2h1z" clip-rule="evenodd"></path>
                    </svg>
                    <!-- Moon icon for dark mode -->
                    <svg x-show="!darkMode" class="w-5 h-5 text-gray-700" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z"></path>
                    </svg>
                </button>
            </div>
            
            <!-- Loading State -->
            <div x-show="loading" class="text-center py-8">
                <div class="text-gray-500 dark:text-gray-400">Loading models...</div>
            </div>
            
            <!-- Error State -->
            <div x-show="error" class="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-4 mb-8">
                <div class="text-red-800 dark:text-red-200">
                    <strong>Error:</strong> <span x-text="error"></span>
                </div>
            </div>
            
            <!-- Models Overview -->
            <div x-show="!loading && !error" class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6 mb-8 transition-colors duration-200">
                <h2 class="text-2xl font-semibold text-gray-800 dark:text-white mb-4">Data Models</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                    <template x-for="model in models" :key="model.name">
                        <div class="border border-gray-200 dark:border-gray-600 rounded-lg p-4 hover:shadow-md dark:hover:shadow-lg transition-shadow bg-white dark:bg-gray-700">
                            <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2" x-text="model.name"></h3>
                            <div class="text-sm text-gray-600 dark:text-gray-300 space-y-1">
                                <p><span class="font-medium">Attributes:</span> <span x-text="model.attributeCount"></span></p>
                                <p><span class="font-medium">Relationships:</span> <span x-text="model.relationshipCount"></span></p>
                                <p><span class="font-medium">Entity Count:</span> <span x-text="model.entityCount"></span></p>
                            </div>
                            <div class="mt-3">
                                <button 
                                    @click="selectedModel = selectedModel === model.name ? null : model.name"
                                    class="text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 text-sm font-medium transition-colors duration-200"
                                    x-text="selectedModel === model.name ? 'Hide Details' : 'View Details →'"
                                ></button>
                            </div>
                        </div>
                    </template>
                </div>
                
                <!-- Empty state -->
                <div x-show="models.length === 0" class="text-center py-8">
                    <div class="text-gray-400 dark:text-gray-500 text-lg mb-2">No models found</div>
                    <p class="text-gray-500 dark:text-gray-400">Make sure your Core Data model is properly configured.</p>
                </div>
            </div>
            
            <!-- Model Details Section -->
            <div x-show="!loading && !error && selectedModel" class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6 transition-colors duration-200">
                <h2 class="text-2xl font-semibold text-gray-800 dark:text-white mb-4">Model Details</h2>
                <template x-for="model in models.filter(m => m.name === selectedModel)" :key="model.name">
                    <div>
                        <h3 class="text-xl font-medium text-gray-900 dark:text-white mb-4" x-text="model.name"></h3>
                        
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
                                        <template x-for="attribute in model.attributes" :key="attribute.name">
                                            <tr class="hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors duration-150">
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white" x-text="attribute.name"></td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300" x-text="attribute.type"></td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300" x-text="attribute.optional ? 'Yes' : 'No'"></td>
                                            </tr>
                                        </template>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- Relationships -->
                        <div x-show="model.relationships.length > 0" class="mb-6">
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
                                        <template x-for="relationship in model.relationships" :key="relationship.name">
                                            <tr class="hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors duration-150">
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white" x-text="relationship.name"></td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300" x-text="relationship.destinationEntity"></td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300" x-text="relationship.toMany ? 'To Many' : 'To One'"></td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300" x-text="relationship.optional ? 'Yes' : 'No'"></td>
                                            </tr>
                                        </template>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- Object Instances -->
                        <div x-show="model.instances.length > 0">
                            <h4 class="text-lg font-medium text-gray-800 dark:text-gray-200 mb-2">
                                Object Instances 
                                <span class="text-sm font-normal text-gray-500 dark:text-gray-400">
                                    (showing first <span x-text="model.instances.length"></span> of <span x-text="model.entityCount"></span>)
                                </span>
                            </h4>
                            <div class="overflow-x-auto">
                                <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-600">
                                    <thead class="bg-gray-50 dark:bg-gray-700">
                                        <tr>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Object ID</th>
                                            <template x-for="attribute in model.attributes" :key="attribute.name">
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider" x-text="attribute.name"></th>
                                            </template>
                                        </tr>
                                    </thead>
                                    <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-600">
                                        <template x-for="instance in model.instances" :key="instance.objectID">
                                            <tr class="hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors duration-150">
                                                <td class="px-6 py-4 whitespace-nowrap text-xs text-gray-400 dark:text-gray-500 font-mono max-w-xs truncate" x-text="instance.objectID.split('/').pop()"></td>
                                                <template x-for="attribute in model.attributes" :key="attribute.name">
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-white max-w-xs truncate" x-text="instance.attributeValues[attribute.name] || 'nil'"></td>
                                                </template>
                                            </tr>
                                        </template>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- Empty instances state -->
                        <div x-show="model.instances.length === 0" class="mt-6">
                            <h4 class="text-lg font-medium text-gray-800 dark:text-gray-200 mb-2">Object Instances</h4>
                            <div class="text-center py-8 bg-gray-50 dark:bg-gray-700 rounded-lg">
                                <div class="text-gray-400 dark:text-gray-500 text-lg mb-2">No instances found</div>
                                <p class="text-gray-500 dark:text-gray-400">This entity has no data objects.</p>
                            </div>
                        </div>
                    </div>
                </template>
            </div>
        </div>
        
        <script>
        function chordataApp() {
            return {
                models: [],
                loading: true,
                error: null,
                selectedModel: null,
                darkMode: false,
                
                async init() {
                    // Initialize dark mode from localStorage or system preference
                    this.darkMode = localStorage.getItem('darkMode') === 'true' || 
                        (!localStorage.getItem('darkMode') && window.matchMedia('(prefers-color-scheme: dark)').matches);
                    this.applyDarkMode();
                    
                    await this.loadModels();
                },
                
                toggleDarkMode() {
                    this.darkMode = !this.darkMode;
                    localStorage.setItem('darkMode', this.darkMode.toString());
                    this.applyDarkMode();
                },
                
                applyDarkMode() {
                    if (this.darkMode) {
                        document.documentElement.classList.add('dark');
                    } else {
                        document.documentElement.classList.remove('dark');
                    }
                },
                
                async loadModels() {
                    try {
                        this.loading = true;
                        this.error = null;
                        
                        const response = await fetch('/api/models');
                        if (!response.ok) {
                            throw new Error(`HTTP error! status: ${response.status}`);
                        }
                        
                        this.models = await response.json();
                    } catch (err) {
                        this.error = err.message || 'Failed to load models';
                        console.error('Error loading models:', err);
                    } finally {
                        this.loading = false;
                    }
                }
            }
        }
        </script>
    </body>
    </html>
    """
} 