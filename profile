"""Cluster profile of c6220 3 nodes
"""
 
hardware_type = "c6220"

node_count = 3

# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
import geni.rspec.pg as rspec
# Import the Emulab specific extensions.
import geni.rspec.emulab as emulab

# Create a portal object,
pc = portal.Context() 

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

ifaces = []

for i in range(node_count):
    node = request.RawPC("node-" + str(i))
    node.hardware_type = hardware_type
    node.installRootKeys(True, True)
    node.addService(rspec.Execute(shell="bash", command="cd /users/paulina && git clone https://github.com/PaulinaEster/charm"))
    node.addService(rspec.Execute(shell="bash", command="cd /users/paulina/charm && chmod +x ./setup.sh"))
    node.addService(rspec.Execute(shell="bash", command="cd /users/paulina/charm && ./setup.sh"))
    iface = node.addInterface("interface-" + str(i))
    ifaces.append(iface)

# Link link-1
link_1 = request.Link("link-1")
link_1.Site("undefined")

for iface in ifaces:
    link_1.addInterface(iface)

# Print the generated rspec
pc.printRequestRSpec(request)
