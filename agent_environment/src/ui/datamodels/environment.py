from typing import Callable

from ui.datamodels.agents import AgentListModel
from ui.datamodels.base import DataModel

class EnvironmentModel(DataModel):
    def __init__(self, agents: AgentListModel) -> None:
        super().__init__()
        self.agents = agents

    # load state data from the state 
    # load the data from a string
    def load_from_string(self, s):
        pass

    # def 
    # fill function, to be implemented by child classes
    def fill(self, frame):
        pass

    # Abstract
    # handle the update event 
    def update(self, event_name): 
        pass

 

 