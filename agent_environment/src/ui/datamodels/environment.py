from typing import Callable

from ui.datamodels.agents import AgentListModel
from ui.datamodels.base import DataModel
import tkinter as tk

class EnvironmentModel(DataModel):
    def __init__(self, agents: AgentListModel) -> None:
        super().__init__()
        self.agents = agents
        self.state = "" 
        self.label_state = None

    # load state data from the state 
    # load the data from a string
    def load_from_string(self, s):
        self.state = s
        self.__display()
    
    def __str__(self):
        return self.state
    
    def __display(self):
        if self.label_state is None:
            return
        self.label_state.delete("1.0", tk.END)
        self.label_state.insert(tk.END, self)

    # def 
    # fill function, to be implemented by child classes
    def fill(self, frame):
        # TODO: display a text box to show the state in the UI
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

        # Create a label to display the selected value
        self.label_state = tk.Text(frame, xscrollcommand=h, yscrollcommand=v)
        self.label_state.pack(pady=5)

    # handle the update event 
    # TODO: handle the update when it's updated 
    def update(self, event_name): 
        pass

 

 