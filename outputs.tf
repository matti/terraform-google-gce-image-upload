output "id" {
  value = "${google_compute_image.image.id}"
}

output "image_name" {
  value = "${google_compute_image.image.name}"
}

output "self_link" {
  value = "${google_compute_image.image.self_link}"
}
