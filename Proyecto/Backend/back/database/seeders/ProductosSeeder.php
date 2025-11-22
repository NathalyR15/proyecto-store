<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Producto;

class ProductosSeeder extends Seeder
{
    public function run(): void
    {
        $productos = [
            ['sku' => 'P1001', 'nombre' => 'Cafetera Expres', 'descripcion' => 'Cafetera pequeña 1.5L', 'precio' => 45.50],
            ['sku' => 'P1002', 'nombre' => 'Taza Cerámica', 'descripcion' => 'Taza 300ml', 'precio' => 3.20],
            ['sku' => 'P1003', 'nombre' => 'Bolso Deportivo', 'descripcion' => 'Bolso para gimnasio', 'precio' => 25.00],
            ['sku' => 'P1004', 'nombre' => 'Auriculares', 'descripcion' => 'Inalámbricos bluetooth', 'precio' => 55.99],
            ['sku' => 'P1005', 'nombre' => 'Linterna LED', 'descripcion' => 'Compacta, 200 lm', 'precio' => 8.75],
            // agrega más filas según necesites (hasta 20-30 para pruebas)
        ];

        foreach ($productos as $p) {
            Producto::create($p);
        }
    }
}
