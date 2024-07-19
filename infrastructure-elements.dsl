deploymentNode "Cloud Provider" {
    tags "Cloud"
    properties {
        "owner" "Cloud Team"
    }

    region = deploymentNode "Region" {
        tags "Region"

        ipScheme = deploymentNode "Network" {
            tags "ipScheme"
            properties {
                "networkAdmin" "Network Team"
                "cidr" "10.0.0.0/16"
            }

            publicSubnet = deploymentNode "Public Subnet" "10.0.0.0/24" {
                tags "Subnet"
                properties {
                    "availabilityZone" "us-east-multiple"
                }

                loadBalancer = infrastructureNode "Load Balancer" "Automatically distributes incoming application traffic." {
                    tags "Load Balancer"
                    properties {
                        "owner" "Networking Team"
                        "scheme" "internet-facing"
                    }
                }

                natGateway = infrastructureNode "NAT Gateway" "Enables instances in a private subnet to connect to the internet." {
                    tags "NAT Gateway"
                    properties {
                        "owner" "Networking Team"
                    }
                }

                dns = infrastructureNode "DNS" "Highly available and scalable cloud DNS service." {
                    tags "DNS"
                    properties {
                        "owner" "Networking Team"
                    }
                }

                cdn = infrastructureNode "CDN" "Content Delivery Network to cache static assets." {
                    tags "CDN"
                    properties {
                        "owner" "Networking Team"
                        "distributionId" "E12345678"
                    }
                }

                objectStorage = infrastructureNode "Object Storage" "Object storage for static content." {
                    tags "Object Storage"
                    properties {
                        "owner" "Storage Team"
                        "bucketName" "businessApp-assets"
                    }
                }
            }

            privateSubnet = deploymentNode "Private Subnet" "10.0.1.0/24" {
                tags "Subnet"
                properties {
                    "availabilityZone" "us-east-1b"
                }

                kubernetes = deploymentNode "Kubernetes Service" {
                    tags "Kubernetes Service"

                    kubernetesCluster = deploymentNode "Kubernetes Cluster" {
                        tags "Kubernetes Cluster"

                        kubernetesNodeGroup = deploymentNode "Kubernetes Node Group" {
                            tags "Kubernetes Node Group"

                            webApplicationPod = containerInstance businessApp.webApplication
                        }
                    }
                }

                relationalDatabase = deploymentNode "Relational Database Service" {
                    tags "Relational Database Service"

                    primaryDatabase = deploymentNode "Primary Database" {
                        tags "Primary Database Instance"

                        databaseInstance = containerInstance businessApp.database
                    }

                    readReplica = deploymentNode "Read Replica" {
                        tags "Read Replica"
                        properties {
                            "replicaCount" "2"
                        }
                    }
                }

                cache = infrastructureNode "Cache" "In-memory data store and cache service." {
                    tags "Cache"
                    properties {
                        "nodeType" "medium"
                    }
                }

                messageQueue = infrastructureNode "Message Queue" "Message queuing service." {
                    tags "Message Queue"
                    properties {
                        "queueName" "businessApp-queue"
                    }
                }

                notificationService = infrastructureNode "Notification Service" "Notification service." {
                    tags "Notification Service"
                    properties {
                        "topicName" "businessApp-topic"
                    }
                }

                monitoring = infrastructureNode "Monitoring" "Monitoring and logging service." {
                    tags "Monitoring"
                }

                identityAccessManagement = infrastructureNode "Identity and Access Management" "Identity and Access Management service." {
                    tags "Identity and Access Management"
                }
            }

            dns -> cdn "Forwards requests to" "HTTPS"
            cdn -> loadBalancer "Forwards requests to" "HTTPS"
            loadBalancer -> webApplicationPod "Forwards requests to" "HTTPS"
            webApplicationPod -> monitoring "Sends logs to"
            objectStorage -> cdn "Serves static content via"
            webApplicationPod -> messageQueue "Sends messages to"
            messageQueue -> webApplicationPod "Receives messages from"
            notificationService -> webApplicationPod "Sends notifications to"
            webApplicationPod -> notificationService "Receives notifications from"
            webApplicationPod -> cache "Fetches from and stores to"
            primaryDatabase -> readReplica "Replicates data to"
            kubernetesNodeGroup -> natGateway "Accesses the internet via"
            webApplicationPod -> identityAccessManagement "Uses roles and policies from"
            primaryDatabase -> identityAccessManagement "Uses roles and policies from"
        }
    }
}
