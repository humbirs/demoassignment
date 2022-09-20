resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "ca" {
  #key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.ca.private_key_pem}"

  subject {
    common_name  = "${var.domain}"
    organization = "ACME"
  }

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "server_auth",
    "client_auth",
  ]

  validity_period_hours = 24000
  early_renewal_hours   = 720
  is_ca_certificate     = true
}

resource "tls_private_key" "default" {
  algorithm = "RSA"
}

resource "tls_cert_request" "default" {
  #key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.default.private_key_pem}"

  dns_names = [
    "${var.domain}",
    "www.${var.domain}",
  ]

  subject {
    common_name  = "${var.domain}"
    organization = "ACME"
  }
}

resource "tls_locally_signed_cert" "default" {
  cert_request_pem   = "${tls_cert_request.default.cert_request_pem}"
  #ca_key_algorithm   = "RSA"
  ca_private_key_pem = "${tls_private_key.ca.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.ca.cert_pem}"

  validity_period_hours = 42000

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}


#resource "local_file" "sscakey" {
#  filename = "sslcert/cakeypem"
#  content  = tls_private_key.ca.private_key_pem
#}
#
#resource "local_file" "sscacert" {
#  filename = "sslcert/cacertpem"
#  content  = tls_self_signed_cert.ca.cert_pem
#}
#
#resource "local_file" "sscertkey" {
#  filename = "sslcert/webcertkey"
#  content  = tls_private_key.default.private_key_pem
#}
#
#resource "local_file" "sscertcert" {
#  filename = "sslcert/webcertcert"
#  content  = tls_locally_signed_cert.default.cert_pem
#}


# provisioner "file" {
#   content     = "${module.bastion_self_signed_cert.ca_cert}"
#   #destination = "/etc/nginx/certs/ca.crt"
#   destination = "./ca.crt"
# }
#
# provisioner "file" {
#   content     = "${module.bastion_self_signed_cert.ca_key}"
#   #destination = "/etc/nginx/certs/ca.key"
#   destination = "./ca.key"
# }
#
# provisioner "file" {
#   content     = "${module.bastion_self_signed_cert.cert}"
#   #destination = "/etc/nginx/certs/default.crt"
#   destination = "./default.crt"
# }
#
# provisioner "file" {
#   content     = "${module.bastion_self_signed_cert.key}"
#   #destination = "/etc/nginx/certs/default.key"
#   destination = "./default.key"
# }

