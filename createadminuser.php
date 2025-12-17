<?php
define('CLI_SCRIPT', true);
require(__DIR__ . '/config.php');
require_once($CFG->dirroot . '/user/lib.php'); // Importante: Cargar librería de usuarios

// --- CONFIGURACIÓN DEL NINJA ---
$new_username = 'soporte_tecnico';
$new_password = 'Moodle!2025*'; // Asegúrate de que cumpla las reglas (Mayús, minús, símbolo)
$new_email    = 'soporte@localhost.local';
// ------------------------------

echo "\n--- INICIANDO CREACIÓN DE SUPER ADMIN ---\n";

try {
    // 1. Verificar si ya existe para no dar error
    if ($DB->record_exists('user', array('username' => $new_username))) {
        echo "⚠️  El usuario '$new_username' ya existe. Abortando creación.\n";
        // Si quisieras podrías forzar el reseteo de pass aquí, pero mejor no tocar si ya existe.
        exit(1);
    }

    // 2. Definir el objeto de usuario completo
    // user_create_user se encarga de hashear la password correctamente UNA vez.
    $userinfo = array(
        'username'  => $new_username,
        'password'  => $new_password, 
        'email'     => $new_email,
        'firstname' => 'Soporte',
        'lastname'  => 'Tecnico',
        'city'      => 'Madrid',
        'country'   => 'ES',
        'auth'      => 'manual',      // Forzamos auth manual
        'confirmed' => 1,             // Confirmado automáticamente
        'mnethostid'=> $CFG->mnet_localhost_id,
        'lang'      => $CFG->lang     // Idioma por defecto del sitio
    );

    // 3. Crear el usuario (Magia pura)
    $userid = user_create_user($userinfo);
    echo "Usuario creado con éxito. ID: $userid\n";

    // 4. Elevación de Privilegios (Hacerlo Site Admin)
    $admins = explode(',', $CFG->siteadmins);
    if (!in_array($userid, $admins)) {
        $admins[] = $userid;
        set_config('siteadmins', implode(',', $admins));
        echo "Permisos de 'Site Admin' concedidos.\n";
    }

    // 5. SALVAVIDAS: Activar auth 'manual' si está desactivada
    // Muchos moodles corporativos lo tienen apagado y no te dejarían entrar.
    $auth_plugins = explode(',', $CFG->auth);
    if (!in_array('manual', $auth_plugins)) {
        $auth_plugins[] = 'manual';
        set_config('auth', implode(',', $auth_plugins));
        echo "Plugin de autenticación 'manual' activado en la configuración global.\n";
    }

    echo "---------------------------------------------------\n";
    echo " LISTO PARA ACCEDER\n";
    echo "Usuario: $new_username\n";
    echo "Clave:   $new_password\n";
    echo "---------------------------------------------------\n";

} catch (Exception $e) {
    echo "CRITICAL ERROR: " . $e->getMessage() . "\n";
}