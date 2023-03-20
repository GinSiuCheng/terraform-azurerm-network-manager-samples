# 300-multi-region-hubspoke-mesh
In the traditional [hub-spoke network pattern](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?tabs=cli)(without virtual WAN), customers tend to deploy this across multiple regions and have global meshes for apps, shared services and core services. The following sample deploys this hub-spoke and mesh patterns across multiple regions (east us 2, west us 2, east us and west us). 

## VNETs created: 
The following are VNETs created as part of the sample. Each VNET consists of a default subnet with a test VM to demonstrate connectivity over ICMP. Hub VNETs contain 2 additional subnets for Azure Firewall and Azure Bastion. 
- Hub VNETs: local region hubs, where express route provides connectivity back to on-premise and also connectivity to other spokes
- Shared VNETs: shared service VNETs that apps may depend on
- Core VNETs: core service VNETs that all resources may depend on 
- App 1 / App 2 VNETs: application VNETs 

## Network groups: 
The following are network groups created: 

### Static network groups
- Hub static network group - all hub VNETs in all region
- Shared static network group - all shared VNETs in all region
- Core static network group - all core VNETs in all region
- App 1 static network group - all app 1 VNETs in all region
- App 2 static network group - all app 2 VNETs in all region

### Dynamic network groups 
- Apps dynamic network group - all app VNETs in all region
- East us 2 dynamic network group - all spokes in east 2 region, except for hub
- West us 2 dynamic network group - all spokes in west 2 region, except for hub
- East us dynamic network group - all spokes in east region, except for hub
- West us 2 dynamic network group - all spokes in west region, except for hub

## Network manager connectivity configurations: 
The following are connectivity configurations created: 
- Regional Hub VNET hub-spoke config (x4):
    - Function: Allow connectivity from regional spokes to ExR via Hub or to Azure FW for egress
    - Hub: regional hub VNET
    - Spokes: regional spokes (app, shared, core)

- Multi-region Core VNET hub-spoke config (x4): 
    - Function: Allow connectivity from app VNETs across regions to talk to core VNETs
    - Hub: regional core VNET
    - Spokes: Multi-region App VNETs

- Multi-region Shared VNET hub-spoke config (x4): 
    - Function: Allow connectivity from app VNETs across regions to talk to shared VNEts
    - Hub: regional shared VNET
    - Spokes: Multi-region App VNETs

- Global Hub VNETs mesh config: 
    - Function: Allow connectivity between Hub VNETs
    - Network group: hub static network group

- Global Shared VNETs mesh config: 
    - Function: Allow connectivity between Shared VNETs
    - Network group: shared static network group

- Global Core VNETs mesh config: 
    - Function: Allow connectivity between Core VNETs
    - Network group: core static network group

- Global App1/App2 VNETs mesh config: 
    - Function: Allow connectivity between respective App VNETs
    - Network group: app1 static network group

## Terraform deployment 
- Rename terraform.tfvars.sample to terraform.tfvars
- Ensure you are logged into your azure cli and have the right subscription set (az account set --subscription "sub id")
- Ensure that you have the right permissions to create all resources (ex. permissive permission would be contributor on the subscription)
- Run terraform plan and terraform apply  