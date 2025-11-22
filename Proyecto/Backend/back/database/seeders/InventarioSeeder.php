<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Producto;
use App\Models\Sucursal;
use App\Models\Inventario;

class InventarioSeeder extends Seeder
{
    public function run(): void
    {
        $sucursales = Sucursal::all();
        $productos = Producto::all();

        if ($sucursales->isEmpty() || $productos->isEmpty()) {
            // Si no hay datos, no intentar crear inventarios
            return;
        }

        foreach ($sucursales as $sucursal) {
            foreach ($productos as $producto) {
                Inventario::create([
                    'producto_id' => $producto->id,
                    'sucursal_id' => $sucursal->id,
                    'cantidad' => rand(0, 50),
                ]);
            }
        }
    }
}
