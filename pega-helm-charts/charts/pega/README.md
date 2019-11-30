# Pega Helm chart

The Pega Helm chart is used to deploy an instance of Pega Infinity into a Kubernetes environment.  This readme provides a detailed description of possible configurations and their default values as applicable.

## Supported providers

Enter your Kubernetes provider which will allow the Helm charts to configure to any differences between deployment environments.

Value       | Deployment target
---         | ---
k8s         | Open-source Kubernetes
openshift   | Red Hat Openshift
eks         | Amazon Elastic Kubernetes Service (EKS)
gke         | Google Kubernetes Engine (GKE)
pks         | Pivotal Container Service (PKS)
aks         | Microsoft Azure Kubernetes Service (AKS)

Example for a kubernetes environment:

```yaml
provider: "k8s"
```
<!--
## Actions

Use the `action` section in the helm chart to specify a deployment action.  The standard actions is to deploy against an already installed database, but you can also install or upgrade a Pega system.

For additional, required installation or upgrade parameters, see the [Installer section](#installer-settings).

Value             | Action
---               | ---
deploy            | Start the Pega containers using an existing Pega database installation.
install           | Install Pega Platform into your database without deploying.
install-deploy    | Install Pega Platform into your database and then deploy.
upgrade           | Upgrade the Pega Platform installation in your database.
upgrade-deploy    | Upgrade the Pega Platform installation in your database, and then deploy.

Example:

```yaml
action: "deploy"
```
-->
## JDBC Configuration

Use the `jdbc` section  of the values file to specify how to connect to the Pega database. *Pega must be installed to this database before deploying on Kubernetes*.  

### URL and Driver Class
These required connection details will point Pega to the correct database and provide the type of driver used to connect. Examples of the correct format to use are provided below. 

Example for Oracle:
```yaml
jdbc:
  url: jdbc:oracle:thin:@//YOUR_DB_HOST:1521/YOUR_DB_NAME
  driverClass: oracle.jdbc.OracleDriver
```
Example for Microsoft SQL Server:
```yaml
jdbc:
  url: jdbc:sqlserver://YOUR_DB_HOST:1433;databaseName=YOUR_DB_NAME;selectMethod=cursor;sendStringParametersAsUnicode=false
  driverClass: com.microsoft.sqlserver.jdbc.SQLServerDriver
```

Example for IBM DB2 for LUW:
```yaml
jdbc:
  url: jdbc:db2://YOUR_DB_HOST:50000/YOUR_DB_NAME:fullyMaterializeLobData=true;fullyMaterializeInputStreams=true;progressiveStreaming=2;useJDBC4ColumnNameAndLabelSemantics=2;
  driverClass: com.ibm.db2.jcc.DB2Driver
```

Example for IBM DB2 for z/OS:
```yaml
jdbc:
  url: jdbc:db2://YOUR_DB_HOST:50000/YOUR_DB_NAME
  driverClass: com.ibm.db2.jcc.DB2Driver
```

Example for PostgreSQL:
```yaml
jdbc:
  url: jdbc:postgresql://YOUR_DB_HOST:5432/YOUR_DB_NAME
  driverClass: org.postgresql.Driver
```

### Driver URI

Pega requires a database driver JAR to be provided for connecting to the relational database.  This JAR may either be baked into your image by extending the Pega provided Docker image, or it may be pulled in dynamically when the container is deployed.  If you want to pull in the driver during deployment, you will need to specify a URL to the driver using the `jdbc.driverUri` parameter.  This address must be visible and accessable from the process running inside the container.

### Authentication

The simplest way to provide database authorization is via the `jdbc.username` and `jdbc.password` parameters. These values will create a Kubernetes Secret and at runtime will be obfuscated and stored in a secrets file.

### Connection Properties

You may optionally set your connection properties that will be sent to our JDBC driver when establishing new connections.  The format of the string is `[propertyName=property;]`.

### Schemas

It is standard practice to have seperate schemas for your rules and data.  You may specify them as `rulesSchema` and `dataSchema`.  If desired, you may also optionally set the `customerDataSchema` for your database. The `customerDataSchema` defaults to value of `dataSchema` if not specified. Additional schemas can be defined within Pega.
 
 Example:
 
 ```yaml
jdbc:
  ...
  rulesSchema: "rules"
  dataSchema: "data"
  customerDataSchema: ""
```

## Docker

Specify the location for the Pega Docker image.  This image is available on DockerHub, but can also be mirrored and/or extended with the use of a private registry.  Specify the `url` of the image or use the default of pegasystems/pega.

When using a private registry that requires a username and password, specify them using the `docker.registry.username` and `docker.registry.password` parameters.

Note: the `imagePullPolicy` is always for all images in this deployment by default.

Example:

 ```yaml
docker:
  registry:
    url: "YOUR_DOCKER_REGISTRY"
    username: "YOUR_DOCKER_REGISTRY_USERNAME"
    password: "YOUR_DOCKER_REGISTRY_PASSWORD"
```

## Tiers of a Pega deployment

Pega supports deployment using a multi-tier architecture to separate processing and functions. Isolating processing in its own tier also allows for unique deployment configuration such as its own prconfig, resource allocations, or scaling characteristics.  Use the `tier` section in the helm chart to specify which tiers you wish to deploy and their logical tasks.  

### Tier examples

Three values.yaml files are provided to showcase real world deployment examples.  These examples can be used as a starting point for customization and are not expected to deployed as-is.

For more information about the architecture for how Pega Platform runs in a Pega cluster, see [How Pega Platform and applications are deployed on Kubernetes](https://community.pega.com/knowledgebase/articles/cloud-choice/how-pega-platform-and-applications-are-deployed-kubernetes).

#### Standard deployment using three tiers

To provision a three tier Pega cluster, use the default example in the in the helm chart, which is a good starting point for most deployments:

Tier name     | Description
---           |---
web           | Interactive, foreground processing nodes that are exposed to the load balancer. Pega recommends that these node use the node classification “WebUser” `nodetype`.
batch         | Background processing nodes which handle workloads for non-interactive processing. Pega recommends that these node use the node classification “BackgroundProcessing” `nodetype`. These nodes should not be exposed to the load balancer.
stream        | Nodes that run an embedded deployment of Kafka and are exposed to the load balancer. Pega recommends that these node use the node classification “Stream” `nodetype`.

#### Small deployment with a single tier

To get started running a personal deployment of Pega on kubernetes, you can handle all processing on a single tier.  This configuration provides the most resource utilization efficiency when the characteristics of a production deployment are not necessary.  The [values-small.yaml](relative-link-here) configuration provides a starting point for this simple model.

Tier Name   | Description
---         | ---
pega        | One tier handles all foreground and background processing and is given a `nodeType` of "WebUser,BackgroundProcessing,search,Stream".

#### Large deployment for production isolation of processing

To run a larger scale Pega deployment in production, you can split additional processing out to dedicated tiers.  The [values-large.yaml](relative-link-here) configuration provides an example of a multi-tier deployment that Pega recommends as a good starting point for larger deployments.

Tier Name   | Description
---         | ---
web         | Interactive, foreground processing nodes that are exposed to the load balancer. Pega recommends that these node use the node classification “WebUser” `nodetype`.
batch       | Background processing nodes which handle some of the non-interactive processing.  Pega recommends that these node use the node classification   “BackgroundProcessing,Search,Batch” `nodetype`. These nodes should not be exposed to the load balancer.
stream      | Nodes that run an embedded deployment of Kafka and are exposed to the load balancer. Pega recommends that these node use the node classification “Stream” `nodetype`.
bix         | Nodes dedicated to BIX processing can be helpful when the BIX workload has unique deployment or scaling characteristics. Pega recommends that these node use the node classification “Bix” `nodetype`. These nodes should not be exposed to the load balancer.

### Name (*Required*)

Use the `tier` section in the helm chart to specify the name of each tier configuration in order to label a tier in your Kubernetes deployment.  This becomes the name of the tier's replica set in Kubernetes.

Example:

```yaml
name: "web"
```

### nodeType (*Required*)

Node classification is the process of separating nodes by purpose, predefining their behavior by assigning node types. When you associate a work resource with a specific node type,you optimize work performance in your Pega application. For more information, see
[Node classification](https://community.pega.com/sites/default/files/help_v83/procomhelpmain.htm#engine/node-classification/eng-node-classification-con.htm).

Specify the list of Pega node types for this deployment.  For more information about valid node types, see the Pega Community article on [Node Classification].

[Node types for client-managed cloud environments](http://doc-build02.rpega.com/docs-oxygen/procomhelpmain.htm#engine/node-classification/eng-node-types-client-managed-cloud-ref.htm)

Example:

```yaml
nodeType: ["WebUser","bix"]
```

### service (*Optional*)

Specify that the Kubernetes service block is expose to other Kubernetes run services, or externally to systems outside the environment.  The name of the service will be based on the tier's name, so if your tier is `"web"`, your service name will be `"pega-web"`.  If you omit `service`, no Kubenretes service object is created for the tier during the deployment. For more information on services, see the [Kubernetes Documentation](https://kubernetes.io/docs/concepts/services-networking/service/]).

Configuration parameters:

- `domain` - specify a domain on your network in which you create an ingress to the service.  If not specified, no ingress is created.

- `port` and `targetPort` - specify values other than the web node defaults of `80` and `8080`, respectively, if required for your networking domain. You can use these settings for external access to the stream tier when required.

- `alb_stickiness_lb_cookie_duration_seconds` - when deploying on Amazon EKS, configure alb cookie duration seconds equal to passivation time of requestors. By default this is `3660`, or just over one hour.

Example:

```yaml
service:
  domain: "tier.example.com"
  port: 1234
  targetPort: 1234
```


### Managing Resources

You can optionally configure the resource allocation and limits for a tier using the following parameters. The default value is used if you do not specify an alternative value. See [Managing Kubernetes Resources] for more information about how Kubernetes manages resources.

Parameter       | Description    | Default value
---             | ---       | ---
`replicas`      | Specify the number of Pods to deploy in the tier. | `1`
`cpuRequest`    | Initial CPU request for pods in the current tier.  | `200m`
`cpuLimit`      | CPU limit for pods in the current tier.  | `2`
`memRequest`    | Initial memory request for pods in the current tier. | `6Gi`
`memLimit`      | Memory limit for pods in the current tier. | `8Gi`
`initialHeap`   | This specifies the initial heap size of the JVM.  | `4096m`
`maxHeap`       | This specifies the maximum heap size of the JVM.  | `7168m`

### Using a Kubernetes Horizontal Pod Autoscaler (HPA)

You may configure an HPA to scale your tier on a specified metric.  Only tiers that do not use volume claims are scalable with an HPA. Set `hpa.enabled` to `true` in order to deploy an HPA for the tier. For more details, see the [Kubernetes HPA documentation](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/). 

Parameter           | Description    | Default value
---                 | ---       | ---
`hpa.minReplicas`   | Minimum number of replicas that HPA can scale-down | `1` 
`hpa.maxReplicas`   | Maximum number of replicas that HPA can scale-up  | `5`
`hpa.targetAverageCPUUtilization` | Threshold value for scaling based on initial CPU request utilization (The default value is `700` which corresponds to 700% of 200m ) | `700`
`hpa.targetAverageMemoryUtilization` | Threshold value for scaling based on initial memory utilization (The default value is `85` which corresponds to 85% of 6Gi ) | `85`

### Pega configuration files

While default configuration files are included by default, the Helm charts provide extension points to override them with additional customizations.  To change the configuration file, specify a relative path to a local implementation to be injected into a ConfigMap.

Parameter       | Description    | Default value
---             | ---       | ---
`prconfigPath`  | The location of a [prconfig.xml](config/deploy/prconfig.xml) template.  | `config/prconfig.xml`
`prlog4j2Path`  | The location of a [prlog4j2.xml](config/deploy/prlog4j2.xml) template.  | `config/prlog4j2.xml`

### Pega diagnostic user

While most cloud native deployments will take advantage of aggregated logging using a tool such as EFK, there may be a need to access the logs from Tomcat directly. In the event of a need to download the logs from tomcat, a username and password will be required.  You may set `pegaDiagnosticUser` and `pegaDiagnosticPassword` to set up authentication for Tomcat.

<!--
## Pega database installation and upgrades

Pega requires a relational database that stores the rules, data, and work objects used and generated by Pega Platform. The [Pega Platform deployment guide](https://community.pega.com/knowledgebase/products/platform/deploy) provides detailed information about the requirements and instructions for installations and upgrades.  Follow the instructions for Tomcat and your environment's database server.

The Helm charts also support an automated install or upgrade with a Kubernetes Job.  The Job utilizes an installation Docker image and can be activated with the `action` parameter in the Pega Helm chart.
 
### Install
 
For installations of the Pega platform, you must specify the installer Docker image and an initial default password for the `administrator@pega.com` user.

Example:

```yaml
installer:
  image: "YOUR_INSTALLER_IMAGE:TAG"
  adminPassword: "ADMIN_PASSWORD"
```

### Upgrade

For upgrades of the Pega platform, you must specify the installer Docker image and the type of upgrade to execute.

Upgrade type    | Description
---             | ---
`in-place`      | An in-place upgrade will upgrade both rules and data in a single run.  This will upgrade your environment as quickly as possible but will result in downtime.
`out-of-place`  | An out-of-place upgrade involves more steps to minimize downtime.  It will place the rules into a read-only state, then migrate the rules to a new schema. Next it will upgrade the rules to the new version. Lastly it will separately upgrade the data.

Example:

```yaml
installer:
  image: "YOUR_INSTALLER_IMAGE:TAG"
  upgrade:
    upgradeType: "out-of-place"
    targetRulesSchema: "rules_upgrade"
```
-->
## Cassandra and DDS deployment

If you are planning to use Cassandra (usually as a part of Pega Decisioning), you may either point to an existing deployment or deploy a new instance along with Pega. 

### Using an existing Cassandra deployment

To use an existing Cassandra deployment, set `cassandra.enabled` to `false` and configure the `dds` section to reference your deployment.

Example:

```yaml
cassandra:
  enabled: false

dds:
  externalNodes: "CASSANDRA_NODE_IPS"
  port: "9042"
  username: "cassandra_username"
  password: "cassandra_password"
```

### Deploying Cassandra with Pega

You may deploy a Cassandra instance along with Pega.  Cassandra is a seperate technology and needs to be independently managed.  When deploying Cassandra, set `cassandra.enabled` to `true` and leave the `dds` section as-is.  For more information about configuring Cassandra, see the [Cassandra Helm charts](https://github.com/helm/charts/blob/master/incubator/cassandra/values.yaml).

*Cassandra minimum resource requirements*

Deployment  | CPU     | Memory
---         | ---     | ---
Development | 2 cores | 4Gi
Production  | 4 cores | 8Gi

Example:

```yaml
cassandra:
  enabled: true
  # Set any additional Cassandra parameters. These values will be used by Cassandra's helm chart.
  persistence:
    enabled: true
  resources:
    requests:
      memory: "4Gi"
      cpu: 2
    limits:
      memory: "8Gi"
      cpu: 4

dds:
  externalNodes: ""
  port: "9042"
  username: "dnode_ext"
  password: "dnode_ext"
```

## Search deployment

Use the `pegasearch` section to configure a deployment of ElasticSearch for searching Rules and Work within Pega.  This deployment is used exclusively for Pega search, and is not the same ElasticSearch deployment used by the EFK stack or any other dedicated service such as Pega BI.

Set the `pegasearch.image` location to a registry that can access the Pega search Docker image. The image is [available on DockerHub](https://hub.docker.com/r/pegasystems/search), and you may choose to mirror it in a private Docker repository.

Example:

```yaml
pegasearch:
  image: "pegasystems/search:8.3"
```
