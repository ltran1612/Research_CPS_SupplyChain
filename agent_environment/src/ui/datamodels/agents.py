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
        # updated
        for box in self.cboxes:
            if box.winfo_exists() != 1:
                continue
            box.config(values=list(self.agents.keys())) 
    
    # update function when the publisher publishes something
    # in this case, it's the individual agent in the list
    def update(self, agent_name):
        for box in self.cboxes:
            if box.winfo_exists() != 1:
                continue
            # update the label combobox result if this agent selected in a combobox
            if box.get() != agent_name:
                continue
            box.event_generate("<<ComboboxSelected>>")

    # fill function, to be implemented by child classes
    def fill(self, frame):
        # Tab 2 content with multiple components
        def on_combobox_select(event):
            selected_value = combobox.get()

            label_combobox_result.delete("1.0", tk.END)
            label_combobox_result.insert(tk.END, self.agents[selected_value])
        # scrollbars
        h = tk.Scrollbar(frame, orient = 'horizontal')
        # attach Scrollbar to root window at 
        # the bootom
        h.pack(side = tk.BOTTOM, fill = tk.X)
  
        # create a vertical scrollbar-no need
        # to write orient as it is by
        # default vertical
        v = tk.Scrollbar(frame)
        # attach Scrollbar to root window on 
        # the side
        v.pack(side = tk.RIGHT, fill = tk.Y)

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
        label_combobox_result = tk.Text(frame, xscrollcommand=h, yscrollcommand=v)
        label_combobox_result.pack(pady=5)