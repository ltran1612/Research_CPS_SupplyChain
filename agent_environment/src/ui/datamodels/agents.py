import tkinter as tk
from tkinter import ttk

from ui.datamodels.agent import AgentDataModel
from ui.datamodels.base import DataModel
from ui.misc import parse_state_actions
from ui.widgets.scrolltext import TextboxWithScrollbars
class AgentListModel(DataModel):
    def __init__(self) -> None:
        super().__init__()
        # subscribe the individual agent
        self.agents: dict[str, AgentDataModel] = dict() 
        self.cboxes = []
    
    def __contains__(self, agent: str):
        return agent in self.agents
    
    def __getitem__(self, agent: str):
        return self.agents[agent]

    def __setitem__(self, name: str, agent):
        self.agents[name] = agent 
        agent.add_subscriber(self)
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

            # TODO: display local state, plan, and action separately. 
            agent = self.agents[selected_value]
            #
            state = agent.get_state()
            state, _ = parse_state_actions(state)
            values = list(map(lambda x: x.__str__(), state))
            local_state_box.replace_text("\n".join(values))
            #
            plan = agent.get_plan()
            _, actions = parse_state_actions(plan)
            values = list(map(lambda x: x.__str__(), actions))
            plan_box.replace_text("\n".join(values))
            #
            actions = agent.get_action()
            _, actions = parse_state_actions(actions)
            values = list(map(lambda x: x.__str__(), actions))
            action_box.replace_text("\n".join(values))

        # Create a label for the dropdown menu
        label_dropdown = tk.Label(frame, text="Choose an agent to display:")
        label_dropdown.pack(pady=5)

        # Create a dropdown menu (combobox)
        options = list(self.agents.keys())
        combobox = ttk.Combobox(frame, values=options)
        combobox.pack(pady=5)
        combobox.bind("<<ComboboxSelected>>", on_combobox_select)
        # save combobox for updates 
        self.cboxes.append(combobox)

        # labels
        state_label = tk.Label(frame, text="Local State")
        plan_label = tk.Label(frame, text="Plan")
        action_label = tk.Label(frame, text="Attempting Actions")
        # text box for local state, plan, and action 
        # assign a new xcroll command
        local_state_box = TextboxWithScrollbars(frame)
        plan_box = TextboxWithScrollbars(frame)
        action_box = TextboxWithScrollbars(frame)
        # packing
        state_label.pack()
        local_state_box.pack(pady=5)
        #
        plan_label.pack()
        plan_box.pack(pady=5)
        #
        action_label.pack()
        action_box.pack(pady=5)
