# EKS-lab Guideline

## Launch Sequence
1. networking
2. cluster
3. iam-oidc
4. storage
5. lb-ctl
6. applications
7. hpa

## How to Verify HPA

After deploying HPA module, use the following command to see the actual value of the ingress hostname, then set it as temporary environment variable:
```bash
$ terramate run --tags dev-eks-applications -- terraform refresh

...

Outputs:

app_namespace = "nebuletta-app-ns"
beta_deployment_name = "beta-app-deployment"
beta_service_name = "beta-app-service-clusterip"
fargate_pod_execution_role_arn = "arn:aws:iam::362395300803:role/dev-eks-applications-fargate-pod-execution-role"
fargate_profile_arn = "arn:aws:eks:ap-northeast-1:362395300803:fargateprofile/dev-eks-cluster/nebuletta-app-fp/1ecc58d3-e1ee-95a0-bfa6-3cc17481281c"
fargate_profile_name = "nebuletta-app-fp"
fargate_profile_status = "ACTIVE"
ingress_address = "k8s-nebulettaekslab-4b28eb94af-1768308565.ap-northeast-1.elb.amazonaws.com"
ingress_hostname = "k8s-nebulettaekslab-4b28eb94af-1768308565.ap-northeast-1.elb.amazonaws.com"
ingress_name = "ingress-path"
prod_deployment_name = "prod-app-deployment"
prod_service_name = "prod-app-service-clusterip"

$ INGRESS_IP=k8s-nebulettaekslab-4b28eb94af-1768308565.ap-northeast-1.elb.amazonaws.com
$ echo $INGRESS_IP # make sure the environment variable has been set successfully

```

Open another terminal tab, use the following command to monitor the beta-app:
```bash
$ kubectl get pod -o wide -n nebuletta-app-ns -w | grep beta-app
```

Open the third tab, use the following command to monitor the CPU usage:
```bash
$ kubectl get hpa -n nebuletta-app-ns -w
```

Back to terminal tab 1, execute the following command for increasing the CPU usage:
```bash
$ while sleep 0.005; do curl -s ${INGRESS_IP}:80/beta -H 'Host: eks-lab.nebuletta.com'; done
```
- ⚠️ If you found that it's difficult to increase the CPU usage, try to adjust the scaling threshold.
