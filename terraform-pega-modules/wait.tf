resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "echo ${var.wait_id}"
  }
}
