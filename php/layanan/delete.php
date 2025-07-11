<?php
$conn = new mysqli("localhost", "root", "", "layanan");

if ($conn->connect_error) {
    die("Koneksi Gagal: " . $conn->connect_error);
}

$id_poli = $_POST["id_poli"];
$data = mysqli_query($conn, "DELETE FROM poliklinik WHERE id_poli='$id_poli'");

if ($data) {
    echo json_encode([
        'pesan' => 'sukses'
    ]);
} else {
    echo json_encode([
        'pesan' => 'gagal'
    ]);
}

$conn->close();
?>