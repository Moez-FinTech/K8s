kubectl -n kube-system get pods | grep coredns   # deux pods doivent être Running
kubectl -n kube-system describe deployment coredns | grep -A5 Resources