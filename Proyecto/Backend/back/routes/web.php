<?php
use App\Http\Controllers\API\SucursalController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});
//Route::prefix('api')->withoutMiddleware(['web'])->group(function(){
    //Route::resource('sucursales', SucursalController::class);
//});