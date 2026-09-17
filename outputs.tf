output "jumphost_external_ip" {
  description = "External IP of the jumphost instance"
  value       = google_compute_instance.jumphost.network_interface[0].access_config[0].nat_ip
}

output "primary_internal_ip" {
  description = "Internal IP of the primary instance"
  value       = google_compute_instance.primary.network_interface[0].network_ip
}
