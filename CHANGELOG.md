# Changelog

## 0.1.4 (2025-02-12)
* [default-app] - added appVersion params instead of default chart version; added chart version for selectorLabels;

## 0.1.3 (2025-02-04)
* [default-app] - fix notes syntax erorrs and improve condition handling; ignore CI manifests before packaging;

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