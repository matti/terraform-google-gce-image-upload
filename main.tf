resource "null_resource" "start" {
  provisioner "local-exec" {
    command = "echo depends_id=${var.depends_id}"
  }
}

locals {
  image_hash                      = "${sha1(file(var.source_tar_gz))}"
  image_filename_with_hash_tar_gz = "${var.name}-${local.image_hash}.tar.gz"
}

resource "google_storage_bucket_object" "image" {
  depends_on = ["null_resource.start"]

  name   = "${local.image_filename_with_hash_tar_gz}"
  source = "${var.source_tar_gz}"
  bucket = "${var.bucket_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_image" "image" {
  name = "${var.name}-${local.image_hash}"

  raw_disk {
    source = "https://storage.googleapis.com/${var.bucket_name}/${google_storage_bucket_object.image.name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
