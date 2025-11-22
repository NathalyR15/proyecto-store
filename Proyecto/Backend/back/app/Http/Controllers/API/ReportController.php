<?php
namespace App\Http\Controllers\API;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Symfony\Component\HttpFoundation\StreamedResponse;

class ReportController extends Controller
{
    // Top productos (opcional filtro por sucursal)
    public function topProductos(Request $r)
    {
        $limit = $r->get('limit', 100);

        $q = DB::table('venta_items as vi')
            ->join('productos as p','p.id','vi.producto_id')
            ->join('ventas as v','v.id','vi.venta_id')
            ->select('p.id','p.nombre', DB::raw('SUM(vi.cantidad) as vendidos'))
            ->groupBy('p.id','p.nombre')
            ->orderByDesc('vendidos')
            ->limit($limit);

        if ($r->filled('sucursal_id')) {
            $q->where('v.sucursal_id', $r->sucursal_id);
            // además incluir nombre de sucursal en el select
            $q->leftJoin('sucursales as s', 'v.sucursal_id', 's.id');
            $q->addSelect('s.nombre as sucursal');
        }

        $rows = $q->get();

        // Si piden CSV
        if ($r->get('format') === 'csv') {
            $filename = 'top_productos' . ($r->filled('sucursal_id') ? "_s{$r->sucursal_id}" : '') . '.csv';
            $columns = $r->filled('sucursal_id') ? ['id','nombre','sucursal','vendidos'] : ['id','nombre','vendidos'];
            return $this->streamCsvResponse($rows, $columns, $filename);
        }

        return response()->json($rows);
    }

    // Stock bajo (listado producto-sucursal-cantidad)
    public function stockBajo(Request $r)
    {
        $lim = $r->get('limite', 20);
        $rows = DB::table('inventarios as i')
            ->join('productos as p','p.id','i.producto_id')
            ->join('sucursales as s','s.id','i.sucursal_id')
            ->select('p.id','p.nombre','s.nombre as sucursal','i.cantidad')
            ->where('i.cantidad','<',10)
            ->orderBy('i.cantidad','asc')
            ->limit($lim)
            ->get();

        if ($r->get('format') === 'csv') {
            return $this->streamCsvResponse($rows, ['id','nombre','sucursal','cantidad'], 'stock_bajo.csv');
        }

        return response()->json($rows);
    }

    // Ventas por mes (año) -> retorna mes,total
    public function ventasPorMes(Request $r)
    {
        $anio = $r->get('anio', date('Y'));
        $rows = DB::table('ventas')
            ->selectRaw('MONTH(fecha) as mes, SUM(total) as total')
            ->whereYear('fecha', $anio)
            ->groupBy(DB::raw('MONTH(fecha)'))
            ->orderBy('mes')
            ->get();

        return response()->json($rows);
    }

    // Productos más vendidos por mes (Producto, Mes, Cantidad) -> opcional filtro sucursal
    public function productosPorMes(Request $r)
    {
        $q = DB::table('venta_items as vi')
            ->join('ventas as v','v.id','vi.venta_id')
            ->join('productos as p','p.id','vi.producto_id')
            ->selectRaw('p.id, p.nombre, MONTH(v.fecha) as mes, SUM(vi.cantidad) as cantidad')
            ->groupBy('p.id', 'p.nombre', DB::raw('MONTH(v.fecha)'))
            ->orderByDesc('cantidad');

        if ($r->filled('sucursal_id')) {
            $q->where('v.sucursal_id', $r->sucursal_id);
        }

        $rows = $q->get();

        if ($r->get('format') === 'csv') {
            return $this->streamCsvResponse($rows, ['id','nombre','mes','cantidad'], 'productos_por_mes.csv');
        }

        return response()->json($rows);
    }

    // Clientes frecuentes (por sucursal o global)
    public function clientesFrecuentes(Request $r)
    {
        $q = DB::table('ventas as v')
            ->join('users as u','u.id','v.user_id')
            ->selectRaw('u.id, u.email, u.name, COUNT(v.id) as compras, SUM(v.total) as gastado')
            ->groupBy('u.id','u.email','u.name')
            ->orderByDesc('compras');

        if ($r->filled('sucursal_id')) {
            $q->where('v.sucursal_id', $r->sucursal_id);
        }

        $rows = $q->get();

        if ($r->get('format') === 'csv') {
            return $this->streamCsvResponse($rows, ['id','email','name','compras','gastado'], 'clientes_frecuentes.csv');
        }

        return response()->json($rows);
    }

    // Reporte compras por rango de fecha -> devuelve CSV si ?format=csv
    public function comprasPorRango(Request $r)
    {
        $desde = $r->get('desde');
        $hasta = $r->get('hasta');
        if (!$desde || !$hasta) return response()->json(['error'=>'Faltan fechas'],422);

        $rows = DB::table('ventas as v')
            ->leftJoin('users as u','u.id','v.user_id')
            ->select('v.id','v.fecha','v.total','v.sucursal_id','u.email')
            ->whereBetween('v.fecha', [$desde, $hasta])
            ->orderBy('v.fecha')
            ->get();

        if ($r->get('format') === 'csv') {
            return $this->streamCsvResponse($rows, ['id','fecha','total','sucursal_id','email'], "compras_{$desde}_a_{$hasta}.csv");
        }

        return response()->json($rows);
    }

    // Helper: crear StreamedResponse CSV
    protected function streamCsvResponse($rows, array $columns, $filename = 'reporte.csv')
    {
        $response = new StreamedResponse(function() use ($rows, $columns) {
            $out = fopen('php://output', 'w');
            // encabezado CSV
            fputcsv($out, $columns);
            foreach ($rows as $r) {
                $row = [];
                foreach ($columns as $c) {
                    // si la propiedad no existe, usa empty
                    $row[] = isset($r->$c) ? $r->$c : '';
                }
                fputcsv($out, $row);
            }
            fclose($out);
        }, 200, [
            'Content-Type' => 'text/csv; charset=utf-8',
            'Content-Disposition' => "attachment; filename=\"$filename\"",
        ]);

        return $response;
    }
}
