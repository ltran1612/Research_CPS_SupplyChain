import tkinter as tk
from tkinter import ttk

from ui.datamodels.base import DataModel
class AgentListModel(DataModel):
    def __init__(self) -> None:
        super().__init__()
        # subscribe the individual agent
        self.agents = dict() 
        self.cboxes = []
    
    def __contains__(self, agent: str):
        return agent in self.agents
    
    def __getitem__(self, agent: str):
        return self.agents[agent]

    def __setitem__(self, name: str, agent):
        self.agents[name] = agent 
        agent.subscribe(self)
        for box in self.cboxes:
            if box.winfo_exists() != 1:
                continue
            box.config(values=list(self.agents.keys())) 
    
    # TODO: update function
    def update(self, agent_name):
        for box in self.cboxes:
            if box.winfo_exists() != 1:
                continue
            # update the label combobox result if this agent selected in a combobox
            if box.get() != agent_name:
                continue
            # TODO: update

    # fill function, to be implemented by child classes
    def fill(self, frame):
        # Tab 2 content with multiple components
        def on_combobox_select(event):
            selected_value = combobox.get()
            label_combobox_result.config(text=self.agents[selected_value])

        # Create a label for the dropdown menu
        label_dropdown = tk.Label(frame, text="Choose an option:")
        label_dropdown.pack(pady=5)

        # Create a dropdown menu (combobox)
        options = list(self.agents.keys())
        combobox = ttk.Combobox(frame, values=options)
        combobox.pack(pady=5)
        combobox.bind("<<ComboboxSelected>>", on_combobox_select)
        # save combobox for updates 
        self.cboxes.append(combobox)

        # Create a label to display the selected value
        label_combobox_result = tk.Label(frame, text="Selected: None")
        label_combobox_result.pack(pady=5)

        # Create a button
        button_tab = tk.Button(frame, text="Click Me", command=lambda: label_button_result.config(text="Button clicked!"))
        button_tab.pack(pady=20)

        # Create a label to display the button click result
        label_button_result = tk.Label(frame, text="")
        label_button_result.pack(pady=5)