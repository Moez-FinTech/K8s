kubectl create secret generic db-external \
  --from-literal=host=192.168.1.50 \
  --from-literal=password=monMdp