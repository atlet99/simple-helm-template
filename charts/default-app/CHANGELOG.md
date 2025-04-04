# Changelog

## 0.3.4 (2025-04-02)
* [default-app] - added revisionHistoryLimit parameter with default value 3;

## 0.3.3 (2025-03-27)
* [default-app] - disable httpRoute by default; upd README;

## 0.3.2 (2025-03-27)
* [default-app] - added httpRoute and grpcRoute for ApiGateway;

## 0.3.1 (2025-03-20)
* [default-app] - enable default configMap/secrets key-value validation before deploying;

## 0.3.0 (2025-03-18)
* [default-app] - fix templateData conditions for ExternalSecrets;

## 0.2.9 (2025-03-17)
* [default-app] - removed chartVersion from all labels and annotations due GitOps issues; fix annotations/labels nindent length; 

## 0.2.8 (2025-03-17)
* [default-app] - fix spaces for volumeAttributes; removed chartVersion from selectors;

## 0.2.7 (2025-03-17)
* [default-app] - fix conditions for existingSecrets/existingConfigs in deployment;

## 0.2.6 (2025-03-17)
* [default-app] - upgrade pv/pvc conditions;

## 0.2.5 (2025-03-17)
* [default-app] - added mechanism for including existed configmaps and secrets via env/envFrom; added extended params for pv via csi and s3 plugins; added new README;

## 0.2.4 (2025-03-17)
* [default-app] - fix deployment conditions for pv/pvc; added list of pv/pvc for multiple volumes;

## 0.2.3 (2025-03-17)
* [default-app] - fix ns for secretStoreRef in externalSecrets; upd README; added pv; upd pvc mechanism;

## 0.2.2 (2025-03-14)
* [default-app] - added init containers and includes minor fixes connect to volumes and vl mounts;

## 0.2.1 (2025-03-14)
* [default-app] - fix issue with SA; added conditions for mountPath and vl includes in secrets and externalSecrets; added subPath and subPathExpr, minor fixes;

## 0.2.0 (2025-03-13)
* [default-app] - added new conditions for creation specific resources like a standalone, for example, only deployment, only external-secrets; fix values;

## 0.1.9 (2025-03-12)
* [default-app] - added gh workflows for releasing public OCI repo; fix yml to yaml; fix manual commit to gh-pages; fix workflow params; fix structure issue;

## 0.1.9 (2025-02-27)
* [default-app] - realized env params via cm and secrets with used keys and var names; fix: - comments examples; added externalSecrets params, checks (without dry-run mode) and minor fixes in volumes;

## 0.1.8 (2025-02-25)
* [default-app] - added multiple cm with separate data; added multiple secret with separate data; fixes volume params for cm, secrets;

## 0.1.7 (2025-02-25)
* [default-app] - fix cm readOnly params conditions; 

## 0.1.7 (2025-02-24)
* [default-app] - fix configmap syntax and rendering;

## 0.1.6 (2025-02-24)
* [default-app] - fix securityContext params and added containerSecurityContext; fix labels and annotations; 

## 0.1.6 (2025-02-21)
* [default-app] - fix deployment templates; fix context argument into include method; change ingress service port to service name for more clear and secure reading; fix fullnameOverride parameter for existence, improved via haskey; improve ports choosing via any conditions and haskey; fix template for fullname; fix fullname templates and fix ingress route to specific svc name;

## 0.1.5 (2025-02-20)
* [default-app] - fix ingress route to correct svc name; configmap vl permissions; fix typo;

## 0.1.5 (2025-02-18)
* [default-app] - added cm and secret/external-secret volume mounts (by default disabled); fix issue with checking ESO crd; fix default StorageClass; fix rendering imagePullSecrets; fix rendering sa; added example for imagePullSecrets; fix suffix "sa" in sa; fix cm params via range; fix cm typo; return and fix cm file name via vars; fix typos; fix cm permissions;

## 0.1.5 (2025-02-17)
* [default-app] - fixes issue with creates permanent secrets; added default icon; added externalSecrets for using envFrom via ESO like 2 modes: SecretStore and ClusterSecretStore; fix issue with boolean checks in deployment; move data.property to dynamic params for specific providers (like a Yandex LockBox); fix annotations params for pvc;

## 0.1.4 (2025-02-12)
* [default-app] - added appVersion params instead of default chart version; added chart version for selectorLabels; added minor info labels; minor fixes with typo and add extended labels;

## 0.1.3 (2025-02-04)
* [default-app] - fix notes syntax errors and improve condition handling; ignore CI manifests before packaging;

## 0.1.3 (2025-02-03)
* [default-app] - added namespace override to allow installation into a different namespace; added suffix to naming params; use full name instead chart.name; fix serviceAccount name; refactor secrets; fix duplicate lines in service; change line space in configmap; enable cm and secrets mount via env; added example for secrets; fix notes params and descriptions;

## 0.1.2 (2025-02-02)
* [default-app] - added LICENSE; added README; 

## 0.1.1 (2025-02-02)
* [default-app] - changelogs: disable automount sa creds; disable probes by default; disable persistence; enable grace period for termination; change semantic chart version; update .helmignore;

## 0.1.0 (2025-01-21)
* [default-app] - refactored Helm templates to improve default value handling, fix indentation issues, and ensure compatibility with empty or undefined variables; update chart values, templates and fix minor bugs;

## 0.1.0 (2025-01-20)
* [default-app] - init base helm template with a lot of bugs; minor fixes and bump params;