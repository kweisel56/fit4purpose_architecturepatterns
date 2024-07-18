workspace {

    model {
        browser = person "Browser" {
            description "A browser used to access the application"
            tags "Microsoft Azure - Browser"
        }

        genericApp = softwareSystem "Generic Application" {
            description "A generic application with front end, back end, and database tiers"
            tags "System"
            
            frontEnd = container "Front End" {
                description "The front-end application, typically a web or mobile application"
                technology "Angular/React/Vue.js or similar"
                tags "Web Application"
            }

            backEnd = container "Back End" {
                description "The back-end application providing APIs and business logic"
                technology "Node.js/Java/.NET or similar"
                tags "API Application"
            }

            database = container "Database" {
                description "The database storing application data"
                technology "SQL/NoSQL database"
                tags "Database"
            }

            browser -> frontEnd "Uses"
        }

        production = deploymentEnvironment "Production" {
            deploymentNode "Microsoft Azure" {
                tags "Microsoft Azure - Cloud"
                properties {
                    "owner" "Cloud Team"
                }

                subscription = deploymentNode "Microsoft Azure - Subscriptions" {
                    tags "Microsoft Azure - Subscriptions"

                    region = deploymentNode "Microsoft Azure - Region" {
                        tags "Microsoft Azure - Region"

                        resourceGroup = deploymentNode "Microsoft Azure - Resource Groups" {
                            tags "Microsoft Azure - Resource Groups"

                            vnet = deploymentNode "Microsoft Azure - Virtual Network" {
                                tags "Microsoft Azure - Virtual Networks"
                                properties {
                                    "networkAdmin" "Network Team"
                                    "cidr" "10.0.0.0/16"
                                }

                                dns = infrastructureNode "Recursive DNS" {
                                    tags "Microsoft Azure - DNS Zones"
                                    description "Handles DNS resolution for incoming requests."
                                }

                                trafficManager = infrastructureNode "Azure Traffic Manager" {
                                    tags "Microsoft Azure - Traffic Manager Profiles"
                                    description "Uses DNS-based routing to load balance incoming traffic across the two regions."
                                }

                                appGateway = infrastructureNode "Azure Application Gateway" {
                                    tags "Microsoft Azure - Application Gateways"
                                    description "Receives HTTP(S) traffic from the browser and inspects it using the Web Application Firewall."
                                }

                                firewall = infrastructureNode "Azure Firewall Premium" {
                                    tags "Microsoft Azure - Firewalls"
                                    description "Intercepts traffic and applies TLS inspection for additional security."
                                }

                                frontendLoadBalancer = infrastructureNode "Microsoft Azure - Load Balancer (Front End)" {
                                    tags "Microsoft Azure - Load Balancers"
                                }

                                backendLoadBalancer = infrastructureNode "Microsoft Azure - Load Balancer (Back End)" {
                                    tags "Microsoft Azure - Load Balancers"
                                }

                                databaseLoadBalancer = infrastructureNode "Microsoft Azure - Load Balancer (Database)" {
                                    tags "Microsoft Azure - Load Balancers"
                                }

                                // Zone 1
                                availabilityZone1 = deploymentNode "Availability Zone 1" {
                                    tags "Microsoft Azure - Availability Zones"

                                    subnet1 = deploymentNode "Microsoft Azure - Subnet 1" {
                                        tags "Microsoft Azure - Subnets"
                                        properties {
                                            "availabilityZone" "1"
                                        }

                                        vmssFrontEnd1 = deploymentNode "Microsoft Azure - VM Scale Sets (Front End) 1" {
                                            tags "Microsoft Azure - VM Scale Sets"
                                            containerInstance frontEnd
                                        }

                                        vmssBackEnd1 = deploymentNode "Microsoft Azure - VM Scale Sets (Back End) 1" {
                                            tags "Microsoft Azure - VM Scale Sets"
                                            containerInstance backEnd
                                        }

                                        sqlDatabase1 = deploymentNode "Microsoft Azure - SQL Database 1" {
                                            tags "Microsoft Azure - SQL Database"
                                            containerInstance database
                                        }
                                    }
                                }

                                // Zone 2
                                availabilityZone2 = deploymentNode "Availability Zone 2" {
                                    tags "Microsoft Azure - Availability Zones"

                                    subnet2 = deploymentNode "Microsoft Azure - Subnet 2" {
                                        tags "Microsoft Azure - Subnets"
                                        properties {
                                            "availabilityZone" "2"
                                        }

                                        vmssFrontEnd2 = deploymentNode "Microsoft Azure - VM Scale Sets (Front End) 2" {
                                            tags "Microsoft Azure - VM Scale Sets"
                                            containerInstance frontEnd
                                        }

                                        vmssBackEnd2 = deploymentNode "Microsoft Azure - VM Scale Sets (Back End) 2" {
                                            tags "Microsoft Azure - VM Scale Sets"
                                            containerInstance backEnd
                                        }

                                        sqlDatabase2 = deploymentNode "Microsoft Azure - SQL Database 2" {
                                            tags "Microsoft Azure - SQL Database"
                                            containerInstance database
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
        }

        container genericApp {
            include *
        }

        deployment genericApp "Production" {
            include *
        }

        theme "https://static.structurizr.com/themes/microsoft-azure-2023.01.24/theme.json"
    }
}
