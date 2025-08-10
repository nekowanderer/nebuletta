# CoreDNS Fargate compatibility patch
# This is a prerequisite for AWS Load Balancer Controller to work properly
# because the controller needs DNS resolution to connect to AWS APIs

resource "null_resource" "coredns_fargate_patch" {
  # Trigger re-execution if cluster name changes
  triggers = {
    cluster_name = var.cluster_name
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}
      kubectl patch deployment coredns -n kube-system --type='merge' -p='{
        "spec": {
          "template": {
            "spec": {
              "tolerations": [
                {
                  "key": "CriticalAddonsOnly",
                  "operator": "Exists"
                },
                {
                  "key": "node-role.kubernetes.io/control-plane",
                  "effect": "NoSchedule"
                },
                {
                  "key": "node.kubernetes.io/not-ready",
                  "effect": "NoExecute",
                  "tolerationSeconds": 300
                },
                {
                  "key": "node.kubernetes.io/unreachable",
                  "effect": "NoExecute",
                  "tolerationSeconds": 300
                },
                {
                  "key": "eks.amazonaws.com/compute-type",
                  "operator": "Equal",
                  "value": "fargate",
                  "effect": "NoSchedule"
                }
              ]
            }
          }
        }
      }'
    EOT
  }
}
