workspace {

    model {
        user = person "User" {
            description "A user interacting with the application"
            tags "Person"
            properties {
                "role" "End User"
                "accessLevel" "Public"
                "location" "Global"
            }
        }

        genericApp = softwareSystem "Generic Application" {
            description "A generic application with front end, back end, and database tiers"
            tags "System"
            properties {
                "businessOwner" "Product Team"
                "sla" "99.95%"
                "compliance" "GDPR, HIPAA"
                "repository" "https://github.com/company/generic-app"
            }
            
            frontEnd = container "Front End" {
                description "The front-end application, typically a web or mobile application"
                technology "Angular/React/Vue.js or similar"
                tags "Web Application"
                properties {
                    "scalability" "High"
                    "availability" "99.99%"
                    "repository" "https://github.com/company/generic-app-frontend"
                    "logging" "Enabled"
                    "monitoring" "App Insights"
                }
            }

            backEnd = container "Back End" {
                description "The back-end application providing APIs and business logic"
                technology "Node.js/Java/.NET or similar"
                tags "API Application"
                properties {
                    "scalability" "High"
                    "availability" "99.99%"
                    "repository" "https://github.com/company/generic-app-backend"
                    "logging" "Enabled"
                    "monitoring" "App Insights"
                }
            }

            database = container "Database" {
                description "The database storing application data"
                technology "SQL/NoSQL database"
                tags "Database"
                properties {
                    "scalability" "High"
                    "availability" "99.99%"
                    "encryption" "AES-256"
                    "backup" "Enabled"
                    "repository" "https://github.com/company/generic-app-database"
                    "compliance" "PCI-DSS"
                }
            }

            user -> frontEnd "Uses"
        }

        production = deploymentEnvironment "Production" {
            deploymentNode "Microsoft Azure" {
                tags "Microsoft Azure - Cloud"
                properties {
                    "owner" "Cloud Team"
                    "compliance" "ISO27001"
                    "costCenter" "Cloud Ops"
                }

                productionUser = deploymentNode "Production User" {
                    tags "Microsoft Azure - Browser"
                    description "A browser used to access the application"
                    properties {
                        "browserType" "Chrome/Firefox/Safari"
                        "location" "Global"
                    }
                }

                dns = deploymentNode "Recursive DNS" {
                    tags "Microsoft Azure - DNS Zones"
                    description "Handles DNS resolution for incoming requests."
                    properties {
                        "ttl" "60 seconds"
                        "provider" "Azure DNS"
                    }
                }
        
                subscription = deploymentNode "Microsoft Azure - Subscriptions" {
                    tags "Microsoft Azure - Subscriptions"
                    properties {
                        "subscriptionId" "1234-5678-9101-1121"
                        "billing" "Monthly"
                    }

                    region = deploymentNode "Microsoft Azure - Region" {
                        tags "Microsoft Azure - Regions"
                        properties {
                            "regionName" "East US"
                            "redundancy" "Geo-Redundant"
                        }

                        resourceGroup = deploymentNode "Microsoft Azure - Resource Groups" {
                            tags "Microsoft Azure - Resource Groups"
                            properties {
                                "resourceGroupName" "GenericApp-Prod-RG"
                                "owner" "Resource Team"
                            }

                            vnet = deploymentNode "Microsoft Azure - Virtual Network" {
                                tags "Microsoft Azure - Virtual Networks"
                                properties {
                                    "networkAdmin" "Network Team"
                                    "cidr" "10.0.0.0/16"
                                    "subnets" "Frontend, Backend, Database"
                                }

                                trafficManager = infrastructureNode "Azure Traffic Manager" {
                                    tags "Microsoft Azure - Traffic Manager Profiles"
                                    description "Uses DNS-based routing to load balance incoming traffic across the two regions."
                                    properties {
                                        "routingMethod" "Priority"
                                        "healthCheck" "Enabled"
                                    }
                                }

                                appGateway = infrastructureNode "Azure Application Gateway" {
                                    tags "Microsoft Azure - Application Gateways"
                                    description "Receives HTTP(S) traffic from the browser and inspects it using the Web Application Firewall."
                                    properties {
                                        "wafEnabled" "True"
                                        "sku" "Standard_v2"
                                    }
                                }

                                firewall = infrastructureNode "Azure Firewall Premium" {
                                    tags "Microsoft Azure - Firewalls"
                                    description "Intercepts traffic and applies TLS inspection for additional security."
                                    properties {
                                        "tlsInspection" "Enabled"
                                        "logging" "Enabled"
                                    }
                                }

                                frontendLoadBalancer = infrastructureNode "Microsoft Azure - Load Balancer (Front End)" {
                                    tags "Microsoft Azure - Load Balancers"
                                    properties {
                                        "algorithm" "Round Robin"
                                        "healthCheck" "Enabled"
                                    }
                                }

                                backendLoadBalancer = infrastructureNode "Microsoft Azure - Load Balancer (Back End)" {
                                    tags "Microsoft Azure - Load Balancers"
                                    properties {
                                        "algorithm" "Round Robin"
                                        "healthCheck" "Enabled"
                                    }
                                }

                                databaseLoadBalancer = infrastructureNode "Microsoft Azure - Load Balancer (Database)" {
                                    tags "Microsoft Azure - Load Balancers"
                                    properties {
                                        "algorithm" "Round Robin"
                                        "healthCheck" "Enabled"
                                    }
                                }

                                // Zone 1
                                availabilityZone1 = deploymentNode "Availability Zone 1" {
                                    tags "Microsoft Azure - Availability Zones"
                                    properties {
                                        "zoneId" "1"
                                        "redundancy" "Zonal"
                                    }

                                    subnet1 = deploymentNode "Microsoft Azure - Subnet 1" {
                                        tags "Microsoft Azure - Subnets"
                                        properties {
                                            "availabilityZone" "1"
                                            "subnetAddress" "10.0.1.0/24"
                                        }

                                        vmssFrontEnd1 = deploymentNode "Microsoft Azure - VM Scale Sets (Front End) 1" {
                                            tags "Microsoft Azure - VM Scale Sets"
                                            containerInstance frontEnd
                                            properties {
                                                "instanceType" "Standard_D2_v3"
                                                "scalingPolicy" "AutoScale"
                                            }
                                        }

                                        vmssBackEnd1 = deploymentNode "Microsoft Azure - VM Scale Sets (Back End) 1" {
                                            tags "Microsoft Azure - VM Scale Sets"
                                            containerInstance backEnd
                                            properties {
                                                "instanceType" "Standard_D2_v3"
                                                "scalingPolicy" "AutoScale"
                                            }
                                        }

                                        sqlDatabase1 = deploymentNode "Microsoft Azure - SQL Database 1" {
                                            tags "Microsoft Azure - Azure SQL"
                                            containerInstance database
                                            properties {
                                                "sku" "Standard"
                                                "backup" "Enabled"
                                                "encryption" "Enabled"
                                            }
                                        }
                                    }
                                }

                                // Zone 2
                                availabilityZone2 = deploymentNode "Availability Zone 2" {
                                    tags "Microsoft Azure - Availability Zones"
                                    properties {
                                        "zoneId" "2"
                                        "redundancy" "Zonal"
                                    }

                                    subnet2 = deploymentNode "Microsoft Azure - Subnet 2" {
                                        tags "Microsoft Azure - Subnets"
                                        properties {
                                            "availabilityZone" "2"
                                            "subnetAddress" "10.0.2.0/24"
                                        }

                                        vmssFrontEnd2 = deploymentNode "Microsoft Azure - VM Scale Sets (Front End) 2" {
                                            tags "Microsoft Azure - VM Scale Sets"
                                            containerInstance frontEnd
                                            properties {
                                                "instanceType" "Standard_D2_v3"
                                                "scalingPolicy" "AutoScale"
                                            }
                                        }

                                        vmssBackEnd2 = deploymentNode "Microsoft Azure - VM Scale Sets (Back End) 2" {
                                            tags "Microsoft Azure - VM Scale Sets"
                                            containerInstance backEnd
                                            properties {
                                                "instanceType" "Standard_D2_v3"
                                                "scalingPolicy" "AutoScale"
                                            }
                                        }

                                        sqlDatabase2 = deploymentNode "Microsoft Azure - SQL Database 2" {
                                            tags "Microsoft Azure - Azure SQL"
                                            containerInstance database
                                            properties {
                                                "sku" "Standard"
                                                "backup" "Enabled"
                                                "encryption" "Enabled"
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Relationships within the deployment environment
        productionUser -> dns "Initiates DNS resolution"
        dns -> trafficManager "Resolves DNS queries to"
        trafficManager -> appGateway "DNS-based routing"
        appGateway -> firewall "Routes traffic through"
        firewall -> frontendLoadBalancer "Sends inspected traffic to"
        frontendLoadBalancer -> vmssFrontEnd1 "Load balances to"
        frontendLoadBalancer -> vmssFrontEnd2 "Load balances to"
        vmssFrontEnd1 -> backendLoadBalancer "Sends requests to"
        vmssFrontEnd2 -> backendLoadBalancer "Sends requests to"
        backendLoadBalancer -> vmssBackEnd1 "Load balances to"
        backendLoadBalancer -> vmssBackEnd2 "Load balances to"
        vmssBackEnd1 -> databaseLoadBalancer "Sends requests to"
        vmssBackEnd2 -> databaseLoadBalancer "Sends requests to"
        databaseLoadBalancer -> sqlDatabase1 "Load balances to"
        databaseLoadBalancer -> sqlDatabase2 "Load balances to"
    }

    views {
        systemContext genericApp {
            include *
            properties {
                "viewOwner" "System Architect"
                "documentation" "https://confluence.company.com/display/genericapp/System+Context+Diagram"
            }
        }

        container genericApp {
            include *
            properties {
                "viewOwner" "System Architect"
                "documentation" "https://confluence.company.com/display/genericapp/Container+Diagram"
            }
        }

        deployment genericApp "Production" {
            include *
            properties {
                "viewOwner" "DevOps Team"
                "documentation" "https://confluence.company.com/display/genericapp/Production+Deployment+Diagram"
            }
        }

        theme "https://static.structurizr.com/themes/microsoft-azure-2023.01.24/theme.json"
    }
}
