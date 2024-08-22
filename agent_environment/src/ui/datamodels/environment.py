from typing import Callable

from ui.datamodels.agents import AgentListModel
from ui.datamodels.base import DataModel
import tkinter as tk

from ui.misc import parse_state_actions
from ui.widgets.scrolltext import TextboxWithScrollbars

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
        values = list(map(lambda x: x.__str__(), self.state))
        self.state_tbox.replace_text("\n".join(values))

        # actions
        values = list(map(lambda x: x.__str__(), self.actions))
        self.action_tbox.replace_text("\n".join(values))

    # def 
    # fill function, to be implemented by child classes
    def fill(self, frame):
        # label for state 
        env_label = tk.Label(frame, text="State of the Environment") 
        # label for action 
        action_label = tk.Label(frame, text="Actions Executed in the Previous Time Step") 

        # state environ
        self.state_tbox = TextboxWithScrollbars(frame)
             
        # action frame
        self.action_tbox = TextboxWithScrollbars(frame)

        # packings to put them
        env_label.pack()
        self.state_tbox.pack()
        action_label.pack()
        self.action_tbox.pack()

    # handle the update event 
    def update(self, event_name): 
        pass

 

 