workspace extends common-elements.dsl {
    model {
        production = deploymentEnvironment "Production" {
            !include infrastructure-elements.dsl
        }
    }

    views {
        deployment businessApp "Production" "GenericInfrastructureDeployment" {
            include *

            animation {
                dns
                cdn
                loadBalancer
                publicSubnet
                privateSubnet
                webApplicationPod
                primaryDatabase
                readReplica
                databaseInstance
                objectStorage
                cache
                messageQueue
                notificationService
                monitoring
                identityAccessManagement
                natGateway
                ipScheme
            }
        }
    }
}
