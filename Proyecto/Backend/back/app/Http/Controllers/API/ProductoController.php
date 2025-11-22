<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Producto;
use App\Models\Log;
use Illuminate\Support\Facades\Storage;

class ProductoController extends Controller
{
    public function index()
    {
        return Producto::with('inventarios.sucursal')->paginate(20);
    }

    public function show($id)
    {
        return Producto::with('inventarios.sucursal')->findOrFail($id);
    }

    public function store(Request $r)
    {
        $data = $r->validate([
            'sku' => 'required|string|unique:productos,sku',
            'nombre' => 'required|string',
            'descripcion' => 'nullable|string',
            'precio' => 'required|numeric',
            'imagen' => 'nullable|image|max:2048'
        ]);

        if ($r->hasFile('imagen')) {
            $path = $r->file('imagen')->store('productos', 'public'); // storage/app/public/productos/...
            $data['imagen'] = $path;
        }

        $p = Producto::create($data);
        Log::create(['user_id' => auth()->id(), 'accion' => 'producto_creado', 'detalles' => "id:$p->id"]);
        return response()->json($p, 201);
    }

    public function update(Request $r, $id)
    {
        $producto = Producto::findOrFail($id);

        $data = $r->validate([
            'sku' => "nullable|string|unique:productos,sku,{$id}",
            'nombre' => 'required|string',
            'descripcion' => 'nullable|string',
            'precio' => 'required|numeric',
            'imagen' => 'nullable|image|max:2048'
        ]);

        // Si suben nueva imagen, guardarla y borrar la anterior
        if ($r->hasFile('imagen')) {
            // borrar anterior si existe
            if ($producto->imagen) {
                Storage::disk('public')->delete($producto->imagen);
            }
            $path = $r->file('imagen')->store('productos', 'public');
            $data['imagen'] = $path;
        }

        // Si sku viene nulo en payload, no lo sobrescribimos con null:
        if (array_key_exists('sku', $data) && $data['sku'] === null) {
            unset($data['sku']);
        }

        $producto->update($data);
        Log::create(['user_id' => auth()->id(), 'accion' => 'producto_actualizado', 'detalles' => "id:$producto->id"]);
        return response()->json($producto);
    }

    public function destroy($id)
    {
        $producto = Producto::findOrFail($id);
        // borrar imagen asociada si existe
        if ($producto->imagen) {
            Storage::disk('public')->delete($producto->imagen);
        }
        $producto->delete();
        Log::create(['user_id' => auth()->id(), 'accion' => 'producto_eliminado', 'detalles' => "id:$id"]);
        return response()->json(['ok' => true]);
    }
}
