# k8s-runbook

**Déployer une application conteneurisée sur Kubernetes**  
De zéro · bare metal, VMware ou machine locale

> Ce runbook n'est pas un tutoriel de plus. C'est une séquence opérationnelle : chaque étape est une action, chaque vérification est concrète, chaque avertissement signale ce que l'IA génère sans vous dire.

---

## Public cible

Ingénieurs système connaissant la virtualisation, le stockage et les backups.  
Vous savez ce qu'est un disque, un réseau, une VM. Vous apprenez Kubernetes.

---

## Contenu

| Étape | Sujet | Fichiers |
|-------|-------|---------|
| 1 | Choisir l'infrastructure (local / bare metal / vSphere) | — |
| 2 | Installer Kubernetes (Minikube ou kubeadm) | `scripts/Install_avec_KubeADM.sh` · `scripts/Test_Minikube.sh` |
| 3 | Configurer le réseau et CoreDNS | `scripts/déploiement_Coredns.sh` · `scripts/vérif_coreDNS.sh` |
| 4 | Stockage persistant + MariaDB | `manifests/Mariadb-statefulset.yaml` · `manifests/path_volume.yaml` · `scripts/mariadb.sh` |
| 5 | Application web + Ingress | `manifests/application_web_via_ingres.yaml` · `manifests/ingress.yaml` |
| 6 | Snapshot pré-maintenance + shutdown propre | `scripts/pre_shutdown_snapshot.sh` · `scripts/execute_shutdown.sh` |

---

## Structure du repo

```
k8s-runbook/
├── README.md                        ← ce fichier
├── manifests/
│   ├── application_web_via_ingres.yaml
│   ├── ingress.yaml
│   ├── Mariadb-statefulset.yaml
│   ├── path_volume.yaml
│   └── containers_resources.yaml
├── scripts/
│   ├── Install_avec_KubeADM.sh
│   ├── Test_Minikube.sh
│   ├── demarrer_le_cluster.sh
│   ├── enable_acces_http.sh
│   ├── déploiement_Coredns.sh
│   ├── vérif_coreDNS.sh
│   ├── vérif_multinoeuds.sh
│   ├── mariadb.sh
│   ├── path_bdd_externe.sh
│   ├── tester_lacces.sh
│   ├── pre_shutdown_snapshot.sh
│   └── execute_shutdown.sh
└── docs/
    └── concepts.md                  ← vocabulaire K8s essentiel
```

---

## Principe de lecture

Chaque section du runbook suit ce schéma :

```
Objectif → Action → Commande → Vérification → ⚠ Ce que l'IA omet
```

L'avertissement ⚠ est la valeur ajoutée de ce document.  
L'IA génère du YAML qui fonctionne. Elle ne signale pas ce qui manque pour que ce soit sûr.

---

## Ce que l'IA omet — résumé

| Sujet | Omission fréquente |
|-------|-------------------|
| kubeadm | Swap non désactivé → kubelet échoue silencieusement |
| Secrets | Encodés base64, pas chiffrés — utiliser Vault en production |
| Ingress | TLS absent par défaut — ajouter cert-manager |
| CoreDNS | Pas de resource limits → saturation nœud possible |
| PV hostPath | Ne suit pas le pod sur un autre nœud — CSI driver en production |
| drain | Sans PodDisruptionBudget → interruption de service silencieuse |
| Dump SQL | Ne remplace pas le snapshot PV — toujours faire les deux |

---

## Prérequis

- `kubectl` installé et configuré (`~/.kube/config`)
- Minikube **ou** cluster kubeadm opérationnel
- `base64`, `mysqldump` disponibles sur le poste de travail

---

## Auteur

Moez L'Agha — [MTC Computing](https://github.com/mtccomputing)  
Runbook series · Infrastructure · SAP FICO · GED
