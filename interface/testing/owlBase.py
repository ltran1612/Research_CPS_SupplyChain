
import networkx as nx
import numpy as np
import matplotlib.pyplot as plt
from owlNode import owlNode
from owlFunctions import remove_namespace
from owlready2 import *
from networkx.drawing.nx_agraph import write_dot, graphviz_layout
from owlFunctions import is_asp_or_conc

class owlBase:

    def __init__(self,filename):

        self.owlReadyOntology = None
        self.owlName = None
        self.nodeArray = None
        self.concernArray = None
        self.owlApplication = None

        self.numNodes = None
        self.numAspects = None
        self.numConcerns = None

        self.numComponents = None
        self.numConditions = None
        self.numImpactRules = None

        self.allConcerns_owlNode = None



        self.owlGraph = None
        self.graphPositions = None

        self.aspectConcernArray = None

        self.subconcernEdges = None


        self.concernEdgeLabels = None


        self.aspectNodeLabels = None
        self.concernNodeLabels = None



        self.minX = None
        self.maxX = None
        self.minY = None
        self.maxY = None
        self.totalX = None
        self.totalY = None

        self.initializeOwlOntology(filename)



    def initializeOwlOntology(self,filename):

        self.loadOwlFile(filename)



        #self.setNumbers()

    def initializeOwlNodes(self):

        self.addOwlNodes()
        self.assignChildren()
        self.assignParentsFromChildren()



    def loadOwlFile(self,filename):

        #self.owlReadyOntology = get_ontology("file://./../../src/asklab/querypicker/QUERIES/BASE/" + filename).load()
        self.owlReadyOntology = get_ontology("file://./" + filename).load()
        self.owlName = str(filename)




    def setNumbers(self):

        #print("called set numbers")
        self.numAspects =  len(self.owlReadyOntology.search(type = self.owlReadyOntology.Aspect))
        self.numConcerns =  len(self.owlReadyOntology.search(type = self.owlReadyOntology.Concern))

        self.numNodes = self.numAspects + self.numConcerns

        #self.printNumbers()

    def findNode(self,name):

        for node in self.allConcerns_owlNode:

            if(node.name == name):

                return node

        print("couldn't find " + str(name))
        return 0

    def addOwlNodes(self):

        self.allConcerns_owlNode = []
        all_concerns = np.asarray(self.owlReadyOntology.search(type = self.owlReadyOntology.Concern))

        for concern in all_concerns:

        
            newOwlNode = owlNode()
            newOwlNode.name = remove_namespace(concern)
            newOwlNode.type = remove_namespace(concern.is_a[0])
            newOwlNode.children = []
            newOwlNode.parents = []
            newOwlNode.owlreadyObj = concern

            self.allConcerns_owlNode.append(newOwlNode)

    def assignChildren(self):

        for node in self.allConcerns_owlNode:

            children_list = node.owlreadyObj.includesConcern

            for child in children_list:

                node.children.append(self.getOwlNode(remove_namespace(child)))

    def assignParentsFromChildren(self):

        for node in self.allConcerns_owlNode:

            for child in node.children:

                child.parents.append(node)




    def getOwlNode(self,name):

        for node in self.allConcerns_owlNode:

            if(node.name == name):

                return node

        if(self.owlApplication != None):

            for node in self.owlApplication.nodeArray:

                if(node.name == name):

                    return node



        return 0


    def addNewConcern(self,new_name,clicked_name):

        #instantiate the object with the given new name
        new_concern = self.owlReadyOntology.Concern(new_name,ontology = self.owlReadyOntology)

        #add the new concern as a subconcern of the clicked node
        subconcern_of_owlNode = self.getOwlNode(clicked_name)

        subconcern_of_owlreadyNode = subconcern_of_owlNode.owlreadyObj

        subconcern_of_owlreadyNode.includesConcern.append(new_concern)
        
    def addNewRLConcern(self,new_name):
        
        new_concern = self.owlReadyOntology.Concern(new_name,ontology = self.owlReadyOntology)

    def addNewSubConcernRelation(self,parent,child):


        if(is_asp_or_conc(parent.type) == False or is_asp_or_conc(child.type) == False):
            print("Either parent or child is not a concern")
            return


        parent.owlreadyObj.includesConcern.append(child.owlreadyObj)

    def addConcernAsParent(self,new_name,clicked_name):

        #instantiate new concern
        new_parent_concern = self.owlReadyOntology.Concern(new_name,ontology = self.owlReadyOntology)

        #get owlready object of selected node
        parent_of = self.getOwlNode(clicked_name)

        #sets up parent relation
        new_parent_concern.includesConcern.append(parent_of.owlreadyObj)


    def removeSubConcernRelation(self,parent,child):

         if(is_asp_or_conc(child.type) == False or is_asp_or_conc(parent.type) == False):
            print("One node is not a concern")
            return

         print("removing relation between " + parent.name + " and " + child.name)

         parent.owlreadyObj.includesConcern.remove(child.owlreadyObj)

    def addNewAspect(self,new_name):

        new_aspect = self.owlReadyOntology.Aspect(new_name,ontology = self.owlReadyOntology)


    def editName(self,current_obj,new_name):

        current_obj.owlreadyObj.name = new_name

    def removeConcern(self,to_remove):

        destroy_entity(to_remove.owlreadyObj)




    def removeRelationless(self):

        for node in self.allConcerns_owlNode:

            if(len(node.parents) == 0 and len(node.children) == 0 and node.type != "Aspect"):

                print("trying to remove " + node.name)
                to_remove = self.owlReadyOntology.ontology.search(iri = "*" + node.name)

                names = []

                for subc in to_remove:
                    names.append(remove_namespace(subc))

                i = 0

                while i < len(names):

                    if(names[i] == node.name):
                        break

                    i = i + 1
                to_remove = to_remove[i]

                destroy_entity(to_remove)


    def findRelationless(self,parent,relationless):

        if(len(parent.children) == 0):
            return


        for child in parent.children:

            if(len(child.parents) == 1 and child.parents[0] == parent ):

                relationless.append(child)

            self.findRelationless(child,relationless)

    def findChildren(self,parent,all_children):

        if(len(parent.children) == 0):
            return

        for child in parent.children:

            all_children.append(child)

            self.findChildren(child,all_children)



    def getRelationless(self,parent):

        relationless = []


        self.findRelationless(parent,relationless)

        return relationless


    def getChildren(self,parent):

        all_children = []

        self.findChildren(parent,all_children)

        return all_children
















