# Default App Helm Chart

This Helm Chart is designed to deploy applications in Kubernetes, providing a standardized structure and flexible configuration options.

## Installation

Ensure that Helm is installed and that you have access to a Kubernetes cluster before proceeding with the installation.

```sh
helm repo add simple-chart https://atlet99.github.io/simple-helm-template; \
helm repo update
```

To install the application, run:

```sh
helm install my-app simple-chart/default-app -f values.yaml
```

To install the application with specific version:
```sh
helm upgrade --install my-app simple-chart/default-app -f values.yaml --version 0.2.2 --atomic
```

## Checking

Check available versions of the chart:
```sh
helm search repo simple-chart/default-app --versions
```

Verify the chart archive download:
```sh
helm pull simple-chart/default-app --version 0.2.2
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

This Chart supports persistent storage configuration:

```yaml
persistent:
  enabled: true
  pvc:
    name: "custom-pvc"
    size: 10Gi
    storageClass: "fast-storage"
    accessModes:
      - ReadWriteMany
  mountPath: "/data"
  readOnly: false
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

In the deployment, ConfigMaps can be mounted as files inside the container or used as environment variables.
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

