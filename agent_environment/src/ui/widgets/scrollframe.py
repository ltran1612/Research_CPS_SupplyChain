import tkinter as tk

class ScrollableFrame(tk.Frame):
    def __init__(self, container, *args, **kwargs):
        super().__init__(container, *args, **kwargs)

        # Create a canvas
        self.canvas = tk.Canvas(self)
        self.canvas.pack(side="left", fill="both", expand=True)

        # Add a scrollbar to the canvas
        scrollbar = tk.Scrollbar(self, orient="vertical", command=self.canvas.yview)
        scrollbar.pack(side="right", fill="y")

        # Configure the canvas with the scrollbar
        self.canvas.configure(yscrollcommand=scrollbar.set)
        self.canvas.bind('<Configure>', self._on_canvas_configure)

        # Create a frame inside the canvas to hold the scrollable content
        self.scrollable_frame = tk.Frame(self.canvas)
        self.scrollable_frame.bind('<Configure>', self._on_frame_configure)

        # Create a window inside the canvas to hold the scrollable frame
        self.canvas.create_window((0, 0), window=self.scrollable_frame, anchor="nw")

    def _on_frame_configure(self, event):
        # Update the scroll region to encompass the frame contents
        self.canvas.configure(scrollregion=self.canvas.bbox("all"))

    def _on_canvas_configure(self, event):
        # Adjust the frame width to the canvas width
        canvas_width = event.width
        self.canvas.itemconfig("scrollable_frame", width=canvas_width)