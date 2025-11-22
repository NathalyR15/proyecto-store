<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Sucursal;

class SucursalesSeeder extends Seeder
{
    public function run(): void
    {
        Sucursal::create(['nombre' => 'Pradera Chimaltenango', 'direccion' => 'Centro Comercial', 'ciudad' => 'Chimaltenango']);
        Sucursal::create(['nombre' => 'Pradera Escuintla', 'direccion' => 'Centro', 'ciudad' => 'Escuintla']);
        Sucursal::create(['nombre' => 'Sucursal Central', 'direccion' => 'Av. Principal 123', 'ciudad' => 'Guatemala']);
        // Agrega más si quieres
    }
}