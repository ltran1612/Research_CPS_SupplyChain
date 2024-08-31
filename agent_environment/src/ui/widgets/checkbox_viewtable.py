import tkinter as tk

# this class works on the assumption that the data  includes both non-satisfied and satisfied
class CheckBoxViewTable(tk.Frame):
    def __init__(self, parent, items_dict=None):
        super().__init__(parent)

        self.check_vars = None  # Dictionary to hold BooleanVars for each checkbox
        self.update_values(items_dict)

        
    def update_values(self, data: dict[str, bool]):
        if data is None:
            return
        if self.check_vars is None: 
            self.check_vars = {}
            # Iterate over items in the dictionary and create checkboxes
            for item, initial_state in data.items():
                var = tk.BooleanVar(value=initial_state)  # Create a BooleanVar for each item
                self.check_vars[item] = var  # Store the BooleanVar in the dictionary

                # Create the Checkbutton widget for each item
                checkbox = tk.Checkbutton(self, text=item, variable=var, justify="left")
                checkbox.config(state='disabled')
                checkbox.pack(pady=5, anchor="nw")

        for key, value in data.items():
            if key not in self.check_vars:
                raise RuntimeError("The concerns contain data previously not present")
            self.check_vars[key].set(value)

