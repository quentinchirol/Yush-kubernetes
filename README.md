# Yush-kubernetes

GitOps repo — tout ce qui est ici est automatiquement déployé sur le cluster via Argo CD.

## Structure

```
Yush-kubernetes/
├── bootstrap/                        # À appliquer UNE SEULE FOIS à la main
│   ├── argocd-config.yaml            # Namespace, LoadBalancer, mot de passe, SSH GitHub
│   └── ghcr-secret-job.yaml          # Crée le secret GHCR dans le namespace default
│
├── argocd-appsets/
│   └── auto-discover.yaml            # 🪄 Magie : 1 dossier dans apps/ = 1 app Argo CD
│
└── apps/
    ├── _template/                    # Copier ce dossier pour créer une nouvelle app
    │   ├── deployment.yaml
    │   ├── service.yaml
    │   ├── secrets.yaml              # ⚠️ Ne pas commiter de vraies valeurs
    │   ├── database/
    │   │   └── statefulset.yaml      # PostgreSQL + PVC
    │   └── redis/
    │       └── deployment.yaml       # Cache Redis
    │
    └── nginx/                        # App existante (portfolio)
        ├── deployment.yaml
        └── service.yaml
```

## Ajouter une nouvelle app

1. Copier `apps/_template/` → `apps/<nom-app>/`
2. Remplacer `myapp` par le nom de ton app dans tous les fichiers
3. Supprimer les composants inutiles (ex: pas besoin de Redis ? supprimer le dossier)
4. Push sur GitHub
5. ✅ Argo CD détecte le dossier et déploie automatiquement (~3 min)

## Première installation (bootstrap)

```bash
# 1. Installer Argo CD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 2. Appliquer la config Argo CD
k3s kubectl apply -f bootstrap/argocd-config.yaml

# 3. Créer le secret GHCR
k3s kubectl apply -f bootstrap/ghcr-secret-job.yaml

# 4. Activer l'auto-découverte des apps
k3s kubectl apply -f argocd-appsets/auto-discover.yaml
```
