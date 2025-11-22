<?php

use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\ProductoController;
use App\Http\Controllers\API\SucursalController;
use App\Http\Controllers\API\InventarioController;
use App\Http\Controllers\API\VentaController;
use App\Http\Controllers\API\CotizacionController;
use App\Http\Controllers\API\TrasladoController;
use App\Http\Controllers\API\ReportController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Rutas públicas primero (productos, sucursales, inventario por sucursal...).
| Rutas que requieren autenticación quedan en el group 'auth:sanctum'.
|
*/
// Gestión de usuarios (admin + gerente)
Route::get('admin/users', [\App\Http\Controllers\API\UserController::class, 'index']);
Route::put('admin/users/{id}', [\App\Http\Controllers\API\UserController::class, 'update']);
Route::delete('admin/users/{id}', [\App\Http\Controllers\API\UserController::class, 'destroy']);


// Rutas públicas
Route::post('login', [AuthController::class, 'login']);
Route::post('register', [AuthController::class, 'register']);

// Productos públicos (listar / ver)
Route::get('productos', [ProductoController::class, 'index']);
Route::get('productos/{id}', [ProductoController::class, 'show']);

// Sucursales públicas (lista) y su inventario (pública)
Route::get('sucursales', [SucursalController::class, 'index']);
Route::get('sucursales/{id}/inventario', [InventarioController::class, 'inventarioPorSucursal']);

// Cotizaciones públicas (crear/ver/pdf)
Route::post('cotizaciones', [CotizacionController::class, 'store']);
Route::get('cotizaciones/{id}', [CotizacionController::class, 'show']);
Route::get('cotizaciones/{id}/pdf', [CotizacionController::class, 'pdf']); // opcional

// Rutas autenticadas (token sanctum)
Route::middleware('auth:sanctum')->group(function () {
    Route::post('logout', [AuthController::class, 'logout']);

    // Productos (admin) - CRUD menos index/show (estos ya son públicos)
    // Protegemos con gate 'manage-products'
    Route::apiResource('productos', ProductoController::class)->except(['index','show'])
         ->middleware('can:manage-products');

    // Sucursales y stock (admin) - resource admin
    Route::apiResource('sucursales', SucursalController::class)->except(['index','show'])
         ->middleware('can:manage-products'); // si quieres que admin maneje sucursales igual que productos

    // Ajustar stock (solo para roles con permiso) -> gate manage-inventory
    Route::post('inventario/{id}/ajustar', [InventarioController::class, 'ajustarStock'])
         ->middleware('can:manage-inventory');
         
     Route::get('backup', [\App\Http\Controllers\BackupController::class, 'backup'])
     ->middleware('can:manage-products');


    // Ventas y cotizaciones (autenticadas)
    Route::post('ventas', [VentaController::class, 'store']);

    // Traslados (admin / inventario managers)
    Route::get('traslados', [TrasladoController::class, 'index'])->middleware('can:manage-inventory');
    Route::get('traslados/{id}', [TrasladoController::class, 'show'])->middleware('can:manage-inventory');
    Route::post('traslados', [TrasladoController::class, 'store'])->middleware('can:manage-inventory');
    Route::post('traslados/{id}/completar', [TrasladoController::class, 'completar'])->middleware('can:manage-inventory');

    // Reportes (admin/gerente) -> proteger por gate view-reports
    Route::get('reportes/top-productos', [ReportController::class,'topProductos']);
    Route::get('reportes/stock-bajo', [ReportController::class,'stockBajo']);
    Route::get('reportes/ventas-mes', [ReportController::class,'ventasPorMes']);
    Route::get('reportes/productos-por-mes', [ReportController::class,'productosPorMes']);
    Route::get('reportes/clientes-frecuentes', [ReportController::class,'clientesFrecuentes']);
    Route::get('reportes/compras-por-rango', [ReportController::class,'comprasPorRango']);

    // Logs (admin)
    Route::get('logs', function(){ return \App\Models\Log::latest()->limit(200)->get(); })->middleware('can:manage-products');
});
