import logging
from tkinter import ttk
from ui.datamodels.base import DataModel
import tkinter as tk

from ui.widgets.checkbox_viewtable import CheckBoxViewTable
from ui.widgets.scrollframe import ScrollableFrame
from ui.widgets.scrolltext import TextboxWithScrollbars

class ConcernModel(DataModel):
    def __init__(self) -> None:
        super().__init__()
        self.data = {
            "clause": {},
            # also called, requirement
            "property": {},
            "concern": {},
        }
        self.ui_updates = []

    def __str__(self):
        def group_str(group: dict[str, bool], title):
            sats = []
            notsats = []
            for name, status in group.items(): 
                if status:
                    sats.append("+"+name)
                    continue
                notsats.append("+"+name)

            res = [f"The satisfied {title}(s) are:"]
            res.append("\n".join(sats))
            res.append(f"The non-satisfied {title}(s) are:")
            res.append("\n".join(notsats))

            return "\n\n".join(res)
            
        res = []
        for ctgry, group in self.data.items():
            res.append(group_str(group, ctgry))
        return "\n".join(res)

    # Abstract
    # load the data from a string
    def load_from_string(self, s):
        # concerns
        # requirements
        # clauses 
        lines: list[str] = s.split("\n")
        for line in lines:
            # if in the corresponding things
            status, thetype, name = line.split("-", 3)
            # strip 
            name = name.strip()
            # status
            status = True if status == "yes" else False
            # update the status
            group = self.data[thetype]
            # status of a concern, clause, or property was updated from false to true
            if name in group and group[name] == True and status == False:
                logging.error("something is wrong")
                raise NotImplementedError("Not tested yet")
            
            # add to group
            group[name] = status
        # update
        for update_func in self.ui_updates:
            update_func(self.data)
        

    # fill function, to be implemented by child classes
    def fill(self, frame):
        scanvas = ScrollableFrame(frame) 

        # clauses 
        clauses = CheckBoxViewTable(scanvas.scrollable_frame)

        # requirements
        reqs = CheckBoxViewTable(scanvas.scrollable_frame)
        # concerns
        concerns = CheckBoxViewTable(scanvas.scrollable_frame)

        # clauses
        label = tk.Label(scanvas.scrollable_frame, text="Clauses")
        #
        label.pack(anchor="nw")
        clauses.pack(anchor="nw")
        # requirements
        label = tk.Label(scanvas.scrollable_frame, text="Requirements")
        label.pack(anchor="nw")
        reqs.pack(anchor="nw")
        # concerns
        label = tk.Label(scanvas.scrollable_frame, text="Concerns")
        label.pack(anchor="nw")
        concerns.pack(anchor="nw")

        # 
        scanvas.pack(fill="both", expand="True")

        def update_content(data):
            for ctgry, group in data.items():
                sat_box = None
                notsat_box = None
                box = None
                # clause
                if ctgry == "clause":
                    box = clauses
                # requirement/property
                elif ctgry == "property":
                    box = reqs
                # concerns
                elif ctgry == "concern":
                    box = concerns
                # unknown type
                else:
                    logging.error("In concern model, unknown type of data.")
                # 
                if box is not None and len(group) > 0:
                    box.update_values(group)

        
        update_content(self.data)
        self.ui_updates.append(update_content)