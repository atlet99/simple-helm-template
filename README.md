# Default App Helm Chart

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/atlet99/simple-helm-template/blob/main/LICENSE) ![Publish Charts](https://github.com/atlet99/simple-helm-template/actions/workflows/helm-publish.yaml/badge.svg?branch=main) ![Repo Updates](https://github.com/atlet99/simple-helm-template/actions/workflows/helm-update-gh-pages.yaml/badge.svg?branch=main) [![Releases downloads](https://img.shields.io/github/downloads/atlet99/simple-helm-template/total.svg)](https://github.com/atlet99/simple-helm-template/releases)

This Helm Chart is designed to deploy applications in Kubernetes, providing a standardized structure and flexible configuration options. It supports various deployment scenarios including standalone deployments, external secrets management, and persistent storage configurations.

## Installation

Ensure that Helm is installed and that you have access to a Kubernetes cluster before proceeding with the installation.

Add the Helm repository and update it:

```sh
helm repo add simple-chart https://atlet99.github.io/simple-helm-template
helm repo update
```

To install the application, run:

```sh
helm install my-app simple-chart/default-app -f values.yaml
```

To install the application with a specific version:

```sh
helm upgrade --install my-app simple-chart/default-app -f values.yaml --version 0.3.4 --atomic
```

## Checking

Check available versions of the chart:

```sh
helm search repo simple-chart/default-app --versions
```

Verify the chart archive download:

```sh
helm pull simple-chart/default-app --version 0.3.4
```

## Upgrading

To upgrade the application with new parameters:

```sh
helm upgrade my-app simple-chart/default-app -f values.yaml
```

## Uninstallation

To remove the release:

```sh
helm uninstall my-app
```

## Configuration

This Chart supports various parameters that can be defined in `values.yaml`. Below are the key configurations:

```yaml
# Application version
appVersion: "1.0.0"

# Number of replicas
replicaCount: 1

# Container image configuration
image:
  repository: {}
  pullPolicy: IfNotPresent
  tag: ""

# Image pull secrets
imagePullSecrets: []

# Name overrides
nameOverride: ""
fullnameOverride: ""

# Namespace override
namespaceOverride: ""

# Service account configuration
serviceAccount:
  create: false
  automount: false
  name: ""

# Pod configuration
podAnnotations: {}
podLabels: {}

# Security context configuration
containerSecurityContext: {}
podSecurityContext: {}

# Service configuration
service:
  type: ClusterIP
  ports:
    - name: http
      port: 80
      targetPort: http
      protocol: TCP
      nodePort: null

# Ingress configuration
ingress:
  enabled: false
  className: ""
  annotations: {}
  hosts:
    - host: chart-example.local
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls: []

# Resource limits and requests
resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi

# Autoscaling configuration
autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 100
  targetCPUUtilizationPercentage: 80
  targetMemoryUtilizationPercentage: 80
  scaleUpCooldownPeriod: 180
  scaleDownCooldownPeriod: 300
  metrics: []

# Persistent storage configuration
persistent:
  pv:
    enabled: false
    volumes:
      - name: "translate-s3-back-pv"
        size: 10Gi
        accessModes:
          - ReadWriteMany
        storageClass: "csi-s3"
        namespace: "special-ns"
        reclaimPolicy: "Retain"
        volumeMode: {}
        nodeAffinity: []
        annotations:
          description: "This is a custom PV for the translate-s3-back"
        claimRef:
          name: "special-claim"
          namespace: "special-ns"
        csi:
          driver: "ru.yandex.s3.csi"
          volumeHandle: "translate-s3-back"
          volumeAttributes:
            capacity: "1Gi"
            mounter: "geesefs"
            options: "--memory-limit=256 --dir-mode=0644 --file-mode=0644 --uid=1000 --gid=1000"
          controllerPublishSecretRef:
            name: "s3-secret"
            namespace: "secret-ns"
          nodePublishSecretRef:
            name: "s3-secret-node-publish"
            namespace: "secret-ns"
          nodeStageSecretRef:
            name: "s3-secret-node-stage"
            namespace: "secret-ns"

# Node selection and scheduling
nodeSelector: {}
tolerations: []
affinity: {}
priorityClassName: ""

# Pod disruption budget
podDisruptionBudget:
  enabled: false
  minAvailable: 1

# Pod termination grace period
terminationGracePeriodSeconds: 30

# Deployment revision history limit
revisionHistoryLimit: 3

# ConfigMap configuration
configs:
  appConfig:
    enabled: true
    name: "app-config"
    mountPath: "/config/app"
    fileName: "app-config.yaml"
    readOnly: false
    data: |
      user nginx;
      worker_processes auto;
      events { worker_connections 1024; }
      http {
        server {
          listen 80;
          server_name localhost;
          location / {
            root /usr/share/nginx/html;
            index index.html index.htm;
          }
        }
      }

# Secrets configuration
secrets:
  dbSecret:
    enabled: true
    name: "db-secret"
    mountPath: "/config/db-secret"
    fileName: "db-secret.yaml"
    readOnly: true
    data: |
      DB_USER: "postgres"
      DB_PASS: "supersecret"

# External secrets configuration
externalSecrets:
  enabled: false
  secretStoreName: "default-secret-store"
  kind: "SecretStore"
  refreshInterval: "1h"
  data:
    - secretKey: "DB_PASSWORD"
      remoteRef:
        key: "database/password"

# Existing ConfigMaps and Secrets
existingConfigs:
  - name: "app-config"
    enabled: true
    namespace: "default"
    mountPath: "/config/app"
    subPath: "app-config.yaml"
    readOnly: true
  - name: "db-config"
    enabled: true
    namespace: "default"
    useEnvFrom: true

existingSecrets:
  - name: "app-secret"
    enabled: true
    namespace: "default"
    mountPath: "/secret/app"
    subPath: "app-secret.env"
    readOnly: true
  - name: "db-secret"
    enabled: true
    namespace: "default"
    envFrom: true
```

## Persistent Storage

This Chart supports persistent storage configuration, including manually specified Persistent Volumes (PVs) and Persistent Volume Claims (PVCs):

```yaml
persistent:
  pv:
    enabled: true
    volumes:
      - name: "translate-s3-back-pv"
        size: 10Gi
        accessModes:
          - ReadWriteMany
        storageClass: "csi-s3"
        namespace: "special-ns"
        reclaimPolicy: "Retain"
        volumeMode: {}
        nodeAffinity: []
        annotations:
          description: "This is a custom PV for the translate-s3-back"
        claimRef:
          name: "special-claim"
          namespace: "special-ns"
        csi:
          driver: "ru.yandex.s3.csi"
          volumeHandle: "translate-s3-back"
          volumeAttributes:
            capacity: "1Gi"
            mounter: "geesefs"
            options: "--memory-limit=256 --dir-mode=0644 --file-mode=0644 --uid=1000 --gid=1000"
          controllerPublishSecretRef:
            name: "s3-secret"
            namespace: "secret-ns"
          nodePublishSecretRef:
            name: "s3-secret-node-publish"
            namespace: "secret-ns"
          nodeStageSecretRef:
            name: "s3-secret-node-stage"
            namespace: "secret-ns"
```

## Handling Sensitive Data with Secrets

This Helm chart supports Kubernetes Secrets to securely manage sensitive information such as API keys, database passwords, and authentication credentials.

Example Secret configuration:

```yaml
secrets:
  dbSecret:
    enabled: true
    name: "db-secret"
    mountPath: "/config/db-secret"
    fileName: "db-secret.yaml"
    readOnly: true
    data: |
      DB_USER: "postgres"
      DB_PASS: "supersecret"
```

Secrets can also be injected as environment variables:

```yaml
envFrom:
  - secretRef:
      name: "db-secret"
```

## Using Existing ConfigMaps and Secrets

You can use existing ConfigMaps and Secrets from your cluster:

```yaml
existingConfigs:
  - name: "app-config"
    enabled: true
    namespace: "default"
    mountPath: "/config/app"
    subPath: "app-config.yaml"
    readOnly: true
  - name: "db-config"
    enabled: true
    namespace: "default"
    useEnvFrom: true

existingSecrets:
  - name: "app-secret"
    enabled: true
    namespace: "default"
    mountPath: "/secret/app"
    subPath: "app-secret.env"
    readOnly: true
  - name: "db-secret"
    enabled: true
    namespace: "default"
    envFrom: true
```

## External Secrets

This chart supports external secrets using External Secret Operator (ESO):

```yaml
externalSecrets:
  enabled: false
  secretStoreName: "default-secret-store"
  kind: "SecretStore"
  refreshInterval: "1h"
  data:
    - secretKey: "DB_PASSWORD"
      remoteRef:
        key: "database/password"
```

## Termination Grace Period

Define how long the pod should wait before termination:

```yaml
terminationGracePeriodSeconds: 30
```

## Parameters

### Common parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `appVersion`        | Application version                                | `"1.0.0"`       |
| `nameOverride`      | String to partially override common.names.fullname | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname     | `""`            |
| `namespaceOverride` | Override the namespace for all resources           | `""`            |

### Image parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `image.repository`  | Container image repository                         | `{}`            |
| `image.tag`         | Container image tag                               | `""`            |
| `image.pullPolicy`  | Container image pull policy                       | `IfNotPresent`  |
| `imagePullSecrets`  | Array of image pull secrets                       | `[]`            |

### Deployment parameters

| Name                           | Description                                        | Value           |
| ----------------------------- | -------------------------------------------------- | --------------- |
| `replicaCount`                | Number of replicas                                | `1`             |
| `revisionHistoryLimit`        | Number of deployment revisions to keep            | `3`             |
| `podAnnotations`              | Pod annotations                                   | `{}`            |
| `podLabels`                   | Pod labels                                        | `{}`            |
| `containerSecurityContext`    | Container security context                        | `{}`            |
| `podSecurityContext`          | Pod security context                              | `{}`            |
| `terminationGracePeriodSeconds` | Pod termination grace period                    | `30`            |

### Service parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `service.type`      | Service type                                      | `ClusterIP`     |
| `service.ports`     | Service ports configuration                       | `[]`            |

### Ingress parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `ingress.enabled`   | Enable ingress                                    | `false`         |
| `ingress.className` | Ingress class name                                | `""`            |
| `ingress.annotations` | Ingress annotations                              | `{}`            |
| `ingress.hosts`     | Ingress hosts configuration                       | `[]`            |
| `ingress.tls`       | Ingress TLS configuration                         | `[]`            |

### Resource parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `resources.limits`  | Resource limits                                   | `{}`            |
| `resources.requests` | Resource requests                                 | `{}`            |

### Autoscaling parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `autoscaling.enabled` | Enable autoscaling                               | `false`         |
| `autoscaling.minReplicas` | Minimum number of replicas                    | `1`             |
| `autoscaling.maxReplicas` | Maximum number of replicas                    | `100`           |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization | `80`             |
| `autoscaling.targetMemoryUtilizationPercentage` | Target memory utilization | `80`         |
| `autoscaling.scaleUpCooldownPeriod` | Scale up cooldown period                    | `180`           |
| `autoscaling.scaleDownCooldownPeriod` | Scale down cooldown period                  | `300`           |
| `autoscaling.metrics` | Custom metrics for autoscaling                  | `[]`            |

### Storage parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `persistent.pv.enabled` | Enable persistent volumes                        | `false`         |
| `persistent.pv.volumes` | Persistent volume configurations                | `[]`            |

### Service Account parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `serviceAccount.create` | Create service account                          | `false`         |
| `serviceAccount.automount` | Automount service account token                | `false`         |
| `serviceAccount.name` | Service account name                            | `""`            |

### Pod Disruption Budget parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `podDisruptionBudget.enabled` | Enable PDB                                    | `false`         |
| `podDisruptionBudget.minAvailable` | Minimum available pods                      | `1`             |

### ConfigMap parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `configs`           | ConfigMap configurations                          | `{}`            |
| `existingConfigs`   | Use existing ConfigMaps                           | `[]`            |

### Secret parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `secrets`           | Secret configurations                             | `{}`            |
| `existingSecrets`   | Use existing Secrets                              | `[]`            |
| `externalSecrets`   | External Secret configurations                    | `{}`            |

### Node selection parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `nodeSelector`      | Node selector for pod placement                   | `{}`            |
| `tolerations`       | Pod tolerations                                   | `[]`            |
| `affinity`          | Pod affinity rules                                | `{}`            |
| `priorityClassName` | Pod priority class name                           | `""`            |

## License

This Helm Chart is distributed under the [MIT](LICENSE) License.