<!-- now we just redirect to the right page -->
<?php
$page = $_GET['doc'];
header("Location: doxygen/".$page);
?>