#testOwlOntology = owlBase("cpsframework-v3-base.owl")

#testOwlOntology.initializeOwlNodes()


#for i in range (len(testOwlOntology.allConcerns_owlNode)):
 #   print(i)
 #   print(testOwlOntology.allConcerns_owlNode[i].name)

#print(testOwlOntology.allConcerns_owlNode[83].name)
#r = testOwlOntology.getChildren(testOwlOntology.allConcerns_owlNode[83])


#for x in r:

#    print(x.name)
#print(testOwlOntology.getRelationless(testOwlOntology.allConcerns_owlNode[30]))

#for node in testOwlOntology.allConcerns_owlNode:

 #   print(node.name)
 #   for parent in node.parents:
 #       print(parent.name)

 #   print()
#print("done\n\n")

#    print(node.name + " " + node.type + " parent = " + node.parent + " children = " + str(node.children) + " level = " + str(node.level))




#fig, ax = plt.subplots(figsize = (10,10))
#testOwlOntology.makeGraph()

#testOwlOntology.draw_graph(ax,8)

#print(testOwlOntology.aspectConcernArray)

#print(testOwlOntology.propertyArray)

#print(testOwlOntology.subconcernEdges)
#print(testOwlOntology.propertyEdges)

#print(testOwlOntology.owlIndividualArray)

#testOwlOntology.printNumbers()
