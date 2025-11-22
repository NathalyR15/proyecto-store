<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Traslado;
use App\Models\Inventario;
use App\Models\Log;
use Illuminate\Support\Facades\DB;

class TrasladoController extends Controller
{
    // Listar traslados (paginado, filtros opcionales)
    public function index(Request $r)
    {
        $q = Traslado::with(['producto', 'origen', 'destino'])->latest();
        if ($r->filled('estado')) $q->where('estado', $r->estado);
        if ($r->filled('origen_id')) $q->where('origen_id', $r->origen_id);
        if ($r->filled('destino_id')) $q->where('destino_id', $r->destino_id);
        return $q->paginate(20);
    }

    // Mostrar uno
    public function show($id)
    {
        return Traslado::with(['producto', 'origen', 'destino'])->findOrFail($id);
    }

    // Crear traslado (queda en estado 'pendiente')
    public function store(Request $request)
    {
        $validated = $request->validate([
        'producto_id' => 'required|exists:productos,id',
        'origen_id' => 'required|exists:sucursales,id',
        'destino_id' => 'required|exists:sucursales,id|different:origen_id',
        'cantidad' => 'required|integer|min:1',
    ]);
        $traslado = \App\Models\Traslado::create([
        'producto_id' => $validated['producto_id'],
        'origen_id' => $validated['origen_id'],
        'destino_id' => $validated['destino_id'],
        'cantidad' => $validated['cantidad'],
        'estado' => 'pendiente',
        'user_id' => auth()->id(), // ✅ ahora sí existe
    ]);

    return response()->json($traslado, 201);
    }


    // Completar traslado: restar en origen, sumar en destino
    public function completar($id)
    {
        $t = Traslado::findOrFail($id);
        if ($t->estado === 'completado') {
            return response()->json(['error' => 'Traslado ya completado'], 400);
        }

        DB::beginTransaction();
        try {
            // obtener y bloquear inventario del origen
            $invOrigen = Inventario::where('sucursal_id', $t->origen_id)
                ->where('producto_id', $t->producto_id)
                ->lockForUpdate()
                ->first();

            if (!$invOrigen || $invOrigen->cantidad < $t->cantidad) {
                throw new \Exception("Stock insuficiente en origen");
            }

            // restar en origen
            $invOrigen->cantidad -= $t->cantidad;
            $invOrigen->save();

            // obtener y bloquear inventario del destino
            $invDest = Inventario::where('sucursal_id', $t->destino_id)
                ->where('producto_id', $t->producto_id)
                ->lockForUpdate()
                ->first();

            // crear en destino si no existe
            if (!$invDest) {
                $invDest = Inventario::create([
                    'sucursal_id' => $t->destino_id,
                    'producto_id' => $t->producto_id,
                    'cantidad'    => 0
                ]);
                // Nota: create no está bloqueado pero estamos en transacción y es correcto crear aquí.
            }

            // sumar en destino
            $invDest->cantidad += $t->cantidad;
            $invDest->save();

            // marcar traslado como completado
            $t->estado = 'completado';
            $t->save();

            Log::create(['user_id' => auth()->id(), 'accion' => 'traslado_completado', 'detalles' => "id:$t->id"]);
            DB::commit();

            return response()->json($t);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => $e->getMessage()], 400);
        }
    }
}
