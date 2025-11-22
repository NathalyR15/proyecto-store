<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Traslado extends Model
{
    use HasFactory;

    protected $table = 'traslados';

    protected $fillable = [
        'producto_id',
        'origen_id',
        'destino_id',
        'cantidad',
        'estado',
        'fecha',
        'user_id'
    ];

    public function producto() {
        return $this->belongsTo(Producto::class,'producto_id');
    }
    public function origen() {
        return $this->belongsTo(Sucursal::class,'origen_id');
    }
    public function destino() {
        return $this->belongsTo(Sucursal::class,'destino_id');
    }

    // opcional: relación con usuario que creó el traslado
    public function user() {
        return $this->belongsTo(\App\Models\User::class,'user_id');
    }
}
