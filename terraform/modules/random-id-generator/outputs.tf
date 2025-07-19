output "results" {
  description = "The generated random strings."
  value       = [for r in random_string.this : r.result]
}
