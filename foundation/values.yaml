# Enter your Kubernetes provider. Replace "YOUR_KUBERNETES_PROVIDER" with one of the following values:
#   k8s - for a deployment using open-source Kubernetes
#   openshift - for a deployment using Red Hat Openshift
#   eks - for a deployment using Amazon EKS
#   gke - for a deployment using Google Kubernetes Engine
#   pks - for a deployment using Pivotal Container Service
#   aks - for a deployment using Azure Kubernetes Service
provider: "eks"

actions:
  # valid values are install, deploy, install-deploy
  # install - install the pega platform database.
  # deploy - deploy the full pega cluster
  # install-deploy - installation followed by full pega cluster deployment
  # upgrade - upgrades the pega platform to the build version.
  # upgrade-deploy - upgrades the pega platform and deploys the pega cluster on the upgraded database.
  execute: "install-deploy"

# Configure Traefik for load balancing:
#   If enabled: true, Traefik is deployed automatically.
#   If enabled: false, Traefik is not deployed and load balancing must be configured manually.
#   Pega recommends enabling Traefik on providers other than Openshift and eks.
#   On Openshift, Traefik is ignored and Pega uses Openshift's built-in load balancer.
#   On eks it is recommended to use aws alb ingress controller.
traefik:
  enabled: false
  # Set any additional Traefik parameters. These values will be used by Traefik's helm chart.
  # See https://github.com/helm/charts/blob/master/stable/traefik/values.yaml
  # Set traefik.serviceType to "LoadBalancer" on gke, aks, and pks
  serviceType: NodePort
  # If enabled is set to "true", ssl will be enabled for traefik
  ssl:
    enabled: false
  rbac:
    enabled: true
  service:
    nodePorts:
      # NodePorts for traefik service.
      http: 30080
      https: 30443
  resources:
    requests:
      # Enter the CPU Request for traefik
      cpu: 200m
      # Enter the memory request for traefik
      memory: 200Mi
    limits:
      # Enter the CPU Limit for traefik
      cpu: 500m
      # Enter the memory limit for traefik
      memory: 500Mi

# Set this to true to install aws-alb-ingress-controller. Follow below guidelines specific to each provider,
# For EKS - set this to true.
# GKE or AKS or K8s or Openshift - set this to false and enable traefik.
aws-alb-ingress-controller:
  enabled: true 
  ## Resources created by the ALB Ingress controller will be prefixed with this string
  clusterName: "pega-demo"
  ## Auto Discover awsRegion from ec2metadata, set this to true and omit awsRegion when ec2metadata is available.
  autoDiscoverAwsRegion: true
  ## AWS region of k8s cluster, required if ec2metadata is unavailable from controller pod
  ## Required if autoDiscoverAwsRegion != true
  awsRegion: "us-west-2"
  ## Auto Discover awsVpcID from ec2metadata, set this to true and omit awsVpcID: " when ec2metadata is available.
  autoDiscoverAwsVpcID: true
  ## VPC ID of k8s cluster, required if ec2metadata is unavailable from controller pod
  ## Required if autoDiscoverAwsVpcID != true
  awsVpcID: "vpc-015cd7e27be63733e"
  extraEnv:
    AWS_ACCESS_KEY_ID: ""
    AWS_SECRET_ACCESS_KEY: ""

# Docker image information for the Pega docker image, containing the application server.
# To use this feature you MUST host the image using a private registry.
# See https://kubernetes.io/docs/concepts/containers/images/#using-a-private-registry
# Note: the imagePullPolicy is always for all images in this deployment, so pre-pulling images will not work.
docker:
  installer:
    image: "selvapal/pega-installer-ready:latest"
  pega:
    image: "selvapal/pega:latest"
  registry:
    url: "https://index.docker.io/v1/"
    # Provide your Docker registry username and password to access the docker image. These credentials will be
    # used for both the Pega Platform image and the Elasticsearch image.
    username: "selvapal"
    password: " "

  url: "jdbc:postgresql://pega-demo.cvg3oerprfmb.us-west-2.rds.amazonaws.com:5432/postgres"
  driverClass: "org.postgresql.Driver"
  # Set the database type only for action = install/install-deploy/upgrade/upgrade-deploy. Valid values are: mssql, oracledate, udb, db2zos, postgres
  dbType: "postgres"
  # Set the uri to download the database driver for your database.
  driverUri: "https://jdbc.postgresql.org/download/postgresql-42.2.5.jar"
  # Set your database username and password. These values will be obfuscated and stored in a secrets file.
  username: "postgres"
  password: "postgres"
  # Set your connection properties that will be sent to our JDBC driver when establishing new connections,Format of the string must be [propertyName=property;]
  connectionProperties: "socketTimeout=90"
  # Set the rules and data schemas for your database. Additional schemas can be defined within Pega.
  rulesSchema: "rules"
  dataSchema: "data"
  # If configured, set the customerdata schema for your database. Defaults to value of dataSchema if not provided.
  customerDataSchema: ""

