import tkinter as tk
from tkinter import ttk

from tabs.agents import fill as fillAgents
from tabs.overview import fill as fillOverview
from tabs.ontology import fill as fillOntology
from tabs.settings import fill as fillSettings

# Create the main application window
root = tk.Tk()
root.title("Tkinter Tabs Example")

# Create a Notebook widget for tabbed views
notebook = ttk.Notebook(root)

# Create frames for each tab
tab1 = ttk.Frame(notebook)
tab2 = ttk.Frame(notebook)
tab3 = ttk.Frame(notebook)
tab4 = ttk.Frame(notebook)

# Add frames to the notebook
notebook.add(tab1, text="Overview")
notebook.add(tab2, text="Agent")
notebook.add(tab3, text="Ontology")
notebook.add(tab4, text="Settings")

# Pack the notebook widget to fill the main window
notebook.pack(expand=True, fill='both')

# ontology tab
fillOverview(tab1)

# agents tab
fillAgents(tab2)

# Tab 3 content
fillOntology(tab3)

# Tab 4 content
fillSettings(tab4)

# Start the Tkinter event loop
root.mainloop()
