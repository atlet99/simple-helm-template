# Default App Helm Chart

This Helm Chart is designed to deploy applications in Kubernetes, providing a standardized structure and flexible configuration options.

## Installation

Ensure that Helm is installed and that you have access to a Kubernetes cluster before proceeding with the installation.

```sh
helm repo add simple-chart https://atlet99.github.io/simple-helm-template
helm repo update
```

To install the application, run:

```sh
helm install my-app simple-chart/default-app -f values.yaml
```

To install the application with specific version:
```sh
helm upgrade --install my-app simple-chart/default-app -f values.yaml --version 0.1.9 --atomic
```

## Checking

To check pulling archive:
```sh
helm pull simple-chart/default-app --version 0.1.9
```

## Upgrading

To upgrade the application with new parameters:

```sh
helm upgrade my-app your-repo/default-app -f values.yaml
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

ingress:
  enabled: false
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
  mountPath: "/custom-path"
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

## Termination Grace Period

Define how long the pod should wait before termination:

```yaml
terminationGracePeriodSeconds: 30
```

## License

This Helm Chart is distributed under the [MIT](LICENSE) License.

