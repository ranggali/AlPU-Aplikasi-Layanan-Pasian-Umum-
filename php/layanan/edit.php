<?php
$conn = new mysqli("localhost", "root", "", "layanan");

if ($conn->connect_error) {
    die("Koneksi Gagal: " . $conn->connect_error);
}

$id_poli = $_POST["id_poli"];
$nama_poli = $_POST["nama_poli"];
$detail = $_POST["detail"];
$data = mysqli_query($conn, "UPDATE poliklinik SET nama_poli='$nama_poli', detail='$detail' WHERE id_poli = '$id_poli'");

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