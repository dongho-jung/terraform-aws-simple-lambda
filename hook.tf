locals {
  before_build_hook_trigger = (
    var.using_uv
    ? filesha256("${path.cwd}/${var.path_to_dockerfile_dir}/uv.lock")
    : ""
  )
  before_build_hook_command = (
    var.using_uv
    ? "uv export --no-dev > requirements.txt"
    : "true"
  )
}

resource "null_resource" "before_build_hook" {
  triggers = {
    trigger = local.before_build_hook_trigger
  }
  provisioner "local-exec" {
    working_dir = "${path.cwd}/${var.path_to_dockerfile_dir}"
    command     = local.before_build_hook_command
  }
}
