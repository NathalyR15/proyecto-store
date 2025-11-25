<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;

class BackupController extends Controller
{
    public function index(Request $request)
    {
        return response()->json(["message" => "backup placeholder"]);
    }
}