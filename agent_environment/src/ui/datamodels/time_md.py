from typing import Callable
import tkinter as tk
from ui.datamodels.base import DataModel


class TimeModel(DataModel):
    def __init__(self, start=0) -> None:
        super().__init__()
        self.time = start 
        self.start = start

    # load the data from a string
    def load_from_string(self, s):
        self.time = int(s)

    # fill function, to be implemented by child classes
    def fill(self, frame):
        timeLabel = tk.Label(frame, text="0:0")
        timeLabel.pack(side="left", padx=5, pady=5)

        nextButton= tk.Button(frame, text="Next")
        nextButton.pack(side="left", padx=5, pady=5)

        runButton = tk.Button(frame, text="Run")
        runButton.pack(side="left", padx=5, pady=5)