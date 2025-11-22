<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Inventario;
use App\Models\Sucursal;
use App\Models\Log;

class InventarioController extends Controller
{
    // GET /api/sucursales/{id}/inventario
    public function inventarioPorSucursal($id)
    {
        $sucursal = Sucursal::with(['inventarios.producto'])->findOrFail($id);
        return response()->json($sucursal->inventarios);
    }

    // POST /api/inventario/{id}/ajustar
    public function ajustarStock(Request $r, $id)
    {
        $r->validate(['producto_id'=>'required|integer','cantidad'=>'required|integer']);
        $inv = Inventario::where('sucursal_id',$id)->where('producto_id',$r->producto_id)->first();
        if(!$inv) {
            $inv = Inventario::create(['sucursal_id'=>$id,'producto_id'=>$r->producto_id,'cantidad'=>$r->cantidad]);
        } else {
            $inv->cantidad = $r->cantidad;
            $inv->save();
        }
        Log::create(['user_id'=>auth()->id(),'accion'=>'ajustar_stock','detalles'=>"sucursal:$id producto:{$r->producto_id} qty:{$r->cantidad}"]);
        return response()->json($inv);
    }

    // Optional: endpoint para ajustar sumando/restando
    public function cambiarStock(Request $r, $id)
    {
        $r->validate(['producto_id'=>'required|integer','delta'=>'required|integer']);
        $inv = Inventario::firstOrCreate(['sucursal_id'=>$id,'producto_id'=>$r->producto_id],['cantidad'=>0]);
        $inv->cantidad += (int)$r->delta;
        if ($inv->cantidad < 0) $inv->cantidad = 0;
        $inv->save();
        Log::create(['user_id'=>auth()->id(),'accion'=>'cambiar_stock','detalles'=>"sucursal:$id producto:{$r->producto_id} delta:{$r->delta}"]);
        return response()->json($inv);
    }
}
