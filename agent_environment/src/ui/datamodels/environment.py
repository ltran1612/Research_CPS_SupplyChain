from typing import Callable

from ui.datamodels.agents import AgentListModel
from ui.datamodels.base import DataModel
import tkinter as tk

from ui.misc import parse_state_actions

class EnvironmentModel(DataModel):
    def __init__(self, agents: AgentListModel) -> None:
        super().__init__()
        self.agents = agents
        self.state = []
        self.actions = []
        self.state_tbox = None
        self.action_tbox = None

    # load state data from the state 
    # load the data from a string
    def load_from_string(self, s):
        # parse the state
        # parse the action
        self.state, self.actions = parse_state_actions(s)
        self.__display()
    
    def __str__(self):
        return self.state
    
    def __display(self):
        if self.state_tbox is None or self.action_tbox is None:
            return
        print("test display", self.state, self.actions)
        # state 
        self.state_tbox.delete("1.0", tk.END)
        self.state_tbox.insert(tk.END, "\n".join(self.state))

        # actions
        self.action_tbox.delete("1.0", tk.END)
        self.action_tbox.insert(tk.END, "\n".join(self.actions))

    # def 
    # fill function, to be implemented by child classes
    def fill(self, frame):
        # label for state 
        env_label = tk.Label(frame, text="State of the Environment") 
        # label for action 
        action_label = tk.Label(frame, text="Action Right Now") 

        # state environ
        s_frame = tk.Frame(frame)
        # display a text box to show the state in the UI
        h = tk.Scrollbar(s_frame, orient = 'horizontal')
        v = tk.Scrollbar(s_frame)
        # Create a textbox to display the state
        self.state_tbox = tk.Text(s_frame, xscrollcommand=h, yscrollcommand=v)
        h.pack(side = tk.BOTTOM, fill = tk.X)
        v.pack(side = tk.RIGHT, fill = tk.Y)
        self.state_tbox.pack(pady=5)
             
        # action frame
        a_frame =  tk.Frame(frame) 
        # display a text box to show the state in the UI
        ha = tk.Scrollbar(a_frame, orient = 'horizontal')
        va = tk.Scrollbar(a_frame)
        # Create a textbox to display the state
        self.action_tbox = tk.Text(a_frame, xscrollcommand=ha, yscrollcommand=va)
        # 
        ha.pack(side = tk.BOTTOM, fill = tk.X)
        va.pack(side = tk.RIGHT, fill = tk.Y)
        self.action_tbox.pack(pady=5)

        # packings to put them
        env_label.pack()
        s_frame.pack()
        action_label.pack()
        a_frame.pack()

    # handle the update event 
    # TODO: handle the update when it's updated 
    def update(self, event_name): 
        pass

 

 