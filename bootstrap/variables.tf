variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "team_id" {
  description = "The team ID"
  type        = number
}

variable "github_repositories" {
  description = "GitHub repositories in 'owner/repo' format allowed to authenticate via WIF"
  type        = set(string)
}
