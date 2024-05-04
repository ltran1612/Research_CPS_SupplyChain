# Hybrid Ontology Clingo CLI

This is the branch where the codes to build a CLI for the Hybrid-Ontology ASP Reasoner is at. This is a stripped down version of the program in the original repo and was converted into a CLI. 

The CLI requires the following 2 things to be available in the shell:
1) Apache Jena: "sparql" command is needed in the shell. 
2) Clingo: "clingo" command is needed in the shell.

The location of the related files are:
1) entry point (main function): src/cli/Main.java
2) the object that represents the hybrid reasoner: src/asklab/cpsf/CPSClingoReasoner.java
