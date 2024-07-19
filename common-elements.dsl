workspace {

    !identifiers hierarchical 

    model {
        businessApp = softwareSystem "Bank Application" "Allows customers to view and manage information regarding their banking products." {
            properties {
                "owner" "DevOps Team"
                "criticality" "High"
            }

            webApplication = container "Web Application" "Allows customers to view and manage information regarding their banking products." "Java and Spring Boot" {
                tags "Application"
                properties {
                    "owner" "Frontend Team"
                    "repository" "https://github.com/example/businessApp-webapp"
                    "instanceType" "medium"
                    "region" "us-east"
                }
            }

            database = container "Database" "Stores information regarding the customer banking products." "Relational database schema" {
                tags "Database"
                properties {
                    "owner" "Database Team"
                    "dbVersion" "8.0"
                    "storageSize" "20GB"
                }
            }

            webApplication -> database "Reads from and writes to" "Database Protocol/SSL"
        }
    }

    views {
        systemContext businessApp {
            include *
            autolayout lr
        }

        container businessApp {
            include *
            autolayout lr
        }

        styles {
            element "Element" {
                shape roundedbox
                background #ffffff
            }
            element "Container" {
                background #ffffff
            }
            element "Application" {
                background #ffffff
            }
            element "Database" {
                shape cylinder
            }
        }

        themes https://static.structurizr.com/themes/amazon-web-services-2023.01.31/theme.json
        themes https://static.structurizr.com/themes/google-cloud-platform-v1.5/theme.json
        themes https://static.structurizr.com/themes/microsoft-azure-2023.01.24/theme.json
        themes https://static.structurizr.com/themes/kubernetes-v0.3/theme.json
    }
}
