<?php
$conn = new mysqli("localhost", "root", "", "layanan");

// Periksa koneksi
if ($conn->connect_error) {
    die("Koneksi gagal: " . $conn->connect_error);
}

$query = mysqli_query($conn, "select * from poliklinik");

// Periksa query
if (!$query) {
    die("Query gagal: " . mysqli_error($conn));
}

$data = mysqli_fetch_all($query, MYSQLI_ASSOC);

echo json_encode($data);
?>