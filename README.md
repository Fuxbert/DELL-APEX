## Experimental repository to demonstrate digital services on Platform Equinix

This repo will bring up bare metal instance(s) and connect it to a Dell APEX instance
using Equinix Fabric Virtual Connections via Service Tokens on A- and Z-Side. This 
will not require any dedicated Fabric Ports.

Note this is not meant as a best-practices for security as it's not including HA / failover config

The userdata template is based on very basic Ubuntu networking requirements to set static routes 
towards the primary / secondary Dell APEX iSCSI targets. Amend to your actual OS / requirements
