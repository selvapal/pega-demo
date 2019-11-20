############################################S T A R T- I N P U T - P A R A M E T E R S################################################
#------------------------------------------------------------------------------
# cluster parameters. The VPC  and RDS will be created with the cluster name
#------------------------------------------------------------------------------
region                          = "us-west-2"
vpc_subnet                      = "172.16.0.0/16"
azs                             = ["us-west-2a", "us-west-2b"]
public_subnets                  = ["172.16.0.0/20", "172.16.16.0/20"]
tags                            = { "Environment" = "Development" }
worker_groups                   = [
    {
        "instance_type"         = "m4.xlarge"
        "asg_desired_capacity"  = "5",
        "asg_min_size"          = "5",
        "asg_max_size"          = "7",
        "key_name"              = "pega-kp"

    }]
#------------------------
# database parameters
#------------------------
rds_name                        = "dev"
rds_port                        = "5432"
rds_storage_type                = "gp2"
rds_allocated_storage           = "50"
rds_engine                      = "postgres"
rds_engine_version              = "9.6.10"
rds_instance_class              = "db.m4.xlarge"
rds_username                    = "postgres"
rds_password                    = "postgres"
rds_parameter_group_family      = "postgres9.6"

###########################################E N D - I N P U T - P A R A M E T E R S####################################################
