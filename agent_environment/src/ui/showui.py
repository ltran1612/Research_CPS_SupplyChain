import tkinter as tk
from tkinter import ttk

from ui.datamodels.agents import AgentListModel
from ui.datamodels.base import DataModel
from ui.datamodels.time_md import TimeModel
from ui.tabs.overview import fill as fillOverview
from ui.tabs.settings import fill as fillSettings


def start_ui(agents: AgentListModel, concerns: DataModel, time: TimeModel):
    # Create the main application window
    root = tk.Tk()
    root.title("Supply Chain Simulator")

    # top section
    top_frame = tk.Frame(root)
    top_frame.pack(side="top", fill="x")

    # Create buttons and pack them into the top frame
    backButton= tk.Button(top_frame, text="Back")
    backButton.pack(side="left", padx=5, pady=5)

    # label
    time.fill(top_frame)

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
    agents.fill(tab2)

    # Tab 3 content
    concerns.fill(tab3)

    # Tab 4 content
    fillSettings(tab4)

    # Start the Tkinter event loop
    root.mainloop()
