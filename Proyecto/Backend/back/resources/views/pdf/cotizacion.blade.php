{{-- resources/views/pdf/cotizacion.blade.php --}}
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Cotización #{{ $cot->id }}</title>
  <style>
    body { font-family: DejaVu Sans, Arial, Helvetica, sans-serif; font-size: 12px; color:#222; }
    h1 { text-align:center; margin-bottom: 8px; }
    .meta { margin-bottom: 12px; }
    table { width:100%; border-collapse: collapse; margin-top: 8px; }
    th, td { border: 1px solid #ccc; padding: 6px; text-align: left; }
    th { background: #f2f2f2; }
    .right { text-align:right; }
    .small { font-size: 11px; color:#666; }
  </style>
</head>
<body>
  <h1>Cotización #{{ $cot->id }}</h1>

  <div class="meta">
    <div><strong>Sucursal:</strong> {{ optional($cot->sucursal)->nombre ?? ('ID ' . $cot->sucursal_id) }}</div>
    <div><strong>Usuario:</strong> {{ optional($cot->user)->name ?? 'Anónimo' }}</div>
    <div class="small"><strong>Fecha:</strong> {{ $cot->created_at }}</div>
    @if($cot->cliente_email)
      <div><strong>Cliente (email):</strong> {{ $cot->cliente_email }}</div>
    @endif
  </div>

  <table>
    <thead>
      <tr>
        <th>Producto</th>
        <th>Cant.</th>
        <th>Precio</th>
        <th>Subtotal</th>
      </tr>
    </thead>
    <tbody>
      @php $items = is_array($productos) ? $productos : json_decode($cot->productos, true); @endphp
      @foreach($items as $it)
        @php
          // intentar cargar nombre y precio desde productos DB (fallback si no hay)
          $p = \App\Models\Producto::find($it['producto_id']);
          $nombre = $p ? $p->nombre : ($it['nombre'] ?? 'Producto ' . $it['producto_id']);
          $precio = $p ? $p->precio : ($it['precio'] ?? '0.00');
          $cantidad = $it['cantidad'] ?? 1;
        @endphp
        <tr>
          <td>{{ $nombre }}</td>
          <td>{{ $cantidad }}</td>
          <td class="right">{{ number_format($precio,2) }}</td>
          <td class="right">{{ number_format($precio * $cantidad,2) }}</td>
        </tr>
      @endforeach
    </tbody>
    <tfoot>
      <tr>
        <td colspan="3" class="right"><strong>Total</strong></td>
        <td class="right"><strong>{{ number_format($cot->total,2) }}</strong></td>
      </tr>
    </tfoot>
  </table>

  <p class="small">Generado por Store Online S.A.</p>
</body>
</html>
