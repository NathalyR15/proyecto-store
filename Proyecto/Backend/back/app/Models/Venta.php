<?php

namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Venta extends Model
{
    use HasFactory;

    protected $table = 'ventas';

    protected $fillable = [
        'user_id',
        'sucursal_id',
        'total',
        'fecha'
    ];

    public function items()
    {
        return $this->hasMany(VentaItem::class, 'venta_id');
    }
}
