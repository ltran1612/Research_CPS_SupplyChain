import tkinter as tk
from tkinter import ttk

# Create the main application window
root = tk.Tk()
root.title("Tkinter Tabs Example")

# Create a Notebook widget for tabbed views
notebook = ttk.Notebook(root)

# Create frames for each tab
tab1 = ttk.Frame(notebook)
tab2 = ttk.Frame(notebook)
tab3 = ttk.Frame(notebook)
tab4 = ttk.Frame(notebook)

# Add frames to the notebook
notebook.add(tab1, text="Tab 1")
notebook.add(tab2, text="Tab 2")
notebook.add(tab3, text="Tab 3")
notebook.add(tab4, text="Tab 4")

# Pack the notebook widget to fill the main window
notebook.pack(expand=True, fill='both')

# Add content to each tab
# Tab 1 content
label1 = tk.Label(tab1, text="This is the content of Tab 1")
label1.pack(pady=20)

# Tab 2 content with multiple components
def on_combobox_select(event):
    selected_value = combobox.get()
    label_combobox_result.config(text=f"Selected: {selected_value}")

# Create a label for the dropdown menu
label_dropdown = tk.Label(tab2, text="Choose an option:")
label_dropdown.pack(pady=5)

# Create a dropdown menu (combobox)
options = ["Option 1", "Option 2", "Option 3"]
combobox = ttk.Combobox(tab2, values=options)
combobox.pack(pady=5)
combobox.bind("<<ComboboxSelected>>", on_combobox_select)

# Create a label to display the selected value
label_combobox_result = tk.Label(tab2, text="Selected: None")
label_combobox_result.pack(pady=5)

# Create a button
button_tab2 = tk.Button(tab2, text="Click Me", command=lambda: label_button_result.config(text="Button clicked!"))
button_tab2.pack(pady=20)

# Create a label to display the button click result
label_button_result = tk.Label(tab2, text="")
label_button_result.pack(pady=5)

# Tab 3 content
label3 = tk.Label(tab3, text="This is the content of Tab 3")
label3.pack(pady=20)

# Tab 4 content
label4 = tk.Label(tab4, text="This is the content of Tab 4")
label4.pack(pady=20)

# Start the Tkinter event loop
root.mainloop()
