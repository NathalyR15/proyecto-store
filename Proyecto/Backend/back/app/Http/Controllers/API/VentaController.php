<?php
// app/Http/Controllers/API/VentaController.php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Venta;
use App\Models\VentaItem;
use App\Models\Inventario;
use App\Models\Producto;
use App\Models\Log;
use Illuminate\Support\Facades\DB;

class VentaController extends Controller
{
    public function index()
    {
        return Venta::with('items.producto')->latest()->paginate(20);
    }

    public function show($id)
    {
        return Venta::with('items.producto')->findOrFail($id);
    }

    public function store(Request $r)
    {
        $r->validate([
            'sucursal_id'=>'required|integer|exists:sucursales,id',
            'items'=>'required|array|min:1',
            'items.*.producto_id'=>'required|integer|exists:productos,id',
            'items.*.cantidad'=>'required|integer|min:1',
            // no aceptamos precio del cliente
        ]);

        return DB::transaction(function() use ($r) {
            try {
                // calculamos total con precios del servidor
                $total = 0;
                foreach ($r->items as $it) {
                    $producto = Producto::findOrFail($it['producto_id']);
                    $total += $producto->precio * $it['cantidad'];
                }

                $venta = Venta::create([
                    'user_id' => auth()->id(),
                    'sucursal_id' => $r->sucursal_id,
                    'total' => $total,
                    'fecha' => now(), // si tienes columna fecha
                ]);

                foreach ($r->items as $it) {
                    // bloquear fila de inventario para evitar race condition
                    $inv = Inventario::where('producto_id', $it['producto_id'])
                                     ->where('sucursal_id', $r->sucursal_id)
                                     ->lockForUpdate()
                                     ->first();

                    if (!$inv || $inv->cantidad < $it['cantidad']) {
                        throw new \Exception("Stock insuficiente para producto {$it['producto_id']}");
                    }

                    $producto = Producto::findOrFail($it['producto_id']);
                    $precioUnit = $producto->precio;

                    VentaItem::create([
                        'venta_id' => $venta->id,
                        'producto_id' => $it['producto_id'],
                        'cantidad' => $it['cantidad'],
                        // usa el nombre de columna que tienes en DB: precio_unit
                        'precio_unit' => $precioUnit,
                    ]);

                    $inv->cantidad -= $it['cantidad'];
                    $inv->save();
                }

                Log::create(['user_id' => auth()->id(), 'accion' => 'venta_creada', 'detalles' => "venta:{$venta->id}"]);

                return response()->json($venta->load('items.producto'), 201);
            } catch (\Exception $e) {
                // rollback automático al salir de transaction con excepción
                return response()->json(['error' => $e->getMessage()], 400);
            }
        });
    }
}
