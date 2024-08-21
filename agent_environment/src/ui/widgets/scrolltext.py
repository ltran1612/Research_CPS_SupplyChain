import tkinter as tk
from tkinter import ttk

class TextboxWithScrollbars(tk.Frame):
    def __init__(self, root):
        # Create a frame to hold the text widget and scrollbars
        super().__init__(root)

        # Create the text widget
        self.text_widget = tk.Text(self, wrap=tk.NONE)

        # Create vertical scrollbar
        self.vertical_scrollbar = ttk.Scrollbar(self, orient=tk.VERTICAL, command=self.text_widget.yview)
        self.vertical_scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        self.text_widget.config(yscrollcommand=self.vertical_scrollbar.set)

        # Create horizontal scrollbar
        self.horizontal_scrollbar = ttk.Scrollbar(self, orient=tk.HORIZONTAL, command=self.text_widget.xview)
        self.horizontal_scrollbar.pack(side=tk.BOTTOM, fill=tk.X)
        self.text_widget.config(xscrollcommand=self.horizontal_scrollbar.set)
        self.text_widget.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

    def insert_text(self, text):
        """Insert text into the text widget"""
        self.text_widget.insert(tk.END, text)
        self.text_widget.config(state=tk.DISABLED)
    
    def delete_text(self):
        self.text_widget.delete("1.0", tk.END)
    
    def replace_text(self, text):
        self.delete_text()
        self.insert_text(text)

    def get_text(self):
        """Get all the text from the text widget"""
        return self.text_widget.get("1.0", tk.END)
    
