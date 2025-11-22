<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Sucursal;
use App\Models\Log;

class SucursalController extends Controller
{
    public function index()
    {
        return Sucursal::withCount('inventarios')->get();
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'nombre'=>'required|string',
            'direccion'=>'nullable|string',
            'ciudad'=>'nullable|string'
        ]);
        $s = Sucursal::create($data);
        Log::create(['user_id'=>auth()->id(),'accion'=>'sucursal_creada','detalles'=>"id:$s->id"]);
        return response()->json($s,201);
    }

    public function show($id)
    {
        return Sucursal::with(['inventarios.producto'])->findOrFail($id);
    }

    public function update(Request $request, $id)
    {
        $s = Sucursal::findOrFail($id);
        $data = $request->validate([
            'nombre'=>'required|string',
            'direccion'=>'nullable|string',
            'ciudad'=>'nullable|string'
        ]);
        $s->update($data);
        Log::create(['user_id'=>auth()->id(),'accion'=>'sucursal_actualizada','detalles'=>"id:$s->id"]);
        return response()->json($s);
    }

    public function destroy($id)
    {
        $s = Sucursal::findOrFail($id);
        $s->delete();
        Log::create(['user_id'=>auth()->id(),'accion'=>'sucursal_eliminada','detalles'=>"id:$id"]);
        return response()->json(['ok'=>true]);
    }
}
