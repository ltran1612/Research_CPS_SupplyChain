import logging
from ui.datamodels.base import DataModel
import tkinter as tk

class ConcernModel(DataModel):
    def __init__(self) -> None:
        super().__init__()
        self.data = {
            "concern": {},
            "property": {},
            "clause": {}
        }
        self.label = None

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
        if self.label is not None:
            self.label.config(text=self)

    # fill function, to be implemented by child classes
    def fill(self, frame):
        self.label = tk.Label(frame, text=self.__str__())
        self.label.pack(pady=20)