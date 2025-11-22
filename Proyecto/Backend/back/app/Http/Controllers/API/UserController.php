<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Log;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    protected function checkManageUsers()
    {
        $u = auth()->user();
        if (!$u) abort(401, 'No autenticado');
        if (!in_array($u->role, ['admin','gerente'])) {
            abort(403, 'No autorizado');
        }
    }

    // Listar usuarios (paginated)
    public function index(Request $r)
    {
        $this->checkManageUsers();
        $q = User::query()->select('id','name','email','role','created_at','updated_at');
        if ($r->has('q') && $r->q) {
            $q->where(function($s) use($r){
                $s->where('name','like', "%{$r->q}%")->orWhere('email','like', "%{$r->q}%");
            });
        }
        $rows = $q->orderBy('id','desc')->paginate(50);
        return response()->json($rows);
    }

    // Actualizar (por ahora sólo rol y nombre/email opcional)
    public function update(Request $r, $id)
    {
        $this->checkManageUsers();

        $u = User::findOrFail($id);

        $data = $r->validate([
            'role' => 'required|in:cliente,gerente,admin',
            'name' => 'nullable|string|max:255',
            'email' => 'nullable|email|unique:users,email,'.$u->id,
            'password' => 'nullable|string|min:6|confirmed'
        ]);

        $old = $u->toArray();

        if (isset($data['name'])) $u->name = $data['name'];
        if (isset($data['email'])) $u->email = $data['email'];
        if (isset($data['role'])) $u->role = $data['role'];
        if (!empty($data['password'])) $u->password = Hash::make($data['password']);

        $u->save();

        // Log: quien -> que hizo -> detalles
        Log::create([
            'user_id' => auth()->id(),
            'accion' => 'usuario_actualizado',
            'detalles' => "id:{$u->id}; cambios: " . json_encode([
                'antes' => $old['role'] ?? null,
                'despues' => $u->role
            ])
        ]);

        return response()->json(['ok' => true, 'user' => $u]);
    }

    // Eliminar usuario
    public function destroy($id)
    {
        $this->checkManageUsers();

        $u = User::findOrFail($id);
        // evita eliminarte a ti mismo (opcional)
        if (auth()->id() === $u->id) {
            return response()->json(['error' => 'No puedes eliminarte a ti mismo'], 422);
        }

        $u->delete();

        Log::create([
            'user_id' => auth()->id(),
            'accion' => 'usuario_eliminado',
            'detalles' => "id:{$id}"
        ]);

        return response()->json(['ok' => true]);
    }
}
