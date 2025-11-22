<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Cotizacion;
use App\Models\Log;

class CotizacionController extends Controller
{
    public function store(Request $r)
    {
        $r->validate([
            'sucursal_id' => 'required|integer|exists:sucursales,id',
            'cliente_email' => 'nullable|email',
            'items' => 'required|array|min:1',
            'items.*.producto_id' => 'required|integer|exists:productos,id',
            'items.*.cantidad' => 'required|integer|min:1',
        ]);

        $total = 0;
        foreach ($r->items as $it) {
            $p = \App\Models\Producto::findOrFail($it['producto_id']);
            $total += $p->precio * $it['cantidad'];
        }

        $cot = Cotizacion::create([
            'sucursal_id' => $r->sucursal_id,
            'cliente_email' => $r->cliente_email ?? null,
            'productos' => json_encode($r->items),
            'total' => $total,
            'user_id' => auth()->id(),
        ]);
        Log::create(['user_id' => auth()->id(),'accion'=>'cotizacion_creada','detalles'=>"id:$cot->id"]);
        return response()->json($cot,201);
    }
    public function show($id)
    {
        $cot = \App\Models\Cotizacion::findOrFail($id);
        // 'productos' lo tienes como JSON o array (cast)
        return response()->json($cot);
    }
    public function pdf($id)
    {
        $cot = \App\Models\Cotizacion::findOrFail($id);
        $productos = json_decode($cot->productos, true);
        
        try {
            $data = ['cot' => $cot, 'productos' => $productos];
            $pdf = \PDF::loadView('pdf.cotizacion', $data);
            // Opcional: set paper/size -> $pdf->setPaper('A4', 'portrait');
            return $pdf->download("cotizacion-{$id}.pdf");
        } catch (\Exception $e) {
            \Log::error('PDF cotizacion error: '.$e->getMessage());
            return response()->json(['error'=>'No se pudo generar el PDF'], 500);
        }
}




}
