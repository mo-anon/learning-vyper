how to compile:

ape compile -> compiles all contracts in ../contracts/

deploying in console:
acc = accounts[0]  
acc.balance += int(10e18)  
x = acc.deploy(project.{name})  