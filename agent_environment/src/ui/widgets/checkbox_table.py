import tkinter as tk
from tkinter import ttk

class TableWithCheckboxes(tk.Frame):
    def __init__(self, parent, header1="Key", header2="Value"):
        super().__init__(parent)
        self.check_vars = []
        self.table_widgets = []
        self.headers = [header1, header2, "Selected"]
        self.receive_answers_func = None
        self.create_table({})

    def create_table(self, data, receive_answers_func=None):
        # Clear existing table if needed
        self.clear_table()
        # update
        self.receive_answers_func = receive_answers_func 

        # Create a table header
        for idx, header in enumerate(self.headers):
            label = tk.Label(self, text=header, font=("Arial", 12, "bold"))
            label.grid(row=0, column=idx)
            self.table_widgets.append(label)

        row_idx = 0 
        # Create rows with data and checkboxes
        for row_idx, (key, value) in enumerate(data.items(), start=1):
            if value != "":
                # Key
                key_label = tk.Label(self, text=key, font=("Arial", 12))
                key_label.grid(row=row_idx, column=0)
                self.table_widgets.append(key_label)

                # Value
                value_label = tk.Label(self, text=value, font=("Arial", 12))
                value_label.grid(row=row_idx, column=1)
                self.table_widgets.append(value_label)

                # Checkbox
                var = tk.BooleanVar(value=True)
                checkbox = tk.Checkbutton(self, variable=var)
                checkbox.grid(row=row_idx, column=2)
                self.table_widgets.append(checkbox)
                self.check_vars.append((key, var))
                continue

            var = tk.BooleanVar(value=False)
            self.check_vars.append((key, var))

        # Add an update button
        update_button = ttk.Button(self, text="Accept", command=self.update_values)
        update_button.grid(row=row_idx + 1, column=1, pady=10)
        self.table_widgets.append(update_button)

    def clear_table(self):
        # Remove all widgets from the table
        for widget in self.table_widgets:
            widget.destroy()

        # Clear the variables
        self.check_vars = []
        self.table_widgets = []

    def update_values(self):
        # Collect the values from the checkboxes and display them
        result = {key: var.get() for key, var in self.check_vars}
        if self.receive_answers_func is None:
            return
        self.receive_answers_func(result)
        