#!/bin/bash
SNAPSHOT_DIR="snapshot_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$SNAPSHOT_DIR"

kubectl get nodes -o wide > "$SNAPSHOT_DIR/nodes.txt"
kubectl get all -A -o wide > "$SNAPSHOT_DIR/all_resources.txt"
kubectl get pv,pvc -A > "$SNAPSHOT_DIR/storage.txt"
kubectl get ingress -A -o wide > "$SNAPSHOT_DIR/ingress.txt"
kubectl get events -A --sort-by='.lastTimestamp' > "$SNAPSHOT_DIR/events.txt"

# Backup des manifests critiques
kubectl get deploy,sts,svc,cm,secret -A -o yaml > "$SNAPSHOT_DIR/manifests.yaml"

# Backup de la base de données (exemple MariaDB)
kubectl exec -n monprojet mariadb-0 -- mysqldump --all-databases --password='MonMdpSuperSecurise' > "$SNAPSHOT_DIR/mariadb_dump.sql"

echo "Snapshot sauvegardé dans $SNAPSHOT_DIR"