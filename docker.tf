locals {
  path_include  = ["**"]
  path_exclude  = var.excluded_files_for_build
  files_include = setunion([for f in local.path_include : fileset("${path.cwd}/${var.path_to_dockerfile_dir}", f)]...)
  files_exclude = setunion([for f in local.path_exclude : fileset("${path.cwd}/${var.path_to_dockerfile_dir}", f)]...)
  files         = sort(setsubtract(local.files_include, local.files_exclude))

  dir_sha = sha1(join("", [for f in local.files : filesha1("${path.cwd}/${var.path_to_dockerfile_dir}/${f}")]))
}

resource "docker_image" "this" {
  name = var.name

  build {
    context = abspath(var.path_to_dockerfile_dir)
    tag = [
      "${aws_ecr_repository.this.repository_url}:latest",
      "${aws_ecr_repository.this.repository_url}:${local.dir_sha}"
    ]
    platform = var.target_arch
  }

  triggers = {
    dir_sha = local.dir_sha
  }

  keep_locally = true

  depends_on = [
    null_resource.before_build_hook
  ]
}

resource "null_resource" "docker_push" {
  triggers = {
    dir_sha = local.dir_sha
  }

  depends_on = [
    docker_image.this
  ]

  provisioner "local-exec" {
    command = <<-EOT
      docker push ${aws_ecr_repository.this.repository_url}:latest
      docker push ${aws_ecr_repository.this.repository_url}:${local.dir_sha}
    EOT
  }
}