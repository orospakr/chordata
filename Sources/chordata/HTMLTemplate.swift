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
    </head>
    <body class="bg-gray-50 min-h-screen">
        <div class="container mx-auto px-4 py-8" x-data="chordataApp()">
            <!-- Header -->
            <div class="mb-8">
                <h1 class="text-4xl font-bold text-gray-900 mb-2">Chordata</h1>
                <p class="text-gray-600">Core Data Inspector</p>
            </div>
            
            <!-- Loading State -->
            <div x-show="loading" class="text-center py-8">
                <div class="text-gray-500">Loading models...</div>
            </div>
            
            <!-- Error State -->
            <div x-show="error" class="bg-red-50 border border-red-200 rounded-lg p-4 mb-8">
                <div class="text-red-800">
                    <strong>Error:</strong> <span x-text="error"></span>
                </div>
            </div>
            
            <!-- Models Overview -->
            <div x-show="!loading && !error" class="bg-white rounded-lg shadow-md p-6 mb-8">
                <h2 class="text-2xl font-semibold text-gray-800 mb-4">Data Models</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                    <template x-for="model in models" :key="model.name">
                        <div class="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow">
                            <h3 class="text-lg font-medium text-gray-900 mb-2" x-text="model.name"></h3>
                            <div class="text-sm text-gray-600 space-y-1">
                                <p><span class="font-medium">Attributes:</span> <span x-text="model.attributeCount"></span></p>
                                <p><span class="font-medium">Relationships:</span> <span x-text="model.relationshipCount"></span></p>
                                <p><span class="font-medium">Entity Count:</span> <span x-text="model.entityCount"></span></p>
                            </div>
                            <div class="mt-3">
                                <button 
                                    @click="selectedModel = selectedModel === model.name ? null : model.name"
                                    class="text-blue-600 hover:text-blue-800 text-sm font-medium"
                                    x-text="selectedModel === model.name ? 'Hide Details' : 'View Details →'"
                                ></button>
                            </div>
                        </div>
                    </template>
                </div>
                
                <!-- Empty state -->
                <div x-show="models.length === 0" class="text-center py-8">
                    <div class="text-gray-400 text-lg mb-2">No models found</div>
                    <p class="text-gray-500">Make sure your Core Data model is properly configured.</p>
                </div>
            </div>
            
            <!-- Model Details Section -->
            <div x-show="!loading && !error && selectedModel" class="bg-white rounded-lg shadow-md p-6">
                <h2 class="text-2xl font-semibold text-gray-800 mb-4">Model Details</h2>
                <template x-for="model in models.filter(m => m.name === selectedModel)" :key="model.name">
                    <div>
                        <h3 class="text-xl font-medium text-gray-900 mb-4" x-text="model.name"></h3>
                        
                        <!-- Attributes -->
                        <div class="mb-6">
                            <h4 class="text-lg font-medium text-gray-800 mb-2">Attributes</h4>
                            <div class="overflow-x-auto">
                                <table class="min-w-full divide-y divide-gray-200">
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Type</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Optional</th>
                                        </tr>
                                    </thead>
                                    <tbody class="bg-white divide-y divide-gray-200">
                                        <template x-for="attribute in model.attributes" :key="attribute.name">
                                            <tr>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900" x-text="attribute.name"></td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500" x-text="attribute.type"></td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500" x-text="attribute.optional ? 'Yes' : 'No'"></td>
                                            </tr>
                                        </template>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- Relationships -->
                        <div x-show="model.relationships.length > 0">
                            <h4 class="text-lg font-medium text-gray-800 mb-2">Relationships</h4>
                            <div class="overflow-x-auto">
                                <table class="min-w-full divide-y divide-gray-200">
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Destination</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Type</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Optional</th>
                                        </tr>
                                    </thead>
                                    <tbody class="bg-white divide-y divide-gray-200">
                                        <template x-for="relationship in model.relationships" :key="relationship.name">
                                            <tr>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900" x-text="relationship.name"></td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500" x-text="relationship.destinationEntity"></td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500" x-text="relationship.toMany ? 'To Many' : 'To One'"></td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500" x-text="relationship.optional ? 'Yes' : 'No'"></td>
                                            </tr>
                                        </template>
                                    </tbody>
                                </table>
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
                
                async init() {
                    await this.loadModels();
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