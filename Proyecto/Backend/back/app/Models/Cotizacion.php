<?php

namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cotizacion extends Model
{
    use HasFactory;

    protected $table = 'cotizacions'; // según tu migración: create_cotizacions_table

    protected $fillable = [
        'sucursal_id',
        'cliente_email',
        'productos', // json
        'total',
        'creado_en',
        'user_id'
    ];

    protected $casts = [
        'productos' => 'array',
        'total' => 'float',
    ];
}
