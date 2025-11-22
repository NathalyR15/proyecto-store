<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('traslados', function (Blueprint $table) {
            $table->id();
            $table->foreignId('producto_id')->constrained('productos')->onDelete('cascade');
            $table->foreignId('origen_id')->constrained('sucursales')->onDelete('cascade');
            $table->foreignId('destino_id')->constrained('sucursales')->onDelete('cascade');
            $table->integer('cantidad');
            $table->enum('estado',['pendiente','completado'])->default('pendiente');
            $table->timestamp('fecha')->useCurrent();
            $table->timestamps();

            
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('traslados');
    }
};
