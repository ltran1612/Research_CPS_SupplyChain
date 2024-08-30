from typing import Callable

from ui.datamodels.agents import AgentListModel
from ui.datamodels.base import DataModel
import tkinter as tk

from ui.misc import parse_state_actions
from ui.widgets.checkbox_table import TableWithCheckboxes
from ui.widgets.scrolltext import TextboxWithScrollbars

class EnvironmentModel(DataModel):
    def __init__(self, agents: AgentListModel) -> None:
        super().__init__()
        self.agents = agents
        self.state = []
        self.actions = []
        self.state_tbox = None
        self.action_tbox = None
        self.actions_checkbox = None

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
        values = list(filter(lambda x: x != "", values))
        self.state_tbox.replace_text("\n".join(values))

        # replace the questions
        self.actions_checkbox.create_table({})

        # actions
        values = list(map(lambda x: x.__str__(), self.actions))
        values = list(filter(lambda x: x != "", values))
        self.action_tbox.replace_text("\n".join(values))


    # load the questions
    def load_questions(self, questions, answer_questions_func=None):
        # get the answer from the UI
        def get_answers_from_ui(data):
            answer = {}
            for agent, accepted in data.items():
                answer[agent] = ""
                if accepted:
                    answer[agent] = questions[agent]
            answer_questions_func(answer)

        # check if the questions are non-empty
        empty = True 
        for action in questions.values():
            if action != "":
                empty = False
                break

        # show the ui and get the answers, when gotten the answers 
        if not empty:
            self.actions_checkbox.create_table(questions, receive_answers_func=get_answers_from_ui)
            return
        
        answer_questions_func(questions)

    # def 
    # fill function, to be implemented by child classes
    def fill(self, frame):
        # label for state 
        env_label = tk.Label(frame, text="State of the Environment") 
        # label for actions checkbox 
        actions_checkbox_label = tk.Label(frame, text="Actions Waiting for Approval") 
        # label for action 
        action_label = tk.Label(frame, text="Actions Executed in the Previous Time Step") 

        # state environ
        self.state_tbox = TextboxWithScrollbars(frame)

        # actions questions
        self.actions_checkbox = TableWithCheckboxes(frame, "Agent", "Actions")

        # action frame
        self.action_tbox = TextboxWithScrollbars(frame)

        # packings to put them
        env_label.pack()
        self.state_tbox.pack()
        #
        actions_checkbox_label.pack()
        self.actions_checkbox.pack()
        #
        action_label.pack()
        self.action_tbox.pack()

    # handle the update event 
    def update(self, event_name): 
        pass

 

 