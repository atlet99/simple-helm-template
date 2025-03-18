# Default App Helm Chart

![Publish Charts](https://github.com/atlet99/simple-helm-template/actions/workflows/helm-publish.yaml/badge.svg?branch=main) ![Repo Updates](https://github.com/atlet99/simple-helm-template/actions/workflows/helm-update-gh-pages.yaml/badge.svg?branch=main) [![Releases downloads](https://img.shields.io/github/downloads/atlet99/simple-helm-template/total.svg)](https://github.com/atlet99/simple-helm-template/releases)

This Helm Chart is designed to deploy applications in Kubernetes, providing a standardized structure and flexible configuration options.

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
helm upgrade --install my-app simple-chart/default-app -f values.yaml --version 0.3.0 --atomic
```

## Checking

Check available versions of the chart:

```sh
helm search repo simple-chart/default-app --versions
```

Verify the chart archive download:

```sh
helm pull simple-chart/default-app --version 0.3.0
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
replicaCount: 1

image:
  repository: nginx
  tag: "latest"
  pullPolicy: IfNotPresent

serviceAccount:
  create: true
  automount: false

ingress:
  enabled: false
  className: "nginx"
  hosts:
    - host: app.example.com
      paths:
        - path: /
          pathType: Prefix
          port: 80

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        targetAverageUtilization: 75
    - type: Resource
      resource:
        name: memory
        targetAverageValue: 512Mi

env:
  - name: APP_ENV
    value: production
  - name: LOG_LEVEL
    value: info
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
        reclaimPolicy: "Retain"
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
      - name: "custom-pv"
        size: 10Gi
        accessModes:
          - ReadWriteOnce
        storageClass: "manual"
        reclaimPolicy: "Retain"
        volumeMode: "Filesystem"
        annotations: {}
        claimRef: {}
      - name: "custom-pv-2"
        size: 5Gi
        accessModes:
          - ReadWriteMany
        storageClass: "manual"
        reclaimPolicy: "Retain"
        volumeMode: "Filesystem"
        annotations: {}
  pvc:
    enabled: false
    claims:
      - name: "custom-pvc"
        size: 10Gi
        storageClass: "manual"
        accessModes:
          - ReadWriteOnce
        mountPath: "/custom-path"
        readOnly: false
```

## Using Existing ConfigMaps

If you have pre-existing ConfigMaps in your cluster, you can use them instead of defining new ones:

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
```

## Using Existing Secrets

Similarly, you can reference existing Kubernetes Secrets:

```yaml
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

## Pod Disruption Budget

To define a disruption budget:

```yaml
podDisruptionBudget:
  enabled: true
  minAvailable: 1
```

## Service Configuration

Define the service settings:

```yaml
service:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      name: http
```

## Monitoring and Logging

Enable logging with Loki:

```yaml
logging:
  enabled: true
  provider: loki
```

## External Secrets

This chart supports external secrets using External Secret Operator (ESO):

```yaml
externalSecrets:
  enabled: true
  name: "app-external-secret"
  secretStoreName: "default-secret-store"
  kind: "SecretStore"
  k8sSecretName: "app-secret"
  refreshInterval: "1h"
  data:
    - secretKey: "DB_PASSWORD"
      remoteKey: "secrets/app-secret"
      property: "db_password"
```

## Configuration with ConfigMaps

This chart allows you to define ConfigMaps to store environment variables, application configurations, or any required files.

Example ConfigMap configuration:

```yaml
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
```

In the deployment, ConfigMaps can be mounted as files inside the container or used as environment variables:

```yaml
envFrom:
  - configMapRef:
      name: "app-config"
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

## Termination Grace Period

Define how long the pod should wait before termination:

```yaml
terminationGracePeriodSeconds: 30
```

## License

This Helm Chart is distributed under the [MIT](LICENSE) License.