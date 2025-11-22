<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Storage;

class BackupDatabase extends Command
{
    protected $signature = 'store:backup {--name=}';
    protected $description = 'Genera un backup SQL (mysqldump) y lo guarda en storage/app/backups';

    public function handle()
    {
        $this->info('Iniciando backup...');
        $database = config('database.connections.mysql.database');
        $user = config('database.connections.mysql.username');
        $pass = config('database.connections.mysql.password');
        $host = config('database.connections.mysql.host');
        $port = config('database.connections.mysql.port', 3306);

        $name = $this->option('name') ?? date('Ymd_His') . ".sql";
        $path = storage_path("app/backups/{$name}");

        // Asegurarse que carpeta exista
        if (!is_dir(dirname($path))) mkdir(dirname($path), 0755, true);

        // Construir comando mysqldump
        $cmd = "mysqldump -h {$host} -P {$port} -u {$user} ";
        if ($pass) {
            // cuidado con pasar la contraseña en la línea de comandos (posible log)
            $cmd .= "-p'{$pass}' ";
        }
        $cmd .= escapeshellarg($database) . " > " . escapeshellarg($path);

        $this->info("Ejecutando: {$cmd}");
        $ret = null;
        system($cmd, $ret);

        if ($ret !== 0) {
            $this->error("mysqldump falló (código {$ret}). Asegúrate que mysqldump esté instalado y en PATH.");
            return 1;
        }

        $this->info("Backup creado: storage/app/backups/{$name}");
        return 0;
    }
}