# Customer specific information to customize the installation
installer:
  # Creates a new System and replaces this with default system.Default is pega
  systemName: "pega"
  # Creates the system with this production level.Default is 2
  productionLevel: 2
  # Whether this is a Multitenant System ('true' if yes, 'false' if no)
  multitenantSystem: "false"
  # UDF generation will be skipped if this property is set to true
  bypassUdfGeneration: "true"
  # Temporary password for administrator@pega.com that is used to install Pega Platform
  adminPassword: "install"
  # Run the Static Assembler ('true' to run, 'false' to not run)
  assembler:
  # Bypass automatically truncating PR_SYS_UPDATESCACHE . Default is false.
  bypassTruncateUpdatescache: "false"
  # JDBC custom connection properties
  jdbcCustomConnection: ""
  threads:
    # Maximum Idle Thread.Default is 5
    maxIdle: 5
    # Maximum Wait Thread.Default is -1
    maxWait: -1
    # Maximum Active Thread.Default is 10
    maxActive: 10

# Pega web deployment settings.
web:
  # Enter the domain name to access web nodes via a load balancer.
  #  e.g. web.mypega.example.com
  domain: "pegademoweb"
  # Enter the number of web nodes for Kubernetes to deploy (minimum 1).
  replicas: 1
  # For an overview of setting CPU and memory resources, see https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/.
  # Enter the CPU request for each web node (recommended 200m).
  cpuRequest: 200m
  # Enter the memory request for each web node (recommended 6Gi).
  memRequest: "6Gi"
  # Enter the CPU limit for each web node (recommended 2).
  cpuLimit: 2
  # Enter the memory limit for each web node (recommended 8Gi).
  memLimit: "8Gi"
  # Enter any additional java options.
  javaOpts: ""
  # Initial heap size for the jvm.
  initialHeap: "4096m"
  # Maximum heap size for the jvm.
  maxHeap: "7168m"
  # Set your Pega diagnostic credentials.
  pegaDiagnosticUser: ""
  pegaDiagnosticPassword: ""
  # When provider is eks, configure alb cookie duration seconds equal to passivation time of requestors
  alb_stickiness_lb_cookie_duration_seconds: 3660
  deploymentStrategy:
    rollingUpdate:
      # Enter the maximum number of Pods that can be unavailable during the update process. The value can be an absolute number (for example, 5) or a percentage of desired Pods (for example, 10%)
      maxSurge: 25%
      # Enter the maximum number of Pods that can be created over the desired number of Pods. The value can be an absolute number (for example, 5) or a percentage of desired Pods (for example, 10%)
      maxUnavailable: 25%
    type: RollingUpdate
  hpa:
    # Pega supports autoscaling of pods in your deployment using the Horizontal Pod Autoscaler (HPA) of Kubernetes. For details, see https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
    # Deployments of Pega Platform supports setting autoscaling thresholds based on CPU utilization and memory resources for a given pod in the deployment.
    # The recommended settings for CPU utilization and memory resource capacity thresholds are based on testing Pega application under heavy loads.
    # Customizing your thresholds to match your workloads will be based on your initial cpuRequest and memRequest web pod settings.
    enabled: true
    # Enter the minimum number of replicas that HPA can scale-down
    minReplicas: 1
    # Enter the maximum number of replicas that HPA can scale-up
    maxReplicas: 5
    # Enter the threshold value for average cpu utilization percentage.
    # Recommended value is 700% i.e. 1.4c (700% of 200m(recommended cpuRequest))
    # HPA will scale up if pega web pods average cpu utilization reaches 1.4c (based on Pega recommended values).
    targetAverageCPUUtilization: 700
    # Enter the threshold value for average memory utilization percentage.
    # Recommended value is 85% i.e. 5.1Gi (85% of 6Gi(recommended memRequest))
    # HPA will scale up if pega web pods average memory utilization reaches 5.1Gi (based on Pega recommended values).
    targetAverageMemoryUtilization: 85

