from typing import Callable
import tkinter as tk
from ui.datamodels.base import DataModel

class TimeModel(DataModel):
    def __init__(self, start_func=None, pause_func=None, start=0, paused=True) -> None:
        super().__init__()
        self.time = start 
        self.start = start
        self.max = start
        self.timeLabel = None
        self.start_func = start_func
        self.pause_func = pause_func 
        self.paused = paused 
        self.tm_listeners = []

        # set paused or unpaused from the default value

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
    
    # paused 
    def got_paused(self):
        self._set_paused(True)
    # started
    def got_started(self):
        self._set_paused(False)
    def _set_paused(self, paused: bool):
        self.paused = paused 
        for listener in self.tm_listeners:
            listener(paused)

    # fill function, to be implemented by child classes
    def fill(self, frame):
        self.timeLabel = tk.Label(frame, text=self)
        self.timeLabel.pack(side="left", padx=5, pady=5)

        # Create buttons and pack them into the top frame
        # backButton= tk.Button(top_frame, text="Back")
        # backButton.pack(side="left", padx=5, pady=5)
        # nextButton= tk.Button(frame, text="Next")
        # nextButton.pack(side="left", padx=5, pady=5)

        def clicked():
            # call the corresponding
            if self.paused:
                self.start_func()
            else:
                self.pause_func()
        # 
        runButton = tk.Button(frame, text="", command=clicked)
        runButton.pack(side="left", padx=5, pady=5)
        # 
        def update_run_button(paused):
            txt = "Pause"
            if paused:
                txt = "Run"
            runButton.configure(text=txt)
        update_run_button(self.paused)
        self.tm_listeners.append(update_run_button)

        # make sure the env is started or stopped 
        if self.paused:
            self.pause_func()
        else:
            self.start_func()