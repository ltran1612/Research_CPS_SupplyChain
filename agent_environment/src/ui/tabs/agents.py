import tkinter as tk
from tkinter import ttk

def fill(tab):
    # Tab 2 content with multiple components
    def on_combobox_select(event):
        selected_value = combobox.get()
        label_combobox_result.config(text=f"Selected: {selected_value}")

    # Create a label for the dropdown menu
    label_dropdown = tk.Label(tab, text="Choose an option:")
    label_dropdown.pack(pady=5)

    # Create a dropdown menu (combobox)
    options = ["Option 1", "Option 2", "Option 3"]
    combobox = ttk.Combobox(tab, values=options)
    combobox.pack(pady=5)
    combobox.bind("<<ComboboxSelected>>", on_combobox_select)

    # Create a label to display the selected value
    label_combobox_result = tk.Label(tab, text="Selected: None")
    label_combobox_result.pack(pady=5)

    # Create a button
    button_tab = tk.Button(tab, text="Click Me", command=lambda: label_button_result.config(text="Button clicked!"))
    button_tab.pack(pady=20)

    # Create a label to display the button click result
    label_button_result = tk.Label(tab, text="")
    label_button_result.pack(pady=5)