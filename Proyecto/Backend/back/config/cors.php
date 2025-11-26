<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Cross-Origin Resource Sharing (CORS) Configuration
    |--------------------------------------------------------------------------
    */

    'paths' => ['api/*', 'sanctum/csrf-cookie'],

    'allowed_methods' => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],

    // Para desarrollo: puedes permitir localhost:5174 y 127.0.0.1:5174
    'allowed_origins' => [
        'https://storeproyect.shop',
        'https://api.storeproyect.shop',
        
    ],
    

    // Si en producción usarás otro dominio, añádelo aquí (ej: https://mi-dominio.com)
    'allowed_origins_patterns' => [],

    // Si prefieres permitir todo en desarrollo:
    // 'allowed_origins' => ['*'],

    'allowed_headers' => ['*'],

    // Si tu frontend envía cookies/autenticación, cambia a true y configura correctamente
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => true,
];
