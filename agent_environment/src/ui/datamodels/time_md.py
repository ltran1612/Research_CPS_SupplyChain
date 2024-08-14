from typing import Callable
import tkinter as tk
from ui.datamodels.base import DataModel


class TimeModel(DataModel):
    def __init__(self, start=0) -> None:
        super().__init__()
        self.time = start 
        self.start = start
        self.max = start
        self.timeLabel = None

    # load the data from a string
    def load_from_string(self, s):
        t = int(s)
        if t == self.max:
            return
            
        self.time = t
        self.max = self.time
        self._update_time() 

    def _update_time(self):
        if self.timeLabel is None:
            return
        # update the label 
        self.timeLabel.config(text=self)
    
    def __str__(self) -> str:
        return f"{self.time}:{self.max}"

    # fill function, to be implemented by child classes
    def fill(self, frame):
        self.timeLabel = tk.Label(frame, text=self)
        self.timeLabel.pack(side="left", padx=5, pady=5)

        nextButton= tk.Button(frame, text="Next")
        nextButton.pack(side="left", padx=5, pady=5)

        runButton = tk.Button(frame, text="Run")
        runButton.pack(side="left", padx=5, pady=5)
    
