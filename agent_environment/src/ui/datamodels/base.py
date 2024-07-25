from typing import Callable


class DataModel:
    def __init__(self) -> None:
        self.subscribers: list[DataModel] = set()
    # Abstract
    # load the data from a string
    def load_from_string(self, s):
        pass

    # def 
    # Abstract
    # fill function, to be implemented by child classes
    def fill(self, frame):
        pass

    # Abstract
    # handle the update event 
    def update(self, event_name): 
        pass

    def _notify_subscribers(self, event_name: str):
        for sub in self.subscribers:
            sub.update(event_name)

    # subscribe to a function
    def subscribe(self, obj):
        self.subscribers.add(obj)

    # remove a subscriber 
    def remove_subscriber(self, obj):
        self.subscribers.remove(obj)