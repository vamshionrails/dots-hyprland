```
from aws_cdk import (
    Stack,
    aws_ec2 as ec2,
    aws_eks as eks,
    aws_iam as iam
)
from constructs import Construct

class EksClusterStack(Stack):

    def __init__(self, scope: Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        # Call the VPC function to get the VPC object
        vpc = self.get_vpc()

        # Create EKS Cluster
        cluster = eks.Cluster(self, "EKSCluster",
            cluster_name="cluster-24",
            vpc=vpc,
            default_capacity=0,  # We will define node groups manually
            version=eks.KubernetesVersion.V1_29  # Adjust according to your Kubernetes version
        )

        # IAM policy for Cluster Autoscaler
        autoscaler_policy = iam.PolicyStatement(
            effect=iam.Effect.ALLOW,
            actions=[
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            resources=["*"]
        )

        # Define Managed Node Group ng-1 (Public Subnets with Auto-scaling)
        ng1 = cluster.add_nodegroup_capacity("ng-1",
            nodegroup_name="ng-1",
            instance_types=[ec2.InstanceType("m5.xlarge")],
            desired_size=2,
            min_size=2,
            max_size=5,  # Enables auto-scaling to a maximum of 5 nodes
            capacity_type=eks.CapacityType.ON_DEMAND,  # Optional: Choose ON_DEMAND or SPOT instances
            subnets=ec2.SubnetSelection(subnets=self.get_public_subnets(vpc))  # Attach public subnets
        )

        # Attach autoscaler policy to the node group role
        ng1.role.add_to_policy(autoscaler_policy)

        # Define Managed Node Group ng-2 (Private Subnets with Auto-scaling and private networking)
        ng2 = cluster.add_nodegroup_capacity("ng-2",
            nodegroup_name="ng-2",
            instance_types=[ec2.InstanceType("m5.xlarge")],
            desired_size=2,
            min_size=2,
            max_size=5,  # Enables auto-scaling to a maximum of 5 nodes
            capacity_type=eks.CapacityType.ON_DEMAND,
            subnets=ec2.SubnetSelection(subnets=self.get_private_subnets(vpc)),  # Attach private subnets
            private_networking=True  # Enable private networking
        )

        # Attach autoscaler policy to the node group role
        ng2.role.add_to_policy(autoscaler_policy)

    def get_vpc(self) -> ec2.IVpc:
        """
        Function to return an imported VPC from existing attributes
        """
        return ec2.Vpc.from_vpc_attributes(self, "ExistingVPC",
            vpc_id="vpc-0c24b1cc77da8f463",
            availability_zones=["us-west-2a", "us-west-2b", "us-west-2c"],
            public_subnet_ids=[
                "subnet-0324095a4f2188967",
                "subnet-083814b087bad140b",
                "subnet-03a1260affe6f9944"
            ],
            private_subnet_ids=[
                "subnet-00110ffa3ef259d0c",
                "subnet-0a96e24163ef2c9c3"
            ]
        )

    def get_public_subnets(self, vpc: ec2.IVpc) -> list[ec2.ISubnet]:
        """
        Function to return a list of public subnets based on IDs
        """
        return [
            ec2.Subnet.from_subnet_id(self, "PublicSubnet1", "subnet-0324095a4f2188967"),
            ec2.Subnet.from_subnet_id(self, "PublicSubnet2", "subnet-083814b087bad140b"),
            ec2.Subnet.from_subnet_id(self, "PublicSubnet3", "subnet-03a1260affe6f9944")
        ]

    def get_private_subnets(self, vpc: ec2.IVpc) -> list[ec2.ISubnet]:
        """
        Function to return a list of private subnets based on IDs
        """
        return [
            ec2.Subnet.from_subnet_id(self, "PrivateSubnet1", "subnet-00110ffa3ef259d0c"),
            ec2.Subnet.from_subnet_id(self, "PrivateSubnet2", "subnet-0a96e24163ef2c9c3")
        ]
```