# Pega stream deployment settings.
stream:
  # Enter the domain name to access stream nodes via a load balancer.
  #  e.g. stream.mypega.example.com
  domain: "pegademostream"
  # Enter the number of stream nodes for Kubernetes to deploy (minimum 2).
  replicas: 2
  # For an overview of setting CPU and memory resources, see https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/.
  # Enter the CPU request for each stream node (recommended 200m).
  cpuRequest: 200m
  # Enter the memory request for each stream node (recommended 6Gi).
  memRequest: "6Gi"
  # Enter the CPU limit for each stream node (recommended 2).
  cpuLimit: 2
  # Enter the memory limit for each stream node (recommended 8Gi).
  memLimit: "8Gi"
  # Enter any additional java options
  javaOpts: ""
  # Initial heap size for the jvm
  initialHeap: "4096m"
  # Maximum heap size for the jvm
  maxHeap: "7168m"
  # When provider is eks, configure alb cookie duration seconds equal to passivation time of requestors
  alb_stickiness_lb_cookie_duration_seconds: 3660

# Pega batch deployment settings.
batch:
  # Enter the number of batch nodes for Kubernetes to deploy (minimum 1).
  replicas: 1
  # For an overview of setting CPU and memory resources, see https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/.
  # Enter the CPU request for each batch node (recommended 200m).
  cpuRequest: 200m
  # Enter the memory request for each batch node (recommended 6Gi).
  memRequest: "6Gi"
  # Enter the CPU limit for each batch node (recommended 2).
  cpuLimit: 2
  # Enter the memory limit for each batch node (recommended 8Gi).
  memLimit: "8Gi"
  # Enter any additional java options.
  javaOpts: ""
  # Initial heap size for the jvm.
  initialHeap: "4096m"
  # Maximum heap size for the jvm.
  maxHeap: "7168m"
  deploymentStrategy:
    rollingUpdate:
      # Enter the maximum number of Pods that can be unavailable during the update process. The value can be an absolute number (for example, 5) or a percentage of desired Pods (for example, 10%)
      maxSurge: 25%
      # Enter the maximum number of Pods that can be created over the desired number of Pods. The value can be an absolute number (for example, 5) or a percentage of desired Pods (for example, 10%)
      maxUnavailable: 25%
    type: RollingUpdate
  hpa:
    # Pega supports autoscaling of pods in your deployment using the Horizontal Pod Autoscaler (HPA) of Kubernetes. For details, see https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
    # Deployments of Pega Platform supports setting autoscaling thresholds based on CPU utilization and memory resources for a given pod in the deployment.
    # The recommended settings for CPU utilization and memory resource capacity thresholds are based on testing Pega application under heavy loads.
    # Customizing your thresholds to match your workloads will be based on your initial cpuRequest and memRequest batch pod settings.
    enabled: true
    # Enter the minimum number of replicas that HPA can scale-down
    minReplicas: 1
    # Enter the maximum number of replicas that HPA can scale-up
    maxReplicas: 3
    # Enter the threshold value for average cpu utilization percentage.
    # Recommended value is 700% i.e. 1.4c (700% of 200m(recommended cpuRequest))
    # HPA will scale up if pega batch pods average cpu utilization reaches 1.4c (based on Pega recommended values).
    targetAverageCPUUtilization: 700
    # Enter the threshold value for average memory utilization percentage.
    # Recommended value is 85% i.e. 5.1Gi (80% of 6Gi(recommended memRequest))
    # HPA will scale up if pega batch pods average memory utilization reaches 5.1Gi (based on Pega recommended values).
    targetAverageMemoryUtilization: 85
