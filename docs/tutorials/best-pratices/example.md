# Example Tagging Strategies

 - **Cost Center**: You can use a tag to indicate the cost center responsible for the resource. This facilitates cost attribution to specific entities within your organization.
- **Business Unit**: If your organization is divided into distinct business units, you can use a tag to identify the business unit to which the resource belongs. This provides better visibility into costs associated with each business unit.
- Environment: If you have multiple environments (e.g., development, test, production), you can use a tag to indicate the environment to which the resource belongs. This can help track costs by environment and identify optimization opportunities specific to each environment.
- **Project**: If you allocate resources to specific projects, you can use a tag to indicate the corresponding project. This facilitates cost tracking by project and evaluation of project profitability.


## Environment

If you have multiple environments, you can use a tag to indicate the environment to which the resource belongs. This can help track costs by environment and identify optimization opportunities specific to each environment.

development, test, production

|  Key            |       Value     |
|:---------------:|:---------------:|
| Env             | development     |
| Environment     | test            |
|                 | production      |

## Project

If you allocate resources to specific projects, you can use a tag to indicate the corresponding project. This facilitates cost tracking by project and evaluation of project profitability.

|  Key            |       Value     |
|:---------------:|:---------------:|
| Projet          | yriser          |

## Owner

You can use a tag to indicate the owner or person responsible for the resource. This facilitates communication and cost accountability.

|  Key            |       Value     |
|:---------------:|:---------------:|
| Owner           | devops          |
|                 | Jane Doe        |

## Resource Type

You can use a tag to indicate the type of resource, such as database, EC2 instance, managed service, etc. This allows grouping costs by resource type and better understanding of cost distribution.

|  Key            |       Value     |
|:---------------:|:---------------:|
| Resource        | ec2             |
|                 | s3              |

## Business Unit

Cost allocatable to teams within an enterprise. This model requires a moderate amount of effort, provides high accuracy for showbacks and chargebacks, and is suitable for organizations that have a defined account structure

|  Key            | 	  Value     |
|:---------------:|:---------------:|
| Business Unit   | prod            |
|                 | staging         |
|                 | test            |
|                 | dev             |
|                 | sandbox         |

## Team-based

Cost allocatable to teams or organizations within an enterprise. This model requires a moderate amount of effort, provides high accuracy for showbacks and chargebacks, and is suitable for organizations that have a defined account structure

|  Key            |       Value     |
|:---------------:|:---------------:|
| Team            | ops-center      |
|                 | dev-ops         |
|                 | app-team        |
|                 | bi-team         |
|                 | logistics       |
|                 | security        |

## Creation Date

By adding a tag with the resource's creation date, you can track the lifespan of resources and assess their cost impact over time.

|  Key            |       Value     |
|:---------------:|:---------------:|
| Date            | 06.07.2023      |
